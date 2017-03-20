//
//  GameManager.h
//  Copy_2048
//
//  Created by juju on 2016/11/5.
//  Copyright © 2016年 juju. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JScene;
@class JGrid;

typedef NS_ENUM(NSInteger, Direction){
    DirectionUp,
    DirectionLeft,
    DirectionDown,
    DirectionRight
};

@interface JGameManager : NSObject

- (void)startNewSessionWithScene:(JScene *)scene;

- (void)moveToDirection:(Direction)direction;

@end
