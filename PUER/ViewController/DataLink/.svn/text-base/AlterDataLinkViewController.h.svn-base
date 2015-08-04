//
//  AlterDataLinkViewController.h
//  PUER
//
//  Created by admin on 14-8-29.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlterDataLinkViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,UIKeyboardViewControllerDelegate>

@property (nonatomic,retain) UIKeyboardViewController *keyBoardController;

@property (nonatomic,retain) NSMutableDictionary *alterDic;
@property (nonatomic,retain) NSString *connname;
@property BOOL judgeBack;//判断是否以执行反悔按钮操作
@property int selectButtonNum;//记录选项卡上的按钮是选择的第几个
@property BOOL isNewAdd;

@property (nonatomic,retain) UITableView *detailsTableView;//“详细信息”的列表
@property (nonatomic,retain) UITableView *otherTableView;//“其他”的列表
@property (nonatomic,retain) UITableView *programChooseTableView;//详细信息列表中“提供程序”的选择列表
@property (nonatomic,retain) UIButton    *detailsButton;//“详细信息”按钮
@property (nonatomic,retain) UIButton    *otherButton;//“其他”按钮
@property (nonatomic,retain) UIButton    *connectionButton;//“其他”列表中断网自动连接按钮
@property (nonatomic,retain) UIButton    *pullDownButton;//"提供程序"下拉按钮

@property (nonatomic,retain) UITextField *connNameTextField;//连接名称
@property (nonatomic,retain) UITextField *providerTextField;//提供程序
@property (nonatomic,retain) UITextField *dataSourceTextField;//服务器名称
@property (nonatomic,retain) UITextField *initialCataLogTextField;//数据库名称
@property (nonatomic,retain) UITextField *userTextField;//用户名
@property (nonatomic,retain) UITextField *passwordTextField;//密码
@property (nonatomic,retain) UITextView  *displayNameTextView;//连接描述
@property (nonatomic,retain) UITextField *connectionTimeOutTextField;//连接超时
@property (nonatomic,retain) UITextField *poolMaxCountTextField;//连接池大小
@property (nonatomic,retain) UITextField *commandTimeOutTextField;//命令超时
@property (nonatomic,retain) UITextField *poolTimeOutTextField;//获取连接超时
@property (nonatomic,retain) UITextField *checkTimeTextField;//监听周期

@property (nonatomic,retain) UILabel *Lable;
@property (nonatomic,retain) UIView *bgView;
@property (nonatomic,retain) UITextField *textField;

@end
