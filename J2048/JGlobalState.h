//
//  GlobalState.h
//  Copy_2048
//
//  Created by juju on 2016/11/5.
//  Copyright © 2016年 juju. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>
#import "JPosition.h"

#define GSTATE [JGlobalState state]
#define Settings [NSUserDefaults standardUserDefaults]
#define NotifCtr [NSNotificationCenter defaultCenter]

typedef NS_ENUM(NSInteger, GameType) {
    GameTypeFibonacci = 2,
    GameTypePowerOf2 = 0,
    GameTypePowerOf3 = 1
};

@interface JGlobalState : NSObject

@property (nonatomic, readonly) NSInteger dimension;
@property (nonatomic, readonly) NSInteger winningLevel;
@property (nonatomic, readonly) NSInteger titleSize;
@property (nonatomic, readonly) NSInteger borderWidth;
@property (nonatomic, readonly) NSInteger cornerRadius;
@property (nonatomic, readonly) NSInteger horizontalOffset;
@property (nonatomic, readonly) NSInteger verticalOffset;
@property (nonatomic, readonly) NSTimeInterval animationDuration;
@property (nonatomic, readonly) GameType gameType;

@property (nonatomic) BOOL needRefresh;

+ (JGlobalState *)state;
//加载反映用户的选择
- (void)loadGlobalState;
//判断两个是否可以互相叠合
- (BOOL)isLevel:(NSInteger)level1 mergeableWithLevel:(NSInteger)level2;
//叠合之后的数据
- (NSInteger)mergeLevel:(NSInteger)level1 withLevel:(NSInteger)level2;
//每个level的值
- (NSInteger)valueForLevel:(NSInteger)level;
//每个level的背景颜色
- (UIColor *)colorForLevel:(NSInteger)level;
//每个level数字的颜色
- (UIColor *)textColorForLevel:(NSInteger)level;
//
- (UIColor *)backgroundColor;

- (UIColor *)boardColor;

- (UIColor *)scoreBoardColor;

- (UIColor *)buttonColor;

- (NSString *)boldFontName;

- (NSString *)regulatForName;

- (CGFloat)textSizeForValue:(NSInteger)value;

- (CGPoint)locationOfPosition:(MPositions)position;

- (CGFloat)xLocationOfPosition:(MPositions)position;

- (CGFloat)yLocationOfPosition:(MPositions)position;

@end
