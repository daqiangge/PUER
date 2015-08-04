//
//  SystemSettingViewController.h
//  PUER
//
//  Created by admin on 14-8-14.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemSettingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,UIKeyboardViewControllerDelegate>

@property (nonatomic,retain) UIKeyboardViewController *keyBoardController;

@property (nonatomic,retain) NSMutableDictionary *systemSettingDic;
@property (nonatomic,retain) NSString *resetString;//将网络获取的dic编译成json存储起来

@property (nonatomic,retain) UIView *TABBackgroundView;//选项卡背景view

@property (nonatomic,retain) UIButton *httpServiceButton;// HTTP服务按钮
@property (nonatomic,retain) UIButton *sessionAndMessageButton;//会话及消息按钮
@property (nonatomic,retain) UIButton *messagesAndLogsButton;//短信及日志按钮

@property (nonatomic,retain) UITableView *httpServiceTableView;// HTTP服务列表
@property (nonatomic,retain) UITableView *sessionAndMessageTableView;//会话及消息列表
@property (nonatomic,retain) UITableView *messagesAndLogsTableView;//短信及日志列表
@property (nonatomic,retain) UITableView *messagesPortTableView;//短信及日志列表

@property BOOL judgeBack;//判断是否以执行反悔按钮操作

@property BOOL keyboardState;//键盘状态

@property int IsOpenDebug;//是否开启Debug
@property int SessionHascheckip;//是否开启Debug
@property int selectButtonNum;//记录选项卡上的按钮是选择的第几个

@property (nonatomic,retain) UIButton *debugButton;
@property (nonatomic,retain) UIButton *checkButton;
@property (nonatomic,retain) UIButton *pullDownButton;

@property (nonatomic,retain) UITextField *HttpServerAcceptorsCount;//并发连接数
@property (nonatomic,retain) UITextField *HttpServerListenCheckTime;//监听周期
@property (nonatomic,retain) UITextField *HttpServerClientStackCapacity;//指针堆栈容量
@property (nonatomic,retain) UITextField *HttpServerStructStackCapacity;//结构体堆栈容量
@property (nonatomic,retain) UITextField *HttpServerConnBufferSize;//链接读取缓存(KB)
@property (nonatomic,retain) UITextField *HttpServerMaxPostSize;//最大提交数据量
@property (nonatomic,retain) UITextField *HttpServerMaxUpdateSize;//最大上载数据量
@property (nonatomic,retain) UITextField *SessionOutTime;//用户会话有效期
@property (nonatomic,retain) UITextField *SessionCheckTime;//监听周期
@property (nonatomic,retain) UITextField *MsgSessionTimeOut;//客户端过期时间
@property (nonatomic,retain) UITextField *MsgMsgTimeOut;//消息保留周期
@property (nonatomic,retain) UITextField *LogStayTime;//缓存周期
@property (nonatomic,retain) UITextField *LogMaxStayRecordCount;//缓存数量
@property (nonatomic,retain) UITextField *LogLogCheckTime;//监听周期
@property (nonatomic,retain) UITextField *SmsComPort;//短信猫端口


@end
