//
//  Grid.m
//  Copy_2048
//
//  Created by juju on 2016/11/5.
//  Copyright © 2016年 juju. All rights reserved.
//

//#import <stdlib.h>
#import "stdlib.h"

#import "JGird.h"
#import "JTile.h"
#import "JScene.h"

@interface JGrid ()

@property (nonatomic, readwrite) NSInteger dimension;

@end

@implementation JGrid
{
    NSMutableArray *_grid;
}

- (instancetype)initWithDimension:(NSInteger)dimension {
    if (self = [super init]) {
        _grid = [[NSMutableArray alloc] initWithCapacity:dimension];
        
        for (NSInteger i = 0; i < dimension; i++) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:dimension];
            
            for (NSInteger j = 0; j < dimension; j++) {
                [array addObject:[[JCell alloc] initWithPosition:MPositionMake(i, j)]];
            }
            [_grid addObject:array];
        }
        self.dimension = dimension;
    }
    return self;
}

- (void)forEach:(InteratorBlock)block reverseOrder:(BOOL)reverse {
    if (!reverse) {
        for (NSInteger i = 0; i < self.dimension; i++) {
            for (NSInteger j = 0; j < self.dimension; j++) {
                block(MPositionMake(i, j));
            }
        }
    }else {
        for (NSInteger i = self.dimension - 1; i >= 0; i--) {
            for (NSInteger j = self.dimension - 1; j >= 0; j--) {
                block(MPositionMake(i, j));
            }
        }
    }
}

- (JCell *)cellAtPosition:(MPositions)position {
    if (position.x >= self.dimension || position.y >= self.dimension || position.x < 0 || position.y < 0) {
        return nil;
    }
    return [[_grid objectAtIndex:position.x] objectAtIndex:position.y];
}


- (JTile *)tileAtPosition:(MPositions)position {
    JCell *cell = [self cellAtPosition:position];
    return cell ? cell.tile : nil;
}

- (BOOL)hasAvailableCells {
    return [self availableCells].count != 0;
}

- (JCell *)randomAvailableCell {
    NSArray *availableCells = [self availableCells];
    
    if (availableCells.count) {
        return [availableCells objectAtIndex:arc4random_uniform((int)availableCells.count)];
    }
    return nil;
    
}

- (NSArray *)availableCells {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:self.dimension * self.dimension];
    
    [self forEach:^(MPositions position) {
        JCell *cell = [self cellAtPosition:position];
        
        if (!cell.tile) {
            [array addObject:cell];
        }
    } reverseOrder:NO];
    
    return array;
}

- (void)insertTileAtRandomAvailablePositionWithDelay:(BOOL)delay {
    
    JCell *cell = [self randomAvailableCell];
    
    if (cell) {
        JTile *tile = [JTile insertNewTileToCell:cell];
        
        [self.scene addChild:tile];
        
        SKAction *delayAction = delay ? [SKAction waitForDuration:GSTATE.animationDuration * 3] : [SKAction waitForDuration:0];
        
        SKAction *move = [SKAction moveBy:CGVectorMake(- GSTATE.titleSize / 2, - GSTATE.titleSize / 2) duration:GSTATE.animationDuration];
        
        SKAction *scale = [SKAction scaleTo:1 duration:GSTATE.animationDuration];
        
        [tile runAction:[SKAction sequence:@[delayAction,[SKAction group:@[move,scale]]]]];
    }
}

- (void)removeAllTilesAnimated:(BOOL)animated {
    [self forEach:^(MPositions position) {
        JTile *tile = [self tileAtPosition:position];
        
        if (tile) {
            [tile removeAnimated:animated];
        }
    } reverseOrder:NO];
}

@end
