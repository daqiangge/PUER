//
//  LoginViewController.h
//  PUER
//
//  Created by admin on 14-8-14.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<RESideMenuDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIScrollViewDelegate,UIKeyboardViewControllerDelegate>
{
    Reachability *hostReach;
}

@property (nonatomic,retain) UIKeyboardViewController *keyBoardController;

@property (nonatomic,retain) UIScrollView *guidePageScrollView;//引导页背景的scrollview
@property (nonatomic,retain) UIPageControl *pageController;//引导页中的小圆点
@property (nonatomic,retain) UIButton *experienceBtn;//开始体验按钮

@property (nonatomic,retain) UITextField *accountTextField;//账号输入框
@property (nonatomic,retain) NoCopyAndPaste_TexrField *passwordTextField;//密码输入框
@property (strong, nonatomic) Reachability *hostReach;//用于判断网络变化

@end
