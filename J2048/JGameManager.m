//
//  GameManager.m
//  Copy_2048
//
//  Created by juju on 2016/11/5.
//  Copyright © 2016年 juju. All rights reserved.
//

#import "JGameManager.h"

#import "JGird.h"
#import "JTile.h"
#import "JScene.h"
#import "ViewController.h"

BOOL iterate(NSInteger value, BOOL countUp, NSInteger upper, NSInteger lower){
    return countUp ? value < upper :value > lower;
}

@implementation JGameManager
{
    BOOL _over;
    BOOL _won;
    BOOL _keepPlaying;
    NSInteger _score;
    NSInteger _pendingScore;
    JGrid *_grid;
    CADisplayLink *_addTileDisplayLink;
}

- (void)startNewSessionWithScene:(JScene *)scene {
    if (_grid) {
        [_grid removeAllTilesAnimated:NO];
    }
    
    if (!_grid || _grid.dimension != GSTATE.dimension) {
        
        _grid = [[JGrid alloc] initWithDimension:GSTATE.dimension];
        
        _grid.scene = scene;
    }
    
    [scene loadBoardWithGrid:_grid];
    
    _score = 0;
    _over = NO;
    _won = NO;
    _keepPlaying = NO;
    
    _addTileDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(addTwoRandomTiles)];
    
    [_addTileDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)addTwoRandomTiles {
    if (_grid.scene.children.count <= 1) {
        [_grid insertTileAtRandomAvailablePositionWithDelay:NO];
        [_grid insertTileAtRandomAvailablePositionWithDelay:NO];
        [_addTileDisplayLink invalidate];
    }
}

- (void)moveToDirection:(Direction)direction {
    
    __block JTile *tile = nil;
    
    BOOL reverse = direction == DirectionUp || direction == DirectionRight;
    
    NSInteger unit = reverse ? 1 : -1;
    
    if (direction == DirectionUp || direction == DirectionDown) {
        [_grid forEach:^(MPositions position) {
            if ((tile = [_grid tileAtPosition:position])) {
                NSInteger target = position.x;
                
                for (NSInteger i = position.x + unit; iterate(i, reverse, _grid.dimension, -1); i += unit) {
                    JTile *t = [_grid tileAtPosition:MPositionMake(i, position.y)];
                    
                    if (!t) {
                        target = i;
                    }else {
                        NSInteger level = 0;
                        
                        if (GSTATE.gameType == GameTypePowerOf3) {
                            MPositions further = MPositionMake(i + unit, position.y);
                            
                            JTile *ft = [_grid tileAtPosition:further];
                            
                            if (ft) {
                                level = [tile merge3ToFile:t andTile:ft];
                            }
                        }else {
                            level = [tile mergeToTile:t];
                        }
                        
                        if (level) {
                            target = position.x;
                            _pendingScore = [GSTATE valueForLevel:level];
                        }
                        break;
                    }
                }
                
                if (target != position.x) {
                    [tile moveToCell:[_grid cellAtPosition:MPositionMake(target, position.y)]];
                    _pendingScore ++;
                }
            }
        } reverseOrder:reverse];
    }else {
        
        [ _grid forEach:^(MPositions position) {
            if ((tile = [_grid tileAtPosition:position])) {
                NSInteger target = position.y;
                
                for (NSInteger i = position.y +unit; iterate(i, reverse, _grid.dimension, -1); i += unit) {
                    JTile *t = [_grid tileAtPosition:MPositionMake(position.x, i)];
                    
                    if (!t) {
                        target = i;
                    }else {
                        NSInteger level = 0;
                        
                        if (GSTATE.gameType == GameTypePowerOf3) {
                            MPositions further = MPositionMake(position.x, i);
                            
                            JTile *ft = [_grid tileAtPosition:further];
                            
                            if (ft) {
                                level = [tile merge3ToFile:t andTile:ft];
                            }
                        }else {
                            level = [tile mergeToTile:t];
                        }
                        if (level) {
                            target = position.y;
                            _pendingScore = [GSTATE valueForLevel:level];
                        }
                        break;
                    }
                }
                
                if (target != position.y) {
                    [tile moveToCell:[_grid cellAtPosition:MPositionMake(position.x, target)]];
                    
                    _pendingScore ++;
                }
            }
        } reverseOrder:reverse];
    }
    
    if (!_pendingScore) {
        return;
    }
    
    [_grid forEach:^(MPositions position) {
        JTile *tile = [_grid tileAtPosition:position];
        
        if (tile) {
            [tile commitPendingActions];
            
            if (tile.level >= GSTATE.winningLevel) {
                _won = YES;
            }
        }
    } reverseOrder:reverse];
    
    [self materializePendingScore];
    
    if (!_keepPlaying && _won) {
        _keepPlaying = YES;
        
        [_grid.scene.controller endGame:YES];
    }
    
    [_grid insertTileAtRandomAvailablePositionWithDelay:YES];
    
    if (GSTATE.dimension == 5 && GSTATE.gameType == GameTypePowerOf2) {
        [_grid insertTileAtRandomAvailablePositionWithDelay:YES];
    }
    
    if (![self movesAvailable]) {
        [_grid.scene.controller endGame:NO];
    }
}

- (void)materializePendingScore {
    
    _score += _pendingScore;
    
    _pendingScore = 0;
    
    [_grid.scene.controller updateScore:_score];
}

- (BOOL)movesAvailable {
    
    return [_grid hasAvailableCells] || [self adjacentMatchesAvaliable];
    
}

- (BOOL)adjacentMatchesAvaliable {
    
    for (NSInteger i = 0; i < _grid.dimension; i++) {
        for (NSInteger j = 0; j < _grid.dimension; j++) {
            JTile *tile = [_grid tileAtPosition:MPositionMake(i, j)];
            
            if (!tile) {
                continue;
            }
            
            if (GSTATE.gameType == GameTypePowerOf3) {
                if ((([tile canMergeWithTile:[_grid tileAtPosition:MPositionMake((i + 1), j)]]
                      && [tile canMergeWithTile:[_grid tileAtPosition:MPositionMake(i + 2, j)]])
                     || ([tile canMergeWithTile:[_grid tileAtPosition:MPositionMake(i, j + 1)]]
                         && [tile canMergeWithTile:[_grid tileAtPosition:MPositionMake(i, j + 2)]]))) {
                         return YES;
                     }
            }
        }
    }
    return NO;
}
@end
