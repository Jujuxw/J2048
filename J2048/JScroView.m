//
//  ScroView.m
//  Copy_2048
//
//  Created by juju on 2016/11/4.
//  Copyright © 2016年 juju. All rights reserved.
//

#import "JScroView.h"

@implementation JScroView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)updateAppearance{
    self.backgroundColor = [GSTATE scoreBoardColor];
    self.title.font = [UIFont fontWithName:[GSTATE boldFontName] size:12];
    self.score.font = [UIFont fontWithName:[GSTATE regulatForName] size:16];
}

- (void)commonInit {
    self.layer.cornerRadius = GSTATE.cornerRadius;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor greenColor];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
