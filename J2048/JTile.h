//
//  Tile.h
//  Copy_2048
//
//  Created by juju on 2016/11/5.
//  Copyright © 2016年 juju. All rights reserved.
//

//#import "JGlobalState.h"
@import SpriteKit;
@class JCell;

@interface JTile : SKShapeNode

@property (nonatomic) NSInteger level;

@property (nonatomic, weak) JCell *cell;


+ (JTile *)insertNewTileToCell:(JCell *)cell;

- (void)commitPendingActions;

- (BOOL)canMergeWithTile:(JTile *)tile;

- (NSInteger)mergeToTile:(JTile *)tile;

- (NSInteger)merge3ToFile:(JTile *)tile andTile:(JTile *)furtherTile;

- (void)moveToCell:(JCell *)cell;

- (void)removeAnimated:(BOOL)animated;

@end
