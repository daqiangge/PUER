//
//  LQLockWindow.m
//  PUER
//
//  Created by liqiang on 15/3/15.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "LQLockWindow.h"
#import "LQCoverWindow.h"

@implementation LQLockWindow

+ (LQLockWindow *)shareInstance
{
    static id shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    
    return shareInstance;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.windowLevel = UIWindowLevelAlert+10;
        [self showLLLockViewController:LLLockViewTypeCheck];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideView) name:@"Notification_DidBecomeActive" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideView) name:@"Notification_lockError" object:nil];
    }
    
    return self;
}

- (void)show
{
    [self makeKeyWindow];
    self.hidden = NO;
    //重置手势
    [self.lockVc refershLock];
    
    BOOL fingerprintSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"fingerprintSwitch"];
    BOOL lockSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"lockSwitch"];
    BOOL loginsuccess = [[NSUserDefaults standardUserDefaults] boolForKey:@"loginsuccess"];
    
    if (lockSwitch)
    {
        if (loginsuccess)
        {
            if (fingerprintSwitch)
            {
                [[LQCoverWindow coverWindow] show];
            }
        }
    }
}

- (void)hideView
{
    [self resignKeyWindow];
    self.hidden = YES;
    [[LQCoverWindow coverWindow] hideView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 弹出手势解锁密码输入框
- (void)showLLLockViewController:(LLLockViewType)type
{
    if(self.window.rootViewController.presentingViewController == nil)
    {
        self.lockVc = [[LLLockViewController alloc] init];
        self.lockVc.nLockViewType = type;
        
        self.lockVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.lockVc];
        self.rootViewController = nav;
        
    }
}

@end
