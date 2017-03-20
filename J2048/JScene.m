//
//  Scene.m
//  Copy_2048
//
//  Created by juju on 2016/11/5.
//  Copyright © 2016年 juju. All rights reserved.
//

#import "JScene.h"
#import "JGameManager.h"
#import "JGridView.h"

#define EFFECTIVE_SWIPE_DISTANCE 20.0f
#define VALID_SWIPE_DISTANCE 2.0f

@implementation JScene
{
    JGameManager *_manager;
    BOOL _hasPendingSwipe;
    SKSpriteNode *_board;
}

- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        _manager = [[JGameManager alloc] init];
    }
    return self;
}

- (void)loadBoardWithGrid:(JGrid *)grid {
    if (_board) {
        [_board removeFromParent];
    }
    
    UIImage *image = [JGridView gridImageWithGrid:grid];
    SKTexture *backgroundTexture = [SKTexture textureWithCGImage:image.CGImage];
    _board = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
    [_board setScale: 1/[UIScreen mainScreen].scale];//解决6、6s plus的上得scale的问题
    _board.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:_board];
}

- (void)startNewGame {
    //    [_manager startNewSessionWithScene:self];
}

- (void)didMoveToView:(SKView *)view {
    if (view == self.view) {
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        [self.view addGestureRecognizer:recognizer];
    }else {
        for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) {
            [self.view removeGestureRecognizer:recognizer];
        }
    }
}

- (void)handleSwipe: (UIPanGestureRecognizer *)swipe {
    if (swipe.state == UIGestureRecognizerStateBegan) {
        _hasPendingSwipe = YES;
    }else if (swipe.state == UIGestureRecognizerStateChanged) {
        [self commitTranslation:[swipe translationInView:self.view]];
    }
}

- (void)commitTranslation:(CGPoint)transilation {
    if (!_hasPendingSwipe) {
        return;
    }
    CGFloat absX = fabs(transilation.x);
    CGFloat absY = fabs(transilation.y);
    if (MAX(absX, absY) < EFFECTIVE_SWIPE_DISTANCE) {
        return;
    }
    if (absX > absY * VALID_SWIPE_DISTANCE) {
        //        transilation.x < 0 ? [_manager movetoD]
    }else if (absY > absX * VALID_SWIPE_DISTANCE) {
        
    }
    
    _hasPendingSwipe = NO;
}

@end
