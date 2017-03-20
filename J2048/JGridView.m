//
//  GridView.m
//  Copy_2048
//
//  Created by juju on 2016/11/4.
//  Copyright © 2016年 juju. All rights reserved.
//

#import "JGridView.h"

@implementation JGridView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [GSTATE scoreBoardColor];
        self.layer.cornerRadius = GSTATE.cornerRadius;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (instancetype)init
{
    NSInteger side = GSTATE.dimension * (GSTATE.titleSize + GSTATE.borderWidth) + GSTATE.borderWidth;
    CGFloat verticalOffset = [[UIScreen mainScreen] bounds].size.height - GSTATE.verticalOffset;
    return [self initWithFrame:CGRectMake(GSTATE.horizontalOffset, verticalOffset - side, side, side)];
}
//设置每个小窗格
+ (UIImage *)gridImageWithGrid:(JGrid *)grid {
    UIView *backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    backgroundView.backgroundColor = [GSTATE backgroundColor];
    
    JGridView *view = [[JGridView alloc] init];
    [backgroundView addSubview:view];
    
    [grid forEach:^(MPositions position) {
        CALayer *layer = [CALayer layer];
        
        CGPoint point = [GSTATE locationOfPosition:position];
        
        CGRect frame = layer.frame;
        
        frame.size = CGSizeMake(GSTATE.titleSize, GSTATE.titleSize);
        
        frame.origin = CGPointMake(point.x, [[UIScreen mainScreen] bounds].size.height - point.y - GSTATE.titleSize);
        
        layer.frame = frame;
        
        layer.backgroundColor = [GSTATE boardColor].CGColor;
        
        layer.cornerRadius = GSTATE.cornerRadius;
        
        layer.masksToBounds = YES;
        
        [backgroundView.layer addSublayer:layer];
    } reverseOrder:NO];
    
    return [JGridView snapshotWithView:backgroundView];
}

+ (UIImage *)gridImageWithOverlay {
    UIView *backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    backgroundView.backgroundColor = [UIColor clearColor];
    backgroundView.opaque = NO;
    
    JGridView *view = [[JGridView alloc] init];
    view.backgroundColor = [[GSTATE backgroundColor] colorWithAlphaComponent:0.8];
    [backgroundView addSubview:view];
    
    return [JGridView snapshotWithView:backgroundView];
}

+ (UIImage *)snapshotWithView: (UIView *)view {
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size, view.opaque, 0.0);
    
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
