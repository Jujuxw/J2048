//
//  ScroView.h
//  Copy_2048
//
//  Created by juju on 2016/11/4.
//  Copyright © 2016年 juju. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "JGlobalState.h"

@interface JScroView : UIView
@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *score;

- (void)updateAppearance;

@end
