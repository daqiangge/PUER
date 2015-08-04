//
//  MailboxSettingViewController.h
//  PUER
//
//  Created by admin on 14-8-14.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MailboxSettingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIKeyboardViewControllerDelegate>

@property (nonatomic,retain) UIKeyboardViewController *keyBoardController;

@property (nonatomic,retain) UITableView *mailBoxSettingTableView;

@property (nonatomic,retain) UITextField *emailaddressTextField;//邮箱地址
@property (nonatomic,retain) UITextField *smtpaddressTextField;//发送服务器地址(SMTP)
@property (nonatomic,retain) UITextField *smtpportTextField;//发送服务器端口(SMTP)
@property (nonatomic,retain) UITextField *usernameTextField;//邮箱账号
@property (nonatomic,retain) UITextField *passwordTextField;//邮箱密码

@property BOOL judgeBack;//判断是否以执行反悔按钮操作
@property (nonatomic,retain) NSMutableDictionary *emailBoxDic;
@property (nonatomic,retain) NSString *resetString;//将网络获取的dic编译成json存储起来

@property (nonatomic,retain) object *ob;

@end
