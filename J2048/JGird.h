//
//  Grid.h
//  Copy_2048
//
//  Created by juju on 2016/11/5.
//  Copyright © 2016年 juju. All rights reserved.
//

@import Foundation;
#import "JCell.h"
@class JScene;

typedef void (^InteratorBlock)(MPositions);

@interface JGrid : NSObject

@property (nonatomic, readonly) NSInteger dimension;

@property (nonatomic, weak) JScene *scene;

- (instancetype)initWithDimension:(NSInteger)dimension;

- (void)forEach:(InteratorBlock)block reverseOrder:(BOOL)reverse;

- (JCell *)cellAtPosition:(MPositions)position;

- (JTile *)tileAtPosition:(MPositions)position;

- (BOOL)hasAvailableCells;

- (void)insertTileAtRandomAvailablePositionWithDelay:(BOOL)delay;

- (void)removeAllTilesAnimated:(BOOL)animated;

@end
