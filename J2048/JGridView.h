//
//  GridView.h
//  Copy_2048
//
//  Created by juju on 2016/11/4.
//  Copyright © 2016年 juju. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "JGlobalState.h"
#import "JGird.h"

@class JGrid;

@interface JGridView : UIView

+ (UIImage *)gridImageWithGrid: (JGrid *)grid;

+ (UIImage *)gridImageWithOverlay;

@end
