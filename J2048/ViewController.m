//
//  ViewController.m
//  J2048
//
//  Created by juju on 2016/12/16.
//  Copyright © 2016年 juju. All rights reserved.
//

#import "ViewController.h"

#import "JScene.h"
#import "JGameManager.h"
#import "JScroView.h"
#import "JOverlay.h"
#import "JGridView.h"

@interface ViewController ()

@end

@implementation ViewController {
    
    IBOutlet UIButton *_restartButton;
    //    设置按钮
    IBOutlet UIButton *_settingsButton;
    //    游戏名称
    IBOutlet UILabel *_targetScore;
    //    游戏下标
    IBOutlet UILabel *_subtitle;
    //    分数视图
    IBOutlet JScroView *_scoreView;
    //    最高分数视图
    IBOutlet JScroView *_bestView;
    //    背景
    JScene *_scene;
    //
    IBOutlet JOverlay *_overlay;
    
    IBOutlet UIImageView *_overlayBackground;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateState];
    
    _bestView.score.text = [NSString stringWithFormat:@"%ld",(long)[Settings integerForKey:@"Best Score"]];
    
    _restartButton.layer.cornerRadius = [GSTATE cornerRadius];
    _restartButton.layer.masksToBounds = YES;
    
    _settingsButton.layer.cornerRadius = [GSTATE cornerRadius];
    _settingsButton.layer.masksToBounds = YES;
    
    _overlay.hidden = YES;
    
    _overlayBackground.hidden = YES;
    
    SKView *skView = (SKView *)self.view;
    
    JScene *scene = [JScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [skView presentScene:scene];
    [self updateScore:0];
    [scene startNewGame];
    
    _scene = scene;
    _scene.controller = self;
}

- (void)updateState{
    [_scoreView updateAppearance];
    [_bestView updateAppearance];
    
    _restartButton.backgroundColor = [GSTATE buttonColor];
    _restartButton.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:14];
    
    _settingsButton.backgroundColor = [GSTATE buttonColor];
    _settingsButton.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:14];
    
    _targetScore.textColor = [GSTATE buttonColor];
    
    long target = [GSTATE valueForLevel:GSTATE.winningLevel];
    
    if (target > 100000) {
        _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:34];
    }else if (target < 10000) {
        _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:42];
    }else {
        _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:40];
    }
    
    _targetScore.text = [NSString stringWithFormat: @"%ld",target];
    
    _subtitle.textColor = [GSTATE buttonColor];
    _subtitle.font = [UIFont fontWithName:[GSTATE boldFontName] size:14];
    _subtitle.text = [NSString stringWithFormat:@"Join the numbers to get to %ld",target];
    
    _overlay.message.textColor = [GSTATE buttonColor];
    [_overlay .keepPlaying setTitleColor:[GSTATE buttonColor] forState:UIControlStateNormal];
    [_overlay.restartGame setTitleColor:[GSTATE buttonColor] forState:UIControlStateNormal];
}

- (void)updateScore:(NSInteger)score{
    
    _scoreView.score.text = [NSString stringWithFormat:@"%ld", (long)score];
    
    if ([Settings integerForKey:@"Best Score"] < score) {
        [Settings setInteger:score forKey:@"Best Score"];
        _bestView.score.text = [NSString stringWithFormat:@"%ld", (long)score];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ((SKView *)self.view).paused = YES;
}

- (IBAction)restart:(id)sender {
    [self hideOverlay];
    [self updateScore:0];
    [_scene startNewGame];
}

- (IBAction)keepPlaying:(id)sender {
    [self hideOverlay];
}

- (void)hideOverlay{
    ((SKView *)self.view).paused = NO;
    if (!_overlay.hidden) {
        [UIView animateWithDuration:0.5 animations:^{
            _overlay.alpha = 0;
            _overlayBackground.alpha = 0;
        } completion:^(BOOL finished) {
            _overlay.hidden = YES;
            _overlayBackground.hidden = YES;
        }];
    }
}

- (void)endGame:(BOOL)won{
    _overlay.hidden = NO;
    _overlay.alpha = 0;
    _overlayBackground.hidden = NO;
    _overlayBackground.alpha = 0;
    
    if (!won) {
        _overlay.keepPlaying.hidden = YES;
        _overlay.message.text = @" Game Over";
    }else {
        _overlay.keepPlaying.hidden = NO;
        _overlay.message.text = @"You Won!";
    }
    
    _overlayBackground.image = [JGridView gridImageWithOverlay];
    
    CGFloat verticalOffset = [[UIScreen mainScreen] bounds].size.height - GSTATE.verticalOffset;
    
    NSInteger side = GSTATE.dimension * (GSTATE.titleSize + GSTATE.borderWidth) + GSTATE.borderWidth;
    
    _overlay.center = CGPointMake(GSTATE.horizontalOffset + side / 2, verticalOffset - side / 2);
    
    [UIView animateWithDuration:0.5 delay:1.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _overlay.alpha = 1;
        
        _overlayBackground.alpha = 1;
    } completion:^(BOOL finished) {
        ((SKView *)self.view).paused = YES;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
