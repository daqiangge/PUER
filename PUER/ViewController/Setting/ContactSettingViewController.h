//
//  ContactSettingViewController.h
//  PUER
//
//  Created by admin on 14-8-14.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactSettingViewController : BaseViewController<UITextFieldDelegate,UIAlertViewDelegate,UIKeyboardViewControllerDelegate>

@property (nonatomic,retain) UIKeyboardViewController *keyBoardController;

@property (nonatomic,retain) LQTextField *emailTextField;
@property (nonatomic,retain) LQTextField *smsTextField;

@property BOOL judgeBack;//判断是否以执行反悔按钮操作

@end
