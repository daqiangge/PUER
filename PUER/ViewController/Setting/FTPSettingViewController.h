//
//  FTPSettingViewController.h
//  PUER
//
//  Created by admin on 14-8-14.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTPSettingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic,retain) UITableView *ftpSettingTableView;

@property (nonatomic,retain) UITextField *ftpaddressTextField;//邮箱地址
@property (nonatomic,retain) UITextField *usernameTextField;//邮箱账号
@property (nonatomic,retain) UITextField *passwordTextField;//邮箱密码

@property BOOL judgeBack;//判断是否以执行反悔按钮操作

@property (nonatomic,retain) NSMutableDictionary *ftpSettingDic;
@property (nonatomic,retain) NSString *resetString;//将网络获取的dic编译成json存储起来

@property (nonatomic,retain) object *ob;

@end
