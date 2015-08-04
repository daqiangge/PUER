//
//  LQCoverWindow.m
//  PUER
//
//  Created by admin on 15/6/9.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "LQCoverWindow.h"

@interface LQCoverWindow()

@property (nonatomic, weak) UIView *coverView;

@end

@implementation LQCoverWindow

+ (instancetype)coverWindow
{
    static id shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat propor = SCREEN_HEIGHT==480?0.65:(SCREEN_HEIGHT==568?0.9:(SCREEN_HEIGHT==667?1.174:(SCREEN_HEIGHT==736?1.295:1.5)));
        shareInstance = [[self alloc] initWithFrame:CGRectMake(0, 195*propor, SCREEN_WIDTH, SCREEN_HEIGHT)];
    });
    
    return shareInstance;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideView) name:@"Notification_DidClose" object:nil];
        
        self.windowLevel = UIWindowLevelAlert+100;
        
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = [UIColor whiteColor];
        self.rootViewController = vc;
    }
    
    return self;
}

- (void)show
{
    [self makeKeyWindow];
    self.hidden = NO;
}

- (void)hideView
{
    [self resignKeyWindow];
    self.hidden = YES;
}

@end
