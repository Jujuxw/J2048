//
//  Tile.m
//  Copy_2048
//
//  Created by juju on 2016/11/5.
//  Copyright © 2016年 juju. All rights reserved.
//

#include <stdlib.h>

#import "JTile.h"
#import "JCell.h"

typedef void (^Block)();

@implementation JTile
{
    SKLabelNode *_value;
    
    NSMutableArray *_pendingActions;
    
    Block _pendingBlock;
}


+ (JTile *)insertNewTileToCell:(JCell *)cell {
    JTile *tile = [[JTile alloc] init];
    
    CGPoint origin = [GSTATE locationOfPosition:cell.position];
    
    tile.position = CGPointMake(origin.x + GSTATE.titleSize/2, origin.y + GSTATE.titleSize / 2);
    [tile setScale:0];
    
    cell.tile = tile;
    return tile;
}

- (instancetype)init {
    if (self = [super init]) {
        CGRect rect = CGRectMake(0, 0, GSTATE.titleSize, GSTATE.titleSize);
        CGPathRef rectPath = CGPathCreateWithRoundedRect(rect, GSTATE.cornerRadius, GSTATE.cornerRadius, NULL);
        self.path = rectPath;
        CFRelease(rectPath);
        self.lineWidth = 0;
    }
    
    _pendingActions = [[NSMutableArray alloc] init];
    
    _value = [SKLabelNode labelNodeWithFontNamed:[GSTATE boldFontName]];
    _value.position = CGPointMake(GSTATE.titleSize / 2, GSTATE.titleSize / 2);
    _value.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    _value.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    [self addChild:_value];
    
    if (GSTATE.gameType == GameTypeFibonacci) {
        self.level = arc4random_uniform(100) < 40 ? 1 : 2;
    }else {
        self.level = arc4random_uniform(100) < 95 ? 1: 2;
    }
    
    [self refreshValue];
    return self;
}

- (void)refreshValue {
    long value = [GSTATE valueForLevel:self.level];
    _value.text = [NSString stringWithFormat:@"%ld",value];
    _value.fontColor = [GSTATE textColorForLevel:self.level];
    _value.fontSize = [GSTATE textSizeForValue:self.level];
    
    self.fillColor = [GSTATE colorForLevel:self.level];
}

- (void)removeFromParentCell {
    if (self.cell.tile == self) {
        self.cell.tile = nil;
    }
}

- (BOOL)hasPendingMerge {
    return _pendingActions.count > 1;
}

- (void)commitPendingActions {
    [self runAction:[SKAction sequence:_pendingActions] completion:^{
        [_pendingActions removeAllObjects];
        if (_pendingBlock) {
            _pendingBlock();
            _pendingBlock = nil;
        }
    }];
}

- (BOOL)canMergeWithTile:(JTile *)tile {
    if (!tile) {
        return NO;
    }
    return [GSTATE isLevel:self.level mergeableWithLevel:tile.level];
}

- (NSInteger)mergeToTile:(JTile *)tile {
    if (!tile || [tile hasPendingMerge] ) {
        return 0;
    }
    
    NSInteger newLevel = [GSTATE mergeLevel:self.level withLevel:tile.level];
    if (newLevel > 0) {
        [self moveToCell:tile.cell];
        
        [tile removeWithDelay];
        
        [self updateLevelTo:newLevel];
    }
    return newLevel;
}


- (NSInteger)merge3ToFile:(JTile *)tile andTile:(JTile *)furtherTile; {
    if (!tile || [tile hasPendingMerge] || [furtherTile hasPendingMerge]) {
        return 0;
    }
    
    NSInteger newLevel = MIN([GSTATE mergeLevel:self.level withLevel:tile.level], [GSTATE mergeLevel:tile.level withLevel:furtherTile.level]);
    
    if (newLevel > 0) {
        [tile moveToCell:furtherTile.cell];
        [self moveToCell:furtherTile.cell];
        
        [tile removeWithDelay];
        [furtherTile removeWithDelay];
        
        [self updateLevelTo:newLevel];
        [_pendingActions addObject:[self pop]];
    }
    return newLevel;
}


- (void)moveToCell:(JCell *)cell {
    [_pendingActions addObject:[SKAction moveTo:[GSTATE locationOfPosition:cell.position] duration:GSTATE.animationDuration]];
    self.cell.tile = nil;
    cell.tile = self;
}

- (void)removeAnimated:(BOOL)animated {
    if (animated) {
        [_pendingActions addObject:[SKAction scaleTo:0 duration:GSTATE.animationDuration]];
    }
    [_pendingActions addObject:[SKAction removeFromParent]];
    __weak typeof(self) weakSelf = self;
    _pendingBlock = ^ {
        [weakSelf removeFromParentCell];
    };
    [self commitPendingActions];
}

- (void)removeWithDelay {
    SKAction *wait = [SKAction waitForDuration:GSTATE.animationDuration];
    SKAction *remove = [SKAction removeFromParent];
    [self runAction:[SKAction sequence:@[wait,remove]] completion:^{
        [self removeFromParentCell];
    }];
}

- (void)updateLevelTo:(NSInteger)newLevel {
    self.level = newLevel;
    [_pendingActions addObject:[SKAction runBlock:^{
        [self refreshValue];
    }]];
}

- (SKAction *)pop {
    CGFloat d = 0.15 * GSTATE.titleSize;
    SKAction *wait = [SKAction waitForDuration:GSTATE.animationDuration / 3];
    SKAction *enlarge = [SKAction scaleTo:1.3 duration:GSTATE.animationDuration / 1.5];
    SKAction *move = [SKAction moveBy:CGVectorMake(-d, -d) duration:GSTATE.animationDuration / 1.5];
    SKAction *restore = [SKAction scaleTo:1 duration:GSTATE.animationDuration];
    SKAction *moveBack = [SKAction moveBy:CGVectorMake(d, d) duration:GSTATE.animationDuration];
    
    return [SKAction sequence:@[wait,[SKAction group:@[enlarge, move]],
                                [SKAction group:@[restore, moveBack]]]];
}

@end
