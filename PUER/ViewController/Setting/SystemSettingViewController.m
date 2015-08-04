//
//  SystemSettingViewController.m
//  PUER
//
//  Created by admin on 14-8-14.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "SystemSettingViewController.h"
#import "SystemSettingTableViewCell.h"
#import "LableAndTextFieldTableViewCell.h"
#import "LableAndLableTableViewCell.h"
#import "LableAndButtonTableViewCell.h"
#import "LableAndTextFieldAndPullDownButtonTableViewCell.h"

#define MessagesPortTableView_Frame CGRectMake(160, 50*4-5, SCREEN_WIDTH-160-10, 5*30+15);
#define Cell_RowHeight 50

@interface SystemSettingViewController ()

@end

@implementation SystemSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange) name:@"textFieldChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:UIKeyboardDidHideNotification object:nil];
    
    //防止键盘遮挡住输入框
    _keyBoardController=[[UIKeyboardViewController alloc] initWithControllerDelegate:self];
    
    _systemSettingDic          = [[NSMutableDictionary alloc] init];
    _judgeBack                 = NO;
    _selectButtonNum           = 1;
    
    
    [super setNavTitle:@"系统设置"];
    [self doLoadingTAB];
    [self doLoadingHttpServiceTableView];
    [self doLoadingSessionAndMessageTableView];
    [self doLoadingMessagesAndLogsTableView];
    [self messagersPortTableView];
    [self doRequest];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (self.view.window == nil) {
        self.view = nil;
    }
}

#pragma mark - 加载选项卡
- (void)doLoadingTAB
{
    //选项卡背景
    _TABBackgroundView                 = [[UIView alloc] init];
    _TABBackgroundView.backgroundColor = [UIColor whiteColor];
    _TABBackgroundView.frame           = CGRectMake(0, 64, SCREEN_WIDTH, 40);
    [self.view addSubview:_TABBackgroundView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame        = CGRectMake(0, 0, SCREEN_WIDTH, _TABBackgroundView.frame.size.height);
    imageView.image        = [UIImage imageNamed:@"alterbg"];
    [_TABBackgroundView addSubview:imageView];
    
    //选项卡中“HTTP服务”按钮
    _httpServiceButton                     = [[UIButton alloc] init];
    self.httpServiceButton.frame           = CGRectMake(0, 0, SCREEN_WIDTH/3, 40);
    self.httpServiceButton.tag             = 10;
    self.httpServiceButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.httpServiceButton setBackgroundImage:[UIImage imageNamed:@"bgline"] forState:UIControlStateNormal];
    [self.httpServiceButton addTarget:self action:@selector(doChoose:) forControlEvents:UIControlEventTouchUpInside];
    [self.httpServiceButton setTitle:@"HTTP服务" forState:UIControlStateNormal];
    [self.httpServiceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_TABBackgroundView addSubview:self.httpServiceButton];
    
    //选项卡中“会话及消息”按钮
    _sessionAndMessageButton                     = [[UIButton alloc] init];
    self.sessionAndMessageButton.frame           = CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 40);
    self.sessionAndMessageButton.tag             = 11;
    self.sessionAndMessageButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.sessionAndMessageButton setBackgroundImage:[UIImage imageNamed:@"bgnull"] forState:UIControlStateNormal];
    [self.sessionAndMessageButton addTarget:self action:@selector(doChoose:) forControlEvents:UIControlEventTouchUpInside];
    [self.sessionAndMessageButton setTitle:@"会话及消息" forState:UIControlStateNormal];
    [self.sessionAndMessageButton setTitleColor:TAB_HaveNotBeenSelected_TitleCollor forState:UIControlStateNormal];
    [_TABBackgroundView addSubview:self.sessionAndMessageButton];
    
    //选项卡中“短信及日志”按钮
    _messagesAndLogsButton                      = [[UIButton alloc] init];
    self.messagesAndLogsButton .frame           = CGRectMake(SCREEN_WIDTH/3*2, 0, SCREEN_WIDTH/3, 40);
    self.messagesAndLogsButton .tag             = 12;
    self.messagesAndLogsButton .titleLabel.font = [UIFont systemFontOfSize:15];
    [self.messagesAndLogsButton  setBackgroundImage:[UIImage imageNamed:@"bgnull"] forState:UIControlStateNormal];
    [self.messagesAndLogsButton  addTarget:self action:@selector(doChoose:) forControlEvents:UIControlEventTouchUpInside];
    [self.messagesAndLogsButton  setTitle:@"短信及日志" forState:UIControlStateNormal];
    [self.messagesAndLogsButton  setTitleColor:TAB_HaveNotBeenSelected_TitleCollor forState:UIControlStateNormal];
    [_TABBackgroundView addSubview:self.messagesAndLogsButton ];
}

//选项卡按钮的操作
- (void)doChoose:(UIButton *)button
{
    switch (button.tag) {
        case 10:
        {
            if (_selectButtonNum != 1) {
                _selectButtonNum = 1;
                [self releaseKeyBoard];
            }
            
            [self.httpServiceButton setBackgroundImage:[UIImage imageNamed:@"bgline"] forState:UIControlStateNormal];
            [self.sessionAndMessageButton setBackgroundImage:[UIImage imageNamed:@"bgnull"] forState:UIControlStateNormal];
            [self.messagesAndLogsButton setBackgroundImage:[UIImage imageNamed:@"bgnull"] forState:UIControlStateNormal];
            
            [self.httpServiceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.sessionAndMessageButton setTitleColor:TAB_HaveNotBeenSelected_TitleCollor forState:UIControlStateNormal];
            [self.messagesAndLogsButton setTitleColor:TAB_HaveNotBeenSelected_TitleCollor forState:UIControlStateNormal];
            
            self.httpServiceTableView.hidden          = NO;
            self.sessionAndMessageTableView.hidden    = YES;
            self.messagesAndLogsTableView.hidden      = YES;
            
        }
            break;
            
        case 11:
        {
            if (_selectButtonNum != 2) {
                _selectButtonNum = 2;
                [self releaseKeyBoard];
            }
            
            [self.httpServiceButton setBackgroundImage:[UIImage imageNamed:@"bgnull"] forState:UIControlStateNormal];
            [self.sessionAndMessageButton setBackgroundImage:[UIImage imageNamed:@"bgline"] forState:UIControlStateNormal];
            [self.messagesAndLogsButton setBackgroundImage:[UIImage imageNamed:@"bgnull"] forState:UIControlStateNormal];
            
            [self.httpServiceButton setTitleColor:TAB_HaveNotBeenSelected_TitleCollor forState:UIControlStateNormal];
            [self.sessionAndMessageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.messagesAndLogsButton setTitleColor:TAB_HaveNotBeenSelected_TitleCollor forState:UIControlStateNormal];
            
            self.httpServiceTableView.hidden          = YES;
            self.sessionAndMessageTableView.hidden    = NO;
            self.messagesAndLogsTableView.hidden      = YES;
        }
            break;
            
        case 12:
        {
            if (_selectButtonNum != 3) {
                _selectButtonNum = 3;
                [self releaseKeyBoard];
            }
            
            [self.httpServiceButton setBackgroundImage:[UIImage imageNamed:@"bgnull"] forState:UIControlStateNormal];
            [self.sessionAndMessageButton setBackgroundImage:[UIImage imageNamed:@"bgnull"] forState:UIControlStateNormal];
            [self.messagesAndLogsButton setBackgroundImage:[UIImage imageNamed:@"bgline"] forState:UIControlStateNormal];
            
            [self.httpServiceButton setTitleColor:TAB_HaveNotBeenSelected_TitleCollor forState:UIControlStateNormal];
            [self.sessionAndMessageButton setTitleColor:TAB_HaveNotBeenSelected_TitleCollor forState:UIControlStateNormal];
            [self.messagesAndLogsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            self.httpServiceTableView.hidden          = YES;
            self.sessionAndMessageTableView.hidden    = YES;
            self.messagesAndLogsTableView.hidden      = NO;
            
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 加载列表
// HTTP服务列表
- (void)doLoadingHttpServiceTableView
{
    _httpServiceTableView                 = [[UITableView alloc] init];
    self.httpServiceTableView .frame      = CGRectMake(0, _TABBackgroundView.frame.origin.y+_TABBackgroundView.frame.size.height+7.5, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.httpServiceTableView .delegate   = self;
    self.httpServiceTableView .dataSource = self;
    self.httpServiceTableView .hidden     = NO;
    self.httpServiceTableView .tag        = 20;
    self.httpServiceTableView.delaysContentTouches = NO;//使列表上按钮出现高亮状态
    [self.httpServiceTableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.httpServiceTableView ];
    
    //给tableview注册一个cell模板
    NSString *httpServiceIdenifier1 = @"httpServiceTableViewCell1";
    UINib *httpServiceNib1 = [UINib nibWithNibName:@"LableAndTextFieldTableViewCell" bundle:nil];
    [self.httpServiceTableView registerNib:httpServiceNib1 forCellReuseIdentifier:httpServiceIdenifier1];
    
    //给tableview注册一个cell模板
    NSString *httpServiceIdenifier2 = @"httpServiceTableViewCell2";
    UINib *httpServiceNib2 = [UINib nibWithNibName:@"LableAndLableTableViewCell" bundle:nil];
    [self.httpServiceTableView registerNib:httpServiceNib2 forCellReuseIdentifier:httpServiceIdenifier2];
    
    //给tableview注册一个cell模板
    NSString *httpServiceIdenifier3 = @"httpServiceTableViewCell3";
    UINib *httpServiceNib3 = [UINib nibWithNibName:@"LableAndButtonTableViewCell" bundle:nil];
    [self.httpServiceTableView registerNib:httpServiceNib3 forCellReuseIdentifier:httpServiceIdenifier3];
    
    [_httpServiceTableView addSubview:[self saveButton:CGRectMake(10, 9*50, SCREEN_WIDTH-20, 40)]];
    
    [_httpServiceTableView addSubview:[self resetButton:CGRectMake(10, 10*50, SCREEN_WIDTH-20, 40)]];
    
    [_httpServiceTableView addSubview:[self defaulValueButton:CGRectMake(10, 11*50, SCREEN_WIDTH-20, 40)]];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(releaseKeyBoard)];
    tapGR.numberOfTapsRequired = 1; // * 点击空白处几下
    [self.httpServiceTableView addGestureRecognizer:tapGR];
}

//会话及消息列表
- (void)doLoadingSessionAndMessageTableView
{
    _sessionAndMessageTableView                 = [[UITableView alloc] init];
    self.sessionAndMessageTableView .frame      = self.httpServiceTableView .frame;
    self.sessionAndMessageTableView .delegate   = self;
    self.sessionAndMessageTableView .dataSource = self;
    self.sessionAndMessageTableView .hidden     = YES;
    self.sessionAndMessageTableView .tag        = 21;
    self.sessionAndMessageTableView.delaysContentTouches = NO;
    [self.sessionAndMessageTableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.sessionAndMessageTableView ];
    
    //给tableview注册一个cell模板
    NSString *sessionAndMessageIdenifier1 = @"sessionAndMessageTableViewCell1";
    UINib *sessionAndMessageNib1 = [UINib nibWithNibName:@"LableAndTextFieldTableViewCell" bundle:nil];
    [self.sessionAndMessageTableView registerNib:sessionAndMessageNib1 forCellReuseIdentifier:sessionAndMessageIdenifier1];
    
    //给tableview注册一个cell模板
    NSString *sessionAndMessageIdenifier3 = @"sessionAndMessageTableViewCell3";
    UINib *sessionAndMessageNib3 = [UINib nibWithNibName:@"LableAndButtonTableViewCell" bundle:nil];
    [self.sessionAndMessageTableView registerNib:sessionAndMessageNib3 forCellReuseIdentifier:sessionAndMessageIdenifier3];
    
    [_sessionAndMessageTableView addSubview:[self saveButton:CGRectMake(10, 5*50, SCREEN_WIDTH-20, 40)]];
    
    [_sessionAndMessageTableView addSubview:[self resetButton:CGRectMake(10, 6*50, SCREEN_WIDTH-20, 40)]];
    
    [_sessionAndMessageTableView addSubview:[self defaulValueButton:CGRectMake(10, 7*50, SCREEN_WIDTH-20, 40)]];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(releaseKeyBoard)];
    tapGR.numberOfTapsRequired = 1; // * 点击空白处几下
    [self.sessionAndMessageTableView addGestureRecognizer:tapGR];
}

//短信及日志列表
- (void)doLoadingMessagesAndLogsTableView
{
    _messagesAndLogsTableView                 = [[UITableView alloc] init];
    self.messagesAndLogsTableView .frame      = self.httpServiceTableView .frame;
    self.messagesAndLogsTableView .delegate   = self;
    self.messagesAndLogsTableView .dataSource = self;
    self.messagesAndLogsTableView .hidden     = YES;
    self.messagesAndLogsTableView .tag        = 22;
    self.messagesAndLogsTableView.delaysContentTouches = NO;
    [self.messagesAndLogsTableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.messagesAndLogsTableView ];
    
    //给tableview注册一个cell模板
    NSString *messagesAndLogsIdenifier1 = @"messagesAndLogsTableViewCell1";
    UINib *messagesAndLogsNib1 = [UINib nibWithNibName:@"LableAndTextFieldTableViewCell" bundle:nil];
    [self.messagesAndLogsTableView registerNib:messagesAndLogsNib1 forCellReuseIdentifier:messagesAndLogsIdenifier1];
    
    //给tableview注册一个cell模板
    NSString *messagesAndLogsIdenifier2 = @"messagesAndLogsTableViewCell2";
    UINib *messagesAndLogsNib2 = [UINib nibWithNibName:@"LableAndTextFieldAndPullDownButtonTableViewCell" bundle:nil];
    [self.messagesAndLogsTableView registerNib:messagesAndLogsNib2 forCellReuseIdentifier:messagesAndLogsIdenifier2];
    
    [_messagesAndLogsTableView addSubview:[self saveButton:CGRectMake(10, 4*50, SCREEN_WIDTH-20, 40)]];
    
    [_messagesAndLogsTableView addSubview:[self resetButton:CGRectMake(10, 5*50, SCREEN_WIDTH-20, 40)]];
    
    [_messagesAndLogsTableView addSubview:[self defaulValueButton:CGRectMake(10, 6*50, SCREEN_WIDTH-20, 40)]];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(releaseKeyBoard)];
    tapGR.numberOfTapsRequired = 1; // * 点击空白处几下
    tapGR.delegate = self;
    [self.messagesAndLogsTableView addGestureRecognizer:tapGR];
}

- (void)messagersPortTableView
{
    _messagesPortTableView                 = [[UITableView alloc] init];
    self.messagesPortTableView.frame       = MessagesPortTableView_Frame;
    self.messagesPortTableView .delegate   = self;
    self.messagesPortTableView .dataSource = self;
    self.messagesPortTableView .hidden     = YES;
    self.messagesPortTableView.layer.borderColor = [UIColor grayColor].CGColor;
    self.messagesPortTableView.layer.borderWidth = 0.5;
    [self.messagesAndLogsTableView addSubview:self.messagesPortTableView];
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _httpServiceTableView) {
        return 10;
    }else if (tableView == _sessionAndMessageTableView) {
        return 6;
    }else if (tableView == _messagesAndLogsTableView){
        return 5;
    }else {
        return 8;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _httpServiceTableView) {
        
        NSArray *array = @[@"服务端口",@"并发连接数(个)",@"监听周期(秒)",@"指针堆栈容量(个)",@"结构体堆栈容量(个)",@"链接读取缓存(KB)",@"最大提交数据量(MB)",@"最大上载数据量(MB)",@"是否开启Debug测试"];
        
        if (indexPath.row < 8 && indexPath.row > 0) {
            static NSString *httpServiceIdenifier1 = @"httpServiceTableViewCell1";
            LableAndTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:httpServiceIdenifier1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setNameLableFrameAndContentFrame:CGRectMake(10, 0, 140, Cell_RowHeight)];
            cell.nameLable.text = array[indexPath.row];
            cell.contentTextField.keyboardType = UIKeyboardTypeNumberPad;
            
            switch (indexPath.row) {
                case 1:
                {
                    cell.contentTextField.text     = [_systemSettingDic objectForKey:@"HttpServer_AcceptorsCount"];
                    self.HttpServerAcceptorsCount  = cell.contentTextField;
                    self.HttpServerAcceptorsCount.delegate  = self;
                }
                    break;
                    
                case 2:
                {
                    cell.contentTextField.text      = [_systemSettingDic objectForKey:@"HttpServer_ListenCheckTime"];
                    self.HttpServerListenCheckTime  = cell.contentTextField;
                    self.HttpServerListenCheckTime.delegate  = self;
                }
                    break;
                    
                case 3:
                {
                    cell.contentTextField.text          = [_systemSettingDic objectForKey:@"HttpServer_ClientStackCapacity"];
                    self.HttpServerClientStackCapacity  = cell.contentTextField;
                    self.HttpServerClientStackCapacity.delegate  = self;
                }
                    break;
                    
                case 4:
                {
                    cell.contentTextField.text         = [_systemSettingDic objectForKey:@"HttpServer_StructStackCapacity"];
                    self.HttpServerStructStackCapacity = cell.contentTextField;
                    self.HttpServerStructStackCapacity.delegate  = self;
                }
                    break;
                    
                case 5:
                {
                    cell.contentTextField.text    = [_systemSettingDic objectForKey:@"HttpServer_ConnBufferSize"];
                    self.HttpServerConnBufferSize = cell.contentTextField;
                    self.HttpServerConnBufferSize.delegate  = self;
                }
                    break;
                    
                case 6:
                {
                    cell.contentTextField.text  = [_systemSettingDic objectForKey:@"HttpServer_MaxPostSize"];
                    self.HttpServerMaxPostSize  = cell.contentTextField;
                    self.HttpServerMaxPostSize.delegate  = self;
                }
                    break;
                    
                case 7:
                {
                    cell.contentTextField.text   = [_systemSettingDic objectForKey:@"HttpServer_MaxUpdateSize"];
                    self.HttpServerMaxUpdateSize = cell.contentTextField;
                    self.HttpServerMaxUpdateSize.delegate  = self;
                }
                    break;
                    
                default:
                    break;
            }
            
            return cell;
            
        }else if (indexPath.row == 0) {
            static NSString *httpServiceIdenifier2 = @"httpServiceTableViewCell2";
            LableAndLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:httpServiceIdenifier2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setNameLableFrameAndContentFrame:CGRectMake(10, 0, 140, Cell_RowHeight)];
            
            cell.nameLable.text     = array[indexPath.row];
            cell.contentLable.text  = [self.systemSettingDic objectForKey:@"port"];
            
            return cell;
            
        }else if (indexPath.row == 8) {
            static NSString *httpServiceIdenifier3 = @"httpServiceTableViewCell3";
            LableAndButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:httpServiceIdenifier3];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setNameLableFrameAndContentFrame:CGRectMake(10, 0, 140, Cell_RowHeight)];
            
            cell.nameLable.text     = array[indexPath.row];
            _debugButton            = cell.chooseButton;
            [_debugButton addTarget:self action:@selector(debugTest:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([[_systemSettingDic objectForKey:@"IsOpenDebug"] isEqualToString:@"0"]) {
                _debugButton.selected  = NO;
            }
            if ([[_systemSettingDic objectForKey:@"IsOpenDebug"] isEqualToString:@"1"]) {
                _debugButton.selected  = YES;
            }
            
            return cell;
        }else {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle   = UITableViewCellSelectionStyleNone;
            cell.backgroundColor  = [UIColor whiteColor];
            
            return cell;
        }
        
    }else if (tableView == _sessionAndMessageTableView) {
        
        NSArray *array = @[@"用户会话有效期(分)",@"监听周期(秒)",@"客户端过期时间(分)",@"消息保留周期(秒)",@"会话是否检查IP"];
        
        if (indexPath.row < 4) {
            static NSString *sessionAndMessageIdenifier1 = @"sessionAndMessageTableViewCell1";
            LableAndTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sessionAndMessageIdenifier1];;
            cell.selectionStyle   = UITableViewCellSelectionStyleNone;
            cell.contentTextField.keyboardType = UIKeyboardTypeNumberPad;
            [cell setNameLableFrameAndContentFrame:CGRectMake(10, 0, 140, Cell_RowHeight)];
            cell.nameLable.text = array[indexPath.row];
            
            switch (indexPath.row) {
                case 0:
                {
                    cell.contentTextField.text   = [_systemSettingDic objectForKey:@"Session_OutTime"];
                    self.SessionOutTime          = cell.contentTextField;
                    self.SessionOutTime.delegate = self;
                }
                    break;
                    
                case 1:
                {
                    cell.contentTextField.text =[_systemSettingDic objectForKey:@"Session_CheckTime"];
                    self.SessionCheckTime      = cell.contentTextField;
                    self.SessionCheckTime.delegate = self;
                }
                    break;
                    
                case 2:
                {
                    cell.contentTextField.text  = [_systemSettingDic objectForKey:@"Msg_SessionTimeOut"];
                    self.MsgSessionTimeOut      = cell.contentTextField;
                    self.MsgSessionTimeOut.delegate = self;
                }
                    break;
                    
                case 3:
                {
                    cell.contentTextField.text = [_systemSettingDic objectForKey:@"Msg_MsgTimeOut"];
                    self.MsgMsgTimeOut         = cell.contentTextField;
                    self.MsgMsgTimeOut.delegate = self;
                }
                    break;
                    
                default:
                    break;
            }
            return cell;
        }else if (indexPath.row == 4) {
            
            static NSString *sessionAndMessageIdenifier1 = @"sessionAndMessageTableViewCell3";
            LableAndButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sessionAndMessageIdenifier1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setNameLableFrameAndContentFrame:CGRectMake(10, 0, 140, Cell_RowHeight)];
            
            cell.nameLable.text     = array[indexPath.row];
            _checkButton            = cell.chooseButton;
            [_checkButton addTarget:self action:@selector(checkIP:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([[_systemSettingDic objectForKey:@"hascheckip"] isEqualToString:@"0"]) {
                _checkButton.selected  = NO;
            }
            if ([[_systemSettingDic objectForKey:@"hascheckip"] isEqualToString:@"1"]) {
                _checkButton.selected  = YES;
            }
            
            return cell;
        }else {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle   = UITableViewCellSelectionStyleNone;
            cell.backgroundColor  = [UIColor whiteColor];
            
            return cell;
        }
        
    }else if (tableView == _messagesAndLogsTableView){
        
        NSArray *array = @[@"缓存周期(分)",@"缓存数量(条)",@"监听周期(秒)",@"短信猫端口"];
        
        if (indexPath.row < 3) {
            
            static NSString *messagesAndLogsIdenifier1 = @"messagesAndLogsTableViewCell1";
            LableAndTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:messagesAndLogsIdenifier1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentTextField.keyboardType = UIKeyboardTypeNumberPad;
            [cell setNameLableFrameAndContentFrame:CGRectMake(10, 0, 140, Cell_RowHeight)];
            cell.nameLable.text = array[indexPath.row];

            switch (indexPath.row) {
                case 0:
                {
                    cell.contentTextField.text = [_systemSettingDic objectForKey:@"Log_StayTime"];
                    self.LogStayTime           = cell.contentTextField;
                    self.LogStayTime.delegate = self;
                }
                    break;
                    
                case 1:
                {
                    cell.contentTextField.text = [_systemSettingDic objectForKey:@"Log_MaxStayRecordCount"];
                    self.LogMaxStayRecordCount = cell.contentTextField;
                    self.LogMaxStayRecordCount.delegate = self;
                }
                    break;
                    
                case 2:
                {
                    cell.contentTextField.text = [_systemSettingDic objectForKey:@"Log_LogCheckTime"];
                    self.LogLogCheckTime       = cell.contentTextField;
                    self.LogLogCheckTime.delegate = self;
                }
                    break;
                    
                default:
                    break;
            }
            return cell;
            
        }else if (indexPath.row == 3){
            
            static NSString *messagesAndLogsIdenifier2 = @"messagesAndLogsTableViewCell2";
            LableAndTextFieldAndPullDownButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:messagesAndLogsIdenifier2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setNameLableFrameAndContentFrame:CGRectMake(10, 0, 140, Cell_RowHeight)];
            cell.nameLable.text = array[indexPath.row];
            
            cell.contentTextField.enabled    = NO;
            cell.contentTextField.text       = [NSString stringWithFormat:@"COM%d",[[_systemSettingDic objectForKey:@"Sms_ComPort"] intValue]];
            self.SmsComPort                  = cell.contentTextField;
            self.SmsComPort.delegate         = self;
            
            _pullDownButton = cell.pullDownButton;
            [_pullDownButton addTarget:self action:@selector(messagersPortChoose) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }else {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle   = UITableViewCellSelectionStyleNone;
            cell.backgroundColor  = [UIColor whiteColor];
            
            return cell;
        }
    }else {
        static NSString *idenifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenifier];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"COM%d",indexPath.row+1];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _messagesPortTableView) {
        return 30;
    }
    
    if (tableView == _httpServiceTableView) {
        if (indexPath.row == 9) {
            return 270.0;
        }
    }
    if (tableView == _sessionAndMessageTableView) {
        if (indexPath.row == 5) {
            return 270.0;
        }
    }
    if (tableView == _messagesAndLogsTableView) {
        if (indexPath.row == 4) {
            return 270.0;
        }
    }
    
    return Cell_RowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _messagesPortTableView) {
        self.messagesPortTableView.hidden = YES;
        
        self.SmsComPort.text = [NSString stringWithFormat:@"COM%d",indexPath.row+1];
        [_systemSettingDic setObject:[NSString stringWithFormat:@"%d",indexPath.row+1] forKey:@"Sms_ComPort"];
    }
}

#pragma mark - 网络请求
- (void)doRequest
{
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载…";
    
    
    //判断当前网络状况
    if (![super isConnectionAvailable]) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常,请检查你的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    //发送保存请求
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    NSURL *url         = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/adminmanager/do/config/getconfig.do;sessionid=%@",IP,port,sid]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TimeoutInterval];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            
            [dic setObject:[NSString stringWithFormat:@"%@",[[[resultDic objectForKey:@"data"] objectForKey:@"httpserver"] objectForKey:@"port"]] forKey:@"port"];
            [dic setObject:[NSString stringWithFormat:@"%@",[[[resultDic objectForKey:@"data"] objectForKey:@"httpserver"] objectForKey:@"acceptcount"]] forKey:@"HttpServer_AcceptorsCount"];
            [dic setObject:[NSString stringWithFormat:@"%@",[[[resultDic objectForKey:@"data"] objectForKey:@"httpserver"] objectForKey:@"listenchecktime"]] forKey:@"HttpServer_ListenCheckTime"];
            [dic setObject:[NSString stringWithFormat:@"%@",[[[resultDic objectForKey:@"data"] objectForKey:@"httpserver"] objectForKey:@"clientstack"]] forKey:@"HttpServer_ClientStackCapacity"];
            [dic setObject:[NSString stringWithFormat:@"%@",[[[resultDic objectForKey:@"data"] objectForKey:@"httpserver"] objectForKey:@"structstack"]] forKey:@"HttpServer_StructStackCapacity"];
            [dic setObject:[NSString stringWithFormat:@"%@",[[[resultDic objectForKey:@"data"] objectForKey:@"httpserver"] objectForKey:@"connbuffsize"]] forKey:@"HttpServer_ConnBufferSize"];
            [dic setObject:[NSString stringWithFormat:@"%@",[[[resultDic objectForKey:@"data"] objectForKey:@"httpserver"] objectForKey:@"maxpostsize"]] forKey:@"HttpServer_MaxPostSize"];
            [dic setObject:[NSString stringWithFormat:@"%@",[[[resultDic objectForKey:@"data"] objectForKey:@"httpserver"] objectForKey:@"maxupdatesize"]]forKey:@"HttpServer_MaxUpdateSize"];
            [dic setObject:[NSString stringWithFormat:@"%@",[[[resultDic objectForKey:@"data"] objectForKey:@"debug"] objectForKey:@"isopendebug"]] forKey:@"IsOpenDebug"];
            [dic setObject:[NSString stringWithFormat:@"%@",[[[resultDic objectForKey:@"data"] objectForKey:@"session"] objectForKey:@"sessionouttime"]] forKey:@"Session_OutTime"];
            [dic setObject:[NSString stringWithFormat:@"%@",[[[resultDic objectForKey:@"data"] objectForKey:@"session"] objectForKey:@"checktime"]]forKey:@"Session_CheckTime"];
            [dic setObject:[NSString stringWithFormat:@"%@",[[[resultDic objectForKey:@"data"] objectForKey:@"msg"] objectForKey:@"clienttimeout"]]forKey:@"Msg_SessionTimeOut"];
            [dic setObject:[NSString stringWithFormat:@"%@",[[[resultDic objectForKey:@"data"] objectForKey:@"msg"] objectForKey:@"msgtimeout"]]forKey:@"Msg_MsgTimeOut"];
            [dic setObject: [NSString stringWithFormat:@"%@",[[[resultDic objectForKey:@"data"] objectForKey:@"session"] objectForKey:@"hascheckip"]]forKey:@"hascheckip"];
            [dic setObject:[NSString stringWithFormat:@"%@",[[[resultDic objectForKey:@"data"] objectForKey:@"log"] objectForKey:@"staytime"]] forKey:@"Log_StayTime"];
            [dic setObject:[NSString stringWithFormat:@"%@",[[[resultDic objectForKey:@"data"] objectForKey:@"log"] objectForKey:@"maxstayrecordcount"]] forKey:@"Log_MaxStayRecordCount"];
            [dic setObject:[NSString stringWithFormat:@"%@",[[[resultDic objectForKey:@"data"] objectForKey:@"log"] objectForKey:@"checktime"]]forKey:@"Log_LogCheckTime"];
            [dic setObject:[NSString stringWithFormat:@"%@",[[[resultDic objectForKey:@"data"] objectForKey:@"sms"] objectForKey:@"smscom"]] forKey:@"Sms_ComPort"];
            
            _systemSettingDic = dic;
            _resetString      = [dic JSONRepresentation];
            
            //停止0.5s后执行刷新列表，并停止刷新的动画
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_httpServiceTableView reloadData];
                [_messagesAndLogsTableView reloadData];
                [_sessionAndMessageTableView reloadData];
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            });
            
        }else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"]) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            
            if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"]) {
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:self cancelButtonTitle:@"重试" otherButtonTitles:@"重新登录", nil];
                [alter show];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        if (!self.judgeBack) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接超时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }];
    
    [operation start];
    
}

#pragma mark - 保存、重置、恢复默认按钮
//保存按钮
- (id)saveButton:(CGRect)rect
{
    UIButton *saveButton  = [[UIButton alloc] init];
    saveButton.frame      = rect;
    saveButton.titleLabel.font = [UIFont fontWithName:TextFont_name size:Button_Font_SmallSize];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"buttonbg3"] forState:UIControlStateNormal];
    [saveButton setTitle:@"确定" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(doSave) forControlEvents:UIControlEventTouchUpInside];
    
    return saveButton;
}

//重置按钮
- (id)resetButton:(CGRect)rect
{
    UIButton *resetButton  = [[UIButton alloc] init];
    resetButton.frame      = rect;
    resetButton.titleLabel.font = [UIFont fontWithName:TextFont_name size:Button_Font_SmallSize];
    [resetButton setBackgroundImage:[UIImage imageNamed:@"buttonbg4"] forState:UIControlStateNormal];
    [resetButton setTitle:@"重置" forState:UIControlStateNormal];
    [resetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(resetAll) forControlEvents:UIControlEventTouchUpInside];
    
    return resetButton;
}

//回复默认值
- (id)defaulValueButton:(CGRect)rect
{
    UIButton *defaulValueButton  = [[UIButton alloc] init];
    defaulValueButton.frame      = rect;
    defaulValueButton.titleLabel.font = [UIFont fontWithName:TextFont_name size:Button_Font_SmallSize];
    [defaulValueButton setBackgroundImage:[UIImage imageNamed:@"buttonbg4"] forState:UIControlStateNormal];
    [defaulValueButton setTitle:@"恢复默认值" forState:UIControlStateNormal];
    [defaulValueButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [defaulValueButton addTarget:self action:@selector(restoreTheDefaultValue) forControlEvents:UIControlEventTouchUpInside];
    
    return defaulValueButton;
}

- (void)doSave
{
    [self releaseKeyBoard];
    
    self.messagesPortTableView.hidden = YES;
    
    if (![self judgeNullValue]) {
        return;
    }
    if (![self determineScope]) {
        return;
    }
    
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在保存...";
    
    if (![super isConnectionAvailable]) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常,请检查你的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    //发送保存请求
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = TimeoutInterval;
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/config/setconfig.do;sessionid=%@",IP,port,sid];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.HttpServerAcceptorsCount.text,@"HttpServer_AcceptorsCount",
                                       self.HttpServerListenCheckTime.text,@"HttpServer_ListenCheckTime",
                                       self.HttpServerClientStackCapacity.text,@"HttpServer_ClientStackCapacity",
                                       self.HttpServerStructStackCapacity.text,@"HttpServer_StructStackCapacity",
                                       self.HttpServerConnBufferSize.text,@"HttpServer_ConnBufferSize",
                                       self.HttpServerMaxPostSize.text,@"HttpServer_MaxPostSize",
                                       self.HttpServerMaxUpdateSize.text,@"HttpServer_MaxUpdateSize",
                                       self.SessionOutTime.text,@"Session_OutTime",
                                       self.SessionCheckTime.text,@"Session_CheckTime",
                                       self.MsgSessionTimeOut.text,@"Msg_SessionTimeOut",
                                       self.MsgMsgTimeOut.text,@"Msg_MsgTimeOut",
                                       self.LogStayTime.text,@"Log_StayTime",
                                       self.LogMaxStayRecordCount.text,@"Log_MaxStayRecordCount",
                                       self.LogLogCheckTime.text,@"Log_LogCheckTime",
                                       [self.SmsComPort.text substringFromIndex:3],@"Sms_ComPort",
                                       [NSString stringWithFormat:@"%d",_IsOpenDebug],@"IsOpenDebug",
                                       [NSString stringWithFormat:@"%d",_SessionHascheckip],@"session_hascheckip",nil];
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"保存成功,重启平台后生效";
            
            _resetString   = [self.systemSettingDic JSONRepresentation];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                
            });
            
        }else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"]) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            
            if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"]) {
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:self cancelButtonTitle:@"重试" otherButtonTitles:@"重新登录", nil];
                [alter show];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        //如果未离开此界面则显示错误提示，如果已离开则不显示
        if (!self.judgeBack) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接超时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }];
}

- (void)resetAll
{
    [self releaseKeyBoard];
    
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在重置...";
    
    self.messagesPortTableView.hidden = YES;
    
    _systemSettingDic = [_resetString JSONValue];
    
    [_httpServiceTableView reloadData];
    [_sessionAndMessageTableView reloadData];
    [_messagesAndLogsTableView reloadData];
    
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"重置成功";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        
    });
}

- (void)restoreTheDefaultValue
{
    
    [self releaseKeyBoard];
    
    self.messagesPortTableView.hidden = YES;
    
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在恢复默认…";
    
    
    //判断当前网络状况
    if (![super isConnectionAvailable]) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常,请检查你的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    //发送保存请求
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    NSURL *url         = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/adminmanager/do/config/setdefconfig.do;sessionid=%@",IP,port,sid]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TimeoutInterval];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"恢复成功";
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                
                [self doRequest];
            });
            
        }else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"]) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            
            if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"]) {
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:self cancelButtonTitle:@"重试" otherButtonTitles:@"重新登录", nil];
                [alter show];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        if (!self.judgeBack) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接超时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }];
    
    [operation start];
    
}

#pragma mark - 打开短信猫端口列表
- (void)messagersPortChoose
{
    [self textFieldShouldReturn:nil];
    
    if (self.messagesPortTableView.hidden) {
        self.messagesPortTableView.hidden = NO;
    }else {
        self.messagesPortTableView.hidden = YES;
    }
}

#pragma mark - 是否开启Debug测试/会话是否检查IP的选中和取消
- (void)debugTest:(UIButton *)button
{
    if (button.selected) {
        button.selected = NO;
        _IsOpenDebug    = 0;
    }else {
        button.selected = YES;
        _IsOpenDebug    = 1;
    }
}

- (void)checkIP:(UIButton *)button
{
    if (button.selected) {
        button.selected = NO;
        _SessionHascheckip = 0;
    }else {
        button.selected = YES;
        _SessionHascheckip = 1;
    }
}

#pragma mark - TextField Delegate
//释放键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self releaseKeyBoard];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.messagesPortTableView.hidden = YES;
    return YES;
}

//限制输入框字符串长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([string isEqualToString:@"\n"])  //按会车可以改变
        
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (_HttpServerAcceptorsCount == textField ) {
        if (![self textFieldChange:toBeString key:@"HttpServer_AcceptorsCount"length:4]) {
            textField.text = [toBeString substringToIndex:4];
            return NO;
        }
    }
    
    if (_SessionOutTime == textField ) {
        if (![self textFieldChange:toBeString key:@"Session_OutTime"length:4]) {
            textField.text = [toBeString substringToIndex:4];
            return NO;
        }
    }
    
    if (_MsgSessionTimeOut == textField ) {
        if (![self textFieldChange:toBeString key:@"Msg_SessionTimeOut"length:4]) {
            textField.text = [toBeString substringToIndex:4];
            return NO;
        }
    }
    
    if (_HttpServerListenCheckTime == textField ) {
        if (![self textFieldChange:toBeString key:@"HttpServer_ListenCheckTime"length:2]) {
            textField.text = [toBeString substringToIndex:2];
            return NO;
        }
    }
    
    if (_HttpServerConnBufferSize == textField ) {
        if (![self textFieldChange:toBeString key:@"HttpServer_ConnBufferSize"length:2]) {
            textField.text = [toBeString substringToIndex:2];
            return NO;
        }
    }
    
    if (_HttpServerMaxPostSize == textField ) {
        if (![self textFieldChange:toBeString key:@"HttpServer_MaxPostSize"length:2]) {
            textField.text = [toBeString substringToIndex:2];
            return NO;
        }
    }
    
    if (_HttpServerStructStackCapacity == textField ) {
        if (![self textFieldChange:toBeString key:@"HttpServer_StructStackCapacity"length:5]) {
            textField.text = [toBeString substringToIndex:5];
            return NO;
        }
    }
    
    if (_HttpServerClientStackCapacity == textField ) {
        if (![self textFieldChange:toBeString key:@"HttpServer_ClientStackCapacity"length:5]) {
            textField.text = [toBeString substringToIndex:5];
            return NO;
        }
    }
    
    if (_LogMaxStayRecordCount == textField ) {
        if (![self textFieldChange:toBeString key:@"Log_MaxStayRecordCount"length:5]) {
            textField.text = [toBeString substringToIndex:5];
            return NO;
        }
    }
    
    if (_HttpServerMaxUpdateSize == textField ) {
        if (![self textFieldChange:toBeString key:@"HttpServer_MaxUpdateSize"length:3]) {
            textField.text = [toBeString substringToIndex:3];
            return NO;
        }
    }
    
    if (_SessionCheckTime == textField ) {
        if (![self textFieldChange:toBeString key:@"Session_CheckTime"length:3]) {
            textField.text = [toBeString substringToIndex:3];
            return NO;
        }
    }
    
    if (_MsgMsgTimeOut == textField ) {
        if (![self textFieldChange:toBeString key:@"Msg_MsgTimeOut"length:3]) {
            textField.text = [toBeString substringToIndex:3];
            return NO;
        }
    }
    
    if (_LogStayTime == textField ) {
        if (![self textFieldChange:toBeString key:@"Log_StayTime"length:3]) {
            textField.text = [toBeString substringToIndex:3];
            return NO;
        }
    }
    
    if (_LogLogCheckTime == textField ) {
        if (![self textFieldChange:toBeString key:@"Log_LogCheckTime"length:2]) {
            textField.text = [toBeString substringToIndex:2];
            return NO;
        }
    }
    
    for (int i = 0; i<[toBeString length]; i++) {
        //截取字符串中的每一个字符
        NSString *s = [toBeString substringWithRange:NSMakeRange(i, 1)];
        if (![[Regex shareInstance] judgeNumber:s]) {
            return NO;
        }
    }
    
    return YES;
}

//输入框的内容发生改变时，保存当前输入框的内容
- (BOOL)textFieldChange:(NSString *)toBeString key:(NSString *)key length:(int)length
{
    if ([toBeString length] == 0) {
        [_systemSettingDic setObject:@"" forKey:key];
    }else if ([toBeString length] < length+1){
        [_systemSettingDic setObject:toBeString forKey:key];
    }else {
        [_systemSettingDic setObject:[toBeString substringToIndex:length] forKey:key];
        return NO;
    }
    return YES;
}

//判断输入的取值范围
- (BOOL)determineScope
{
    if ([self.HttpServerAcceptorsCount.text intValue] < 1 || [self.HttpServerAcceptorsCount.text intValue] > 1024) {
        [self showAlterView:@"并发连接数必须在1～1024之间"];
        return NO;
    }
    if ([_HttpServerListenCheckTime.text intValue] < 5 || [_HttpServerListenCheckTime.text intValue] > 60) {
        [self showAlterView:@"HTTP监听周期必须在5～60之间"];
        return NO;
    }
    if ([_HttpServerClientStackCapacity.text intValue] < 1024 || [_HttpServerClientStackCapacity.text intValue] > 1024*64) {
        [self showAlterView:@"指针堆栈容量必须在1024～65536之间"];
        return NO;
    }
    if ([_HttpServerStructStackCapacity.text intValue] < 1024 || [_HttpServerStructStackCapacity.text intValue] > 1024*64) {
        [self showAlterView:@"结构体堆栈容量必须在1024～65536之间"];
        return NO;
    }
    if ([_HttpServerConnBufferSize.text intValue] < 1 || [_HttpServerConnBufferSize.text intValue] > 64) {
        [self showAlterView:@"链接读取缓存必须在1～64之间"];
        return NO;
    }
    if ([_HttpServerMaxPostSize.text intValue] < 1 || [_HttpServerMaxPostSize.text intValue] > 64) {
        [self showAlterView:@"最大提交数据量必须在1～64之间"];
        return NO;
    }
    if ([_HttpServerMaxUpdateSize.text intValue] < 1 || [_HttpServerMaxUpdateSize.text intValue] > 128) {
        [self showAlterView:@"最大上载数据量必须在1～128之间"];
        return NO;
    }
    if ([_SessionOutTime.text intValue] < 30 || [_SessionOutTime.text intValue] > 1440) {
        [self showAlterView:@"用户会话有效期必须在30～1440之间"];
        return NO;
    }
    if ([_SessionCheckTime.text intValue] < 10 || [_SessionCheckTime.text intValue] > 600) {
        [self showAlterView:@"会话监听周期必须在10～600之间"];
        return NO;
    }
    if ([_MsgSessionTimeOut.text intValue] < 1 || [_MsgSessionTimeOut.text intValue] > 1400) {
        [self showAlterView:@"客户端过期时间必须在1～1400之间"];
        return NO;
    }
    if ([_MsgMsgTimeOut.text intValue] <1 || [_MsgMsgTimeOut.text intValue] > 300) {
        [self showAlterView:@"消息保留周期必须在1～300之间"];
        return NO;
    }
    if ([_LogStayTime.text intValue] < 1 || [_LogStayTime.text intValue] > 720) {
        [self showAlterView:@"缓存周期必须在1～720之间"];
        return NO;
    }
    if ([_LogMaxStayRecordCount.text intValue] < 10 || [_LogMaxStayRecordCount.text intValue] > 10000) {
        [self showAlterView:@"缓存数量必须在10～10000之间"];
        return NO;
    }
    if ([_LogLogCheckTime.text intValue] < 5 || [_LogLogCheckTime.text intValue] > 60) {
        [self showAlterView:@"日志监听周期必须在5～60之间"];
        return NO;
    }
    return YES;
}

//提示
- (void)showAlterView:(NSString *)message
{
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alterview show];
}

//判断是否有未输入的值
- (BOOL)judgeNullValue
{
    if ([_HttpServerAcceptorsCount.text isEqualToString:@""] || [_HttpServerListenCheckTime.text isEqualToString:@""] || [_HttpServerClientStackCapacity.text isEqualToString:@""] || [_HttpServerStructStackCapacity.text isEqualToString:@""] || [_HttpServerConnBufferSize.text isEqualToString:@""] || [_HttpServerMaxPostSize.text isEqualToString:@""] || [_HttpServerMaxUpdateSize.text isEqualToString:@""] || [_SessionOutTime.text isEqualToString:@""] || [_SessionCheckTime.text isEqualToString:@""] || [_MsgSessionTimeOut.text isEqualToString:@""] || [_MsgMsgTimeOut.text isEqualToString:@""] || [_LogStayTime.text isEqualToString:@""] || [_LogMaxStayRecordCount.text isEqualToString:@""] || [_LogLogCheckTime.text isEqualToString:@""]) {
        
        [self showAlterView:@"请检查是否有未输入的一项"];
        
        return NO;
    }
    return YES;
}

- (void)textFieldChange
{
//    NSLog(@"%@",self.HttpServerAcceptorsCount.text);
}

#pragma mark - 点击空白处释放键盘
- (void)releaseKeyBoard
{
    [_HttpServerAcceptorsCount resignFirstResponder];
    [_HttpServerListenCheckTime  resignFirstResponder];
    [_HttpServerClientStackCapacity  resignFirstResponder];
    [_HttpServerStructStackCapacity  resignFirstResponder];
    [_HttpServerConnBufferSize  resignFirstResponder];
    [_HttpServerMaxPostSize  resignFirstResponder];
    [_HttpServerMaxUpdateSize  resignFirstResponder];
    [_SessionOutTime  resignFirstResponder];
    [_SessionCheckTime  resignFirstResponder];
    [_MsgSessionTimeOut  resignFirstResponder];
    [_MsgMsgTimeOut resignFirstResponder];
    [_LogStayTime resignFirstResponder];
    [_LogMaxStayRecordCount resignFirstResponder];
    [_LogLogCheckTime resignFirstResponder];
    [_SmsComPort resignFirstResponder];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint touchPoint = [touch locationInView:self.messagesAndLogsTableView];
    
    CGRect rectArrow1 = _messagesPortTableView.frame;
    CGRect rectArrow2 = CGRectMake(_messagesPortTableView.frame.origin.x+_messagesPortTableView.frame.size.width-_pullDownButton.frame.size.width, _messagesPortTableView.frame.origin.y-_pullDownButton.frame.size.height, _pullDownButton.frame.size.width, _pullDownButton.frame.size.height);
    
    //Touch either arrows or month in middle
    if (!CGRectContainsPoint(rectArrow1, touchPoint) && !CGRectContainsPoint(rectArrow2, touchPoint)) {
        _messagesPortTableView.hidden = YES;
        return YES;
    }else {
        [self releaseKeyBoard];
        return NO;
    }
}

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - keyboardState
- (void)keyboardShow
{
    _keyboardState = YES;
}

- (void)keyboardHide
{
    _keyboardState = NO;
}

#pragma mark - view即将移除时
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.judgeBack = YES;
}

@end
