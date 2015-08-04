//
//  LQLockWindow.h
//  PUER
//
//  Created by liqiang on 15/3/15.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLLockViewController.h"

@interface LQLockWindow : UIWindow

+ (LQLockWindow *)shareInstance;
- (void)show;
- (void)hideView;

// 手势解锁相关
@property (strong, nonatomic) LLLockViewController* lockVc; // 添加解锁界面
- (void)showLLLockViewController:(LLLockViewType)type;

@end
