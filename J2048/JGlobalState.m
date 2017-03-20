//
//  GlobalState.m
//  Copy_2048
//
//  Created by juju on 2016/11/5.
//  Copyright © 2016年 juju. All rights reserved.
//

#import "JGlobalState.h"
#import "JTheme.h"

#define KGameType  @"Game Type"
#define KTheme     @"Theme"
#define KBoardSize @"Board Size"
#define KBestScore @"Best Score"

@interface JGlobalState ()

@property (nonatomic, readwrite) NSInteger dimension;
@property (nonatomic, readwrite) NSInteger winningLevel;
@property (nonatomic, readwrite) NSInteger titleSize;
@property (nonatomic, readwrite) NSInteger borderWidth;
@property (nonatomic, readwrite) NSInteger cornerRadius;
@property (nonatomic, readwrite) NSInteger horizontalOffset;
@property (nonatomic, readwrite) NSInteger verticalOffset;
@property (nonatomic, readwrite) NSTimeInterval animationDuration;
@property (nonatomic, readwrite) GameType gameType;
@property (nonatomic) NSInteger theme;

@end

@implementation JGlobalState

+ (JGlobalState *)state{
    static JGlobalState *state = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        state = [[JGlobalState alloc] init];
    });
    
    return state;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupDefaultState];
        [self loadGlobalState];
    }
    return self;
}

- (void)setupDefaultState{
    NSDictionary *defaultValues = @{KGameType: @0, KTheme: @0, KBestScore: @1, KBestScore: @0};
    [Settings registerDefaults:defaultValues];
}

- (void)loadGlobalState{
    self.dimension = [Settings integerForKey:KBoardSize] + 3;
    self.borderWidth = 5;
    self.cornerRadius = 4;
    self.animationDuration = 0.1;
    self.gameType = [Settings integerForKey:KGameType];
    self.horizontalOffset = [self horizontalOffset];
    self.verticalOffset = [self verticalOffset];
    self.theme = [Settings integerForKey:KTheme];
    self.needRefresh = NO;
}

- (NSInteger)titleSize{
    return self.dimension <= 4? 66 : 56;
}

- (NSInteger)horizontalOffset{
    CGFloat width = self.dimension * (self.titleSize + self.borderWidth) + self.borderWidth;
    return ([[UIScreen mainScreen] bounds].size.width - width) / 2;
}

- (NSInteger)verticalOffset{
    CGFloat height = self.dimension * (self.titleSize + self.borderWidth) + self.borderWidth + 120;
    return ([[UIScreen mainScreen] bounds].size.height - height) / 2;
}

- (NSInteger)winningLevel{
    if (GSTATE.gameType == GameTypePowerOf3) {
        switch (self.dimension) {
            case 3:
                return 4;
            case 4:
                return 5;
            case 5:
                return 6;
            default:
                return 5;
        }
    }
    NSInteger level = 11;
    if (self.dimension == 3) {
        return level - 1;
    }
    if (self.dimension == 5) {
        return level + 2;
    }
    return level;
}

- (BOOL)isLevel:(NSInteger)level1 mergeableWithLevel:(NSInteger)level2{
    if (self.gameType == GameTypeFibonacci) return abs((int)level1 - (int)level2) == 1;
    return level1 == level2;
}

- (NSInteger)mergeLevel:(NSInteger)level1 withLevel:(NSInteger)level2{
    if (![self isLevel:level1 mergeableWithLevel:level2]) {
        return 0;
    }
    if (self.gameType == GameTypeFibonacci) {
        return (level1 + 1 == level2) ? level2 + 1: level1 + 1;
    }
    return level1 + 1;
}

- (NSInteger)valueForLevel:(NSInteger)level{
    if (self.gameType == GameTypeFibonacci) {
        NSInteger a = 1, b = 1;
        for (NSInteger i=0; i < level; i++) {
            NSInteger c = a + b;
            a=b;
            b=c;
        }
        return b;
    }else{
        NSInteger value = 1;
        NSInteger base = self.gameType == GameTypePowerOf2 ? 2 : 3;
        for (NSInteger i=0; i<level; i++) {
            value *= base;
        }
        return value;
    }
}

- (UIColor *)colorForLevel:(NSInteger)level{
    return [[JTheme themeClassForType:self.theme] colorForLevel:level];
}

- (UIColor *)textColorForLevel:(NSInteger)level{
    return [[JTheme themeClassForType:self.theme] textColorForLevel:level];
}

- (CGFloat)textSizeForValue:(NSInteger)value{
    NSInteger offset = self.dimension == 5 ? 2 : 0;
    if (value < 100) {
        return 32 - offset;
    }else if (value < 1000){
        return 28 - offset;
    }else if (value < 10000){
        return 24 - offset;
    }else if (value < 100000){
        return  20 - offset;
    }else if (value < 1000000){
        return 16 - offset;
    }else {
        return 13 - offset;
    }
}

- (UIColor *)backgroundColor{
    return [[JTheme themeClassForType:self.theme] backgroundColor];
}

- (UIColor *)scoreBoardColor{
    return [[JTheme themeClassForType:self.theme] scoreBoardColor];
}


- (UIColor *)boardColor {
    return [[JTheme themeClassForType:self.theme] boardColor];
}


- (UIColor *)buttonColor {
    return [[JTheme themeClassForType:self.theme] buttonColor];
}


- (NSString *)boldFontName {
    return [[JTheme themeClassForType:self.theme] boldFontName];
}

- (NSString *)regularFontName {
    return [[JTheme themeClassForType:self.theme] regularFontName];
}

- (CGPoint)locationOfPosition:(MPositions)position{
    return CGPointMake([self xLocationOfPosition:position] + self.horizontalOffset, [self yLocationOfPosition:position] + self.verticalOffset);
}

- (CGFloat)xLocationOfPosition:(MPositions)position {
    return position.y * (GSTATE.titleSize + GSTATE.borderWidth) + GSTATE.borderWidth;
}

- (CGFloat)yLocationOfPosition:(MPositions)position {
    return position.x * (GSTATE.titleSize + GSTATE.borderWidth) + GSTATE.borderWidth;
}
@end
