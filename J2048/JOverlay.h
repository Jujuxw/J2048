//
//  Overlay.h
//  Copy_2048
//
//  Created by juju on 2016/11/4.
//  Copyright © 2016年 juju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JOverlay : UIView

@property (nonatomic, weak) IBOutlet UILabel *message;

@property (nonatomic, weak) IBOutlet UIButton *restartGame;

@property (nonatomic, weak) IBOutlet UIButton *keepPlaying;

@end
