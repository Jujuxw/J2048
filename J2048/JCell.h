//
//  Cell.h
//  Copy_2048
//
//  Created by juju on 2016/11/5.
//  Copyright © 2016年 juju. All rights reserved.
//

@import Foundation;
//#import "JPostion.h"

@class JTile;


@interface JCell : NSObject

@property (nonatomic) MPositions position;

@property (nonatomic, strong) JTile *tile;

- (instancetype)initWithPosition:(MPositions)position;

@end
