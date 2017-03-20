//
//  Cell.m
//  Copy_2048
//
//  Created by juju on 2016/11/5.
//  Copyright © 2016年 juju. All rights reserved.
//

#import "JCell.h"
#import "JTile.h"

@implementation JCell

- (instancetype)initWithPosition:(MPositions)position {
    if (self = [super init]) {
        self.position = position;
        self.tile = nil;
    }
    return self;
}

- (void)setTile:(JTile *)tile {
    _tile = tile;
    if (tile) {
        tile.cell = self;
    }
}

@end
