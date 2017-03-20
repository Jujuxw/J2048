//
//  Postion.h
//  Copy_2048
//
//  Created by juju on 2016/11/5.
//  Copyright © 2016年 juju. All rights reserved.
//

#ifndef Postion_h
#define Postion_h


typedef struct Position {
    NSInteger x;
    NSInteger y;
} MPositions;

MPositions MPositionMake(NSInteger x, NSInteger y) {
    MPositions position;
    position.x = x;
    position.y = y;
    return position;
}

#endif /* Postion_h */
