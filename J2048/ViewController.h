//
//  ViewController.h
//  J2048
//
//  Created by juju on 2016/12/16.
//  Copyright © 2016年 juju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface ViewController : UIViewController

- (void)updateScore:(NSInteger)score;

- (void)endGame:(BOOL)won;

@end


