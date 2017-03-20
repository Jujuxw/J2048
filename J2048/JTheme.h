//
//  Theme.h
//  Copy_2048
//
//  Created by juju on 2016/11/5.
//  Copyright © 2016年 juju. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@protocol JTheme <NSObject>

+ (UIColor *)boardColor;

+ (UIColor *)backgroundColor;

+ (UIColor *)scoreBoardColor;

+ (UIColor *)buttonColor;

+ (NSString *)boldFontName;

+ (NSString *)regularFontName;

+ (UIColor *)colorForLevel:(NSInteger)level;

+ (UIColor *)textColorForLevel:(NSInteger)level;

@end


@interface JTheme : NSObject

+ (Class)themeClassForType:(NSInteger)type;

@end
