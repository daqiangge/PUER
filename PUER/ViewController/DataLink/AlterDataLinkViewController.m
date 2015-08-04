//
//  AlterDataLinkViewController.m
//  PUER
//
//  Created by admin on 14-8-29.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "AlterDataLinkViewController.h"
#import "LableAndTextFieldTableViewCell.h"
#import "LableAndTextViewTableViewCell.h"
#import "LableAndTextFieldAndPullDownButtonTableViewCell.h"
#import "LableAndButtonTableViewCell.h"
#import "LQDateLinkJson.h"
#import "LQDataLinkData.h"

#define providerArray (@[@"SQLOLEDB.1",@"SQLNCLI11.1",@"Microsoft.Jet.OLEDB.4.0",@"MSDAORA.1",@"MSDASQL.1"])
#define cell_detailsTableViewNameLable_textArray (@[@"连接名称",@"提供程序",@"服务器名称",@"数据库名称",@"用户名",@"密码",@"描述"])
#define cell_otherTableVIewNameLable_textArray (@[@"连接超时",@"连接池大小",@"命令超时",@"取连接超时",@"监听周期",@"断网自动连接"])
#define cell_detailsTableViewNameLable_frame (CGRectMake(10, 0, 80, 50))
#define cellRow_height 50

@interface AlterDataLinkViewController ()

@property (nonatomic, strong) NSMutableArray *providerListArray;

@end

@implementation AlterDataLinkViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//        self.view.backgroundColor = [UIColor whiteColor];
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldChange) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textviewChange) name:UITextViewTextDidChangeNotification object:nil];
    
    //防止键盘遮挡住输入框
    _keyBoardController=[[UIKeyboardViewController alloc] initWithControllerDelegate:self];
    
    _alterDic   = [[NSMutableDictionary alloc] init];
    _judgeBack  = NO;
    _selectButtonNum = 1;
    
    if (_isNewAdd) {
        
        [super setNavTitle:@"新增数据连接池"];
        
        [_alterDic setObject:@"" forKey:@"connname"];
        [_alterDic setObject:@"" forKey:@"datasource"];
        [_alterDic setObject:@"" forKey:@"initialcatalog"];
        [_alterDic setObject:@"" forKey:@"username"];
        [_alterDic setObject:@"" forKey:@"password"];
        [_alterDic setObject:@"" forKey:@"displayname"];
        [_alterDic setObject:@"30" forKey:@"connectiontimeout"];
        [_alterDic setObject:@"64" forKey:@"poolmaxcount"];
        [_alterDic setObject:@"60" forKey:@"commandtimeout"];
        [_alterDic setObject:@"30" forKey:@"connectiontimeout"];
        [_alterDic setObject:@"60" forKey:@"checktime"];
        [_alterDic setObject:[NSNumber numberWithInt:1] forKey:@"needlisten"];
        
        [self getProviderListRequest];
    }else {
        
        [super setNavTitle:@"修改数据连接池"];
        
        [self doRequset];
    }
    [self doLoading];
}

- (NSMutableArray *)providerListArray
{
    if (_providerListArray == nil) {
        _providerListArray = [NSMutableArray array];
    }
    
    return _providerListArray;
}

- (void)setIsNewAdd:(BOOL)isNewAdd
{
    _isNewAdd = isNewAdd;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (self.view.window == nil) {
        self.view = nil;
    }
}

- (void)doLoading
{
    //选项卡背景
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.frame           = CGRectMake(0, 64, SCREEN_WIDTH, 40);
    [self.view addSubview:bgView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame        = CGRectMake(0, 0, SCREEN_WIDTH, bgView.frame.size.height);
    imageView.image        = [UIImage imageNamed:@"alterbg"];
    [bgView addSubview:imageView];
    
    //选项卡中“详细信息”按钮
    _detailsButton                     = [[UIButton alloc] init];
    self.detailsButton.frame           = CGRectMake(0, 0, SCREEN_WIDTH/2, 40);
    self.detailsButton.tag             = 10;
    self.detailsButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.detailsButton setBackgroundImage:[UIImage imageNamed:@"bgline"] forState:UIControlStateNormal];
    [self.detailsButton addTarget:self action:@selector(doChoose:) forControlEvents:UIControlEventTouchUpInside];
    [self.detailsButton setTitle:@"详细信息" forState:UIControlStateNormal];
    [self.detailsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bgView addSubview:self.detailsButton];
    
    //选项卡中“其他”按钮
    _otherButton                     = [[UIButton alloc] init];
    self.otherButton.frame           = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 40);
    self.otherButton.tag             = 11;
    self.otherButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.otherButton setBackgroundImage:[UIImage imageNamed:@"bgnull"] forState:UIControlStateNormal];
    [self.otherButton addTarget:self action:@selector(doChoose:) forControlEvents:UIControlEventTouchUpInside];
    [self.otherButton setTitle:@"其他" forState:UIControlStateNormal];
    [self.otherButton setTitleColor:TAB_HaveNotBeenSelected_TitleCollor forState:UIControlStateNormal];
    [bgView addSubview:self.otherButton];
    
    //“详细信息”列表
    _detailsTableView                = [[UITableView alloc] init];
    self.detailsTableView.frame      = CGRectMake(0, bgView.frame.origin.y+bgView.frame.size.height+7.5, SCREEN_WIDTH, SCREEN_HEIGHT-bgView.frame.size.height);
    self.detailsTableView.delegate   = self;
    self.detailsTableView.dataSource = self;
    self.detailsTableView.hidden     = NO;
    self.detailsTableView.delaysContentTouches = NO;//使列表上按钮出现高亮状态
    [self.detailsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.detailsTableView];
    
    //“其他”列表
    _otherTableView                  = [[UITableView alloc] init];
    self.otherTableView.frame        = CGRectMake(0, self.detailsTableView.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT-bgView.frame.size.height);
    self.otherTableView.delegate     = self;
    self.otherTableView.dataSource   = self;
    self.otherTableView.hidden       = YES;
    self.otherTableView.delaysContentTouches = NO;//使列表上按钮出现高亮状态
    [self.otherTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.otherTableView];
    
    //“详细信息”列表中提供数据选项的下拉选项框
    _programChooseTableView                       = [[UITableView alloc] init];
    self.programChooseTableView.frame             = CGRectMake(100, 95, SCREEN_WIDTH-110, 150);
    self.programChooseTableView.hidden            = YES;
    self.programChooseTableView.delegate          = self;
    self.programChooseTableView.dataSource        = self;
    self.programChooseTableView.layer.borderColor = [UIColor grayColor].CGColor;
    self.programChooseTableView.layer.borderWidth = 0.5;
    [self.detailsTableView addSubview:self.programChooseTableView];
    
    //给tableview注册一个cell模板
    NSString *detailsIdenifier1 = @"detailsTableViewCell1";
    UINib *detailsNib1 = [UINib nibWithNibName:@"LableAndTextFieldTableViewCell" bundle:nil];
    [self.detailsTableView registerNib:detailsNib1 forCellReuseIdentifier:detailsIdenifier1];
    
    //给tableview注册一个cell模板
    NSString *detailsIdenifier2 = @"detailsTableViewCell2";
    UINib *detailsNib2 = [UINib nibWithNibName:@"LableAndTextFieldAndPullDownButtonTableViewCell" bundle:nil];
    [self.detailsTableView registerNib:detailsNib2 forCellReuseIdentifier:detailsIdenifier2];
    
    //给tableview注册一个cell模板
    NSString *detailsIdenifier3 = @"detailsTableViewCell3";
    UINib *detailsNib3 = [UINib nibWithNibName:@"LableAndTextViewTableViewCell" bundle:nil];
    [self.detailsTableView registerNib:detailsNib3 forCellReuseIdentifier:detailsIdenifier3];
    
    //给tableview注册一个cell模板
    NSString *otherIdenifier1 = @"otherTableViewCell1";
    UINib *otherNib1 = [UINib nibWithNibName:@"LableAndTextFieldTableViewCell" bundle:nil];
    [_otherTableView registerNib:otherNib1 forCellReuseIdentifier:otherIdenifier1];
    
    //给tableview注册一个cell模板
    NSString *otherIdenifier2 = @"otherTableViewCell2";
    UINib *otherNib2 = [UINib nibWithNibName:@"LableAndButtonTableViewCell" bundle:nil];
    [_otherTableView registerNib:otherNib2 forCellReuseIdentifier:otherIdenifier2];
    
    
    //“详细信息”列表保存按钮
    UIButton *saveButton1  = [[UIButton alloc] init];
    saveButton1.frame      = CGRectMake(10, 6*50+100+10, SCREEN_WIDTH-20, 40);
    saveButton1.titleLabel.font = [UIFont systemFontOfSize:16];
    [saveButton1 setBackgroundImage:[UIImage imageNamed:@"buttonbg3"] forState:UIControlStateNormal];
    [saveButton1 setTitle:@"确定" forState:UIControlStateNormal];
    [saveButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton1 addTarget:self action:@selector(doSave) forControlEvents:UIControlEventTouchUpInside];
    [_detailsTableView addSubview:saveButton1];
    
    //“详细信息”列表测试连接按钮
    UIButton *testButton1  = [[UIButton alloc] init];
    testButton1.frame      = CGRectMake(saveButton1.frame.origin.x, saveButton1.frame.origin.y+saveButton1.frame.size.height+10, saveButton1.frame.size.width, saveButton1.frame.size.height);
    testButton1.titleLabel.font = [UIFont systemFontOfSize:16];
    [testButton1 setBackgroundImage:[UIImage imageNamed:@"buttonbg4"] forState:UIControlStateNormal];
    [testButton1 setTitle:@"测试连接" forState:UIControlStateNormal];
    [testButton1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [testButton1 addTarget:self action:@selector(testConnection) forControlEvents:UIControlEventTouchUpInside];
    [_detailsTableView addSubview:testButton1];
    
    
    //“其他”列表保存按钮
    UIButton *saveButton2  = [[UIButton alloc] init];
    saveButton2.frame      = CGRectMake(10, 6*50+10, SCREEN_WIDTH-20, 40);
    saveButton2.titleLabel.font = [UIFont systemFontOfSize:16];
    [saveButton2 setBackgroundImage:[UIImage imageNamed:@"buttonbg3"] forState:UIControlStateNormal];
    [saveButton2 setTitle:@"确定" forState:UIControlStateNormal];
    [saveButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton2 addTarget:self action:@selector(doSave) forControlEvents:UIControlEventTouchUpInside];
    [_otherTableView addSubview:saveButton2];
    
    //“其他”列表测试连接按钮
    UIButton *testButton2  = [[UIButton alloc] init];
    testButton2.frame      = CGRectMake(saveButton2.frame.origin.x, saveButton2.frame.origin.y+saveButton2.frame.size.height+10, saveButton2.frame.size.width, saveButton2.frame.size.height);
    testButton2.titleLabel.font = [UIFont systemFontOfSize:16];
    [testButton2 setBackgroundImage:[UIImage imageNamed:@"buttonbg4"] forState:UIControlStateNormal];
    [testButton2 setTitle:@"测试连接" forState:UIControlStateNormal];
    [testButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [testButton2 addTarget:self action:@selector(testConnection) forControlEvents:UIControlEventTouchUpInside];
    [_otherTableView addSubview:testButton2];
    
    //设置点击空白处释放键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(releaseKeyBoard)];
    tapGestureRecognizer.numberOfTapsRequired = 1; // * 点击空白处几下
    tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _detailsTableView) {
        return 8;
    }else if (tableView == _otherTableView) {
        return 7;
    }else {
        return self.providerListArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _detailsTableView) {
        
        NSArray *arr = cell_detailsTableViewNameLable_textArray;
        
        if (indexPath.row == 1 ) {
            static NSString *detailsTableViewIdenifier2           = @"detailsTableViewCell2";
            LableAndTextFieldAndPullDownButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailsTableViewIdenifier2];
            [cell setNameLableFrameAndContentFrame:cell_detailsTableViewNameLable_frame];
            cell.selectionStyle                  = UITableViewCellSelectionStyleNone;
            
            cell.nameLable.text = arr[indexPath.row];
            
            cell.contentTextField.text  = [self.alterDic objectForKey:@"provider"];
            _providerTextField          = cell.contentTextField;
            _providerTextField.enabled  = YES;
            _providerTextField.delegate = self;
            _pullDownButton             = cell.pullDownButton;
            [_pullDownButton addTarget:self action:@selector(programChoose) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
            
        }else if (indexPath.row < 6 && indexPath.row != 1) {
            
            static NSString *detailsTableViewIdenifier1           = @"detailsTableViewCell1";
            LableAndTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailsTableViewIdenifier1];
            cell.selectionStyle                  = UITableViewCellSelectionStyleNone;
            [cell setNameLableFrameAndContentFrame:cell_detailsTableViewNameLable_frame];
            cell.nameLable.text = arr[indexPath.row];
            
            switch (indexPath.row) {
                case 0:
                {
                    cell.contentTextField.text   = [self.alterDic objectForKey:@"connname"];
                    _connNameTextField          = cell.contentTextField;
                    _connNameTextField.delegate = self;
                    _connNameTextField.keyboardType = UIKeyboardTypeDefault;
                }
                    break;
                    
                case 2:
                {
                    cell.contentTextField.text    = [self.alterDic objectForKey:@"datasource"];
                    _dataSourceTextField          = cell.contentTextField;
                    _dataSourceTextField.keyboardType = UIKeyboardTypeDefault;
                    _dataSourceTextField.delegate = self;
                }
                    break;
                    
                case 3:
                {
                    NSArray *arr = providerArray;
                    for (int i = 0 ; i<arr.count; i ++) {
                        
                        if ([_providerTextField.text isEqualToString:@""]) {
                            _dataSourceTextField.placeholder = @"";
                            _initialCataLogTextField.enabled = YES;
                            cell.nameLable.alpha = 1;
                        }
                        
                        if ([[self.alterDic objectForKey:@"dbtype"] isEqualToString:@"ORACLE"]||[[self.alterDic objectForKey:@"dbtype"] isEqualToString:@"ACCESS"]) {
                            _dataSourceTextField.placeholder = @"";
                            [self.alterDic setObject:@"" forKey:@"initialcatalog"];
                            cell.nameLable.alpha = 0.5;
                            _initialCataLogTextField.enabled = NO;
                            
                            if ([[self.alterDic objectForKey:@"dbtype"] isEqualToString:@"ACCESS"]) {
                                _dataSourceTextField.placeholder = @"<root>开头的数据库相对地址";
                            }
                        }else {
                            _dataSourceTextField.placeholder = @"";
                            _initialCataLogTextField.enabled = YES;
                            cell.nameLable.alpha = 1;
                        }
                    }
                    
                    cell.contentTextField.text        = [self.alterDic objectForKey:@"initialcatalog"];
                    _initialCataLogTextField          = cell.contentTextField;
                    _initialCataLogTextField.keyboardType = UIKeyboardTypeDefault;
                    _initialCataLogTextField.delegate = self;
                }
                    break;
                    
                case 4:
                {
                    cell.contentTextField.text  = [self.alterDic objectForKey:@"username"];
                    self.userTextField          = cell.contentTextField;
                    _userTextField.keyboardType = UIKeyboardTypeDefault;
                    self.userTextField.delegate = self;
                }
                    break;
                    
                case 5:
                {
                    [cell.contentTextField setSecureTextEntry:YES];
                    cell.contentTextField.text  = [self.alterDic objectForKey:@"password"];
                    _passwordTextField          = cell.contentTextField;
                    _passwordTextField.delegate = self;
                }
                    break;
                    
                default:
                    break;
            }
            
            return cell;
        }else if (indexPath.row == 6) {
            static NSString *detailsTableViewIdenifier3           = @"detailsTableViewCell3";
            LableAndTextViewTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:detailsTableViewIdenifier3];
            cell.selectionStyle                  = UITableViewCellSelectionStyleNone;
            [cell setNameLableFrameAndContentFrame:cell_detailsTableViewNameLable_frame];
            cell.nameLable.text                   = arr[indexPath.row];
            
            cell.contentTextView.text             = [self.alterDic objectForKey:@"displayname"];
            self.displayNameTextView              = cell.contentTextView;
            self.displayNameTextView.delegate     = self;
            
            return cell;
        }else {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle   = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        
    }else if (tableView == _otherTableView){
        
        NSArray *arr = cell_otherTableVIewNameLable_textArray;
        
        if (indexPath.row < 5) {
            static NSString *otherTableViewIenifier1            = @"otherTableViewCell1";
            LableAndTextFieldTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:otherTableViewIenifier1];
            cell.selectionStyle                   = UITableViewCellSelectionStyleNone;
            [cell setNameLableFrameAndContentFrame:cell_detailsTableViewNameLable_frame];
            cell.nameLable.text = arr[indexPath.row];
            cell.contentTextField.keyboardType = UIKeyboardTypeNumberPad;
            
            switch (indexPath.row) {
                case 0:
                {
                    
                    if (self.alterDic.count == 0) {
                        cell.contentTextField.text      = @"";
                    }else {
                        cell.contentTextField.text      = [NSString stringWithFormat:@"%@",[self.alterDic objectForKey:@"connectiontimeout"]];
                    }
                    
                    _connectionTimeOutTextField                  = cell.contentTextField;
                    self.connectionTimeOutTextField.delegate     = self;
                    
                }
                    break;
                    
                case 1:
                {
                    if (self.alterDic.count == 0) {
                        cell.contentTextField.text      = @"";
                    }else {
                        cell.contentTextField.text      = [NSString stringWithFormat:@"%@",[self.alterDic objectForKey:@"poolmaxcount"]];
                    }
                    
                    _poolMaxCountTextField                  = cell.contentTextField;
                    self.poolMaxCountTextField.delegate     = self;
                }
                    break;
                    
                case 2:
                {
                    if (self.alterDic.count == 0) {
                        cell.contentTextField.text      = @"";
                    }else {
                        cell.contentTextField.text      = [NSString stringWithFormat:@"%@",[self.alterDic objectForKey:@"commandtimeout"]];
                    }
                    
                    _commandTimeOutTextField                  = cell.contentTextField;
                    self.commandTimeOutTextField.delegate     = self;
                }
                    break;
                    
                case 3:
                {
                    if (self.alterDic.count == 0) {
                        cell.contentTextField.text      = @"";
                    }else {
                        cell.contentTextField.text      = [NSString stringWithFormat:@"%@",[self.alterDic objectForKey:@"connectiontimeout"]];
                    }
                    
                    //连接名称
                    _poolTimeOutTextField                  = cell.contentTextField;
                    self.poolTimeOutTextField.delegate     = self;
                }
                    break;
                    
                case 4:
                {
                    if (self.alterDic.count == 0) {
                        cell.contentTextField.text      = @"";
                    }else {
                        cell.contentTextField.text      = [NSString stringWithFormat:@"%@",[self.alterDic objectForKey:@"checktime"]];
                    }
                    
                    //连接名称
                    _checkTimeTextField                  = cell.contentTextField;
                    self.checkTimeTextField.delegate     = self;
                }
                    break;
                    
                default:
                    break;
            }
            
            return cell;
            
        }else if (indexPath.row == 5){
            static NSString *otherTableViewIenifier2            = @"otherTableViewCell2";
            LableAndButtonTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:otherTableViewIenifier2];
            cell.selectionStyle                   = UITableViewCellSelectionStyleNone;
            [cell setNameLableFrameAndContentFrame:CGRectMake(10, 0, 90, cellRow_height)];
            cell.nameLable.text = arr[indexPath.row];
            
            _connectionButton = cell.chooseButton;
            [self.connectionButton addTarget:self action:@selector(automaticConnection) forControlEvents:UIControlEventTouchUpInside];
            
            if ([[self.alterDic objectForKey:@"needlisten"] isEqualToNumber:@1]) {
                self.connectionButton.selected = YES;
            }else {
                self.connectionButton.selected = NO;
            }
            
            return cell;
        }else {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    
    }else {
            
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            LQDataLinkData *item = self.providerListArray[indexPath.row];
        
            cell.textLabel.text   = item.provider;
            cell.textLabel.font   = [UIFont fontWithName:TextFont_name size:15];
            
            return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _programChooseTableView) {
        LQDataLinkData *item = self.providerListArray[indexPath.row];
        [_alterDic setObject:item.provider forKey:@"provider"];
        [_alterDic setObject:item.dbtype forKey:@"dbtype"];
        [self.detailsTableView reloadData];
    }
    self.programChooseTableView.hidden = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _programChooseTableView) {
        return 30;
    }
    if (tableView == _detailsTableView ) {
        if (indexPath.row == 6) {
            return 200;
        }else if (indexPath.row == 7) {
            return 100;
        }
    }
    if (tableView == _otherTableView && indexPath.row == 5) {
        return 200;
    }
    return cellRow_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

#pragma mark - 网络请求
- (void)doRequset
{
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载…";
    
    //判断当前网络状况
    if (![GetNetworkStates getNetWorkStates]) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
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
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/connpool/getdbconnbyname.do;sessionid=%@",IP,port,sid];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:_connname,@"ConnName", nil];
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"connname"] forKey:@"connname"];
            [dic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"datasource"] forKey:@"datasource"];
            [dic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"pooltimeout"] forKey:@"pooltimeout"];
            [dic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"poolmaxcount"] forKey:@"poolmaxcount"];
            [dic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"commandtimeout"] forKey:@"commandtimeout"];
            [dic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"needlisten"] forKey:@"needlisten"];
            [dic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"initialcatalog"] forKey:@"initialcatalog"];
            [dic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"connectiontimeout"] forKey:@"connectiontimeout"];
            [dic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"checktime"] forKey:@"checktime"];
            [dic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"provider"] forKey:@"provider"];
            [dic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"password"] forKey:@"password"];
            [dic setObject:[super ASCIIString:[[resultDic objectForKey:@"data"] objectForKey:@"displayname"]] forKey:@"displayname"];
            [dic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"username"] forKey:@"username"];
            [dic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"needlisten"] forKey:@"needlisten"];
            [dic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"dbtype"] forKey:@"dbtype"];
            
            self.alterDic = dic;
            
            _connname = [[resultDic objectForKey:@"data"] objectForKey:@"connname"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.detailsTableView reloadData];
                [self.otherTableView reloadData];
            });
            
            [self getProviderListRequest];
            
        }else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"]) {
            
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            
            if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"]) {
                [self.loginAgain_AlterView show];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        if (!self.judgeBack) {
            [self.requestError_AlterView show];
        }
    }];
}

/**
 *  获取数据库连接驱动列表
 */
- (void)getProviderListRequest
{
    if (self.isNewAdd) {
        //等待指示器
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"正在获取数据库连接驱动列表...";
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/connpool/getproviderlist.do;sessionid=%@",IP,port,sid];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:urlStr parameters:nil timeoutInterval:20 cachePolicy:NSURLRequestUseProtocolCachePolicy success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        
        LQDateLinkJson *data = [LQDateLinkJson objectWithKeyValues:operation.responseString];
        
        if ([data.state.returnn isEqualToString:@"true"]) {
            
            for (LQDataLinkData *item in data.data) {
                [self.providerListArray addObject:item];
            }
            
            if (self.isNewAdd) {
                LQDataLinkData *item = self.providerListArray[0];
                [_alterDic setObject:item.provider forKey:@"provider"];
            }
            
            [self.programChooseTableView reloadData];
            
        }else {
            if (!self.judgeBack) {
                if ([data.state.code isEqualToString:@"1006"]) {
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:data.state.info
                                                                   delegate:self
                                                          cancelButtonTitle:@"重试"
                                                          otherButtonTitles:@"重新登录", nil];
                    [alter show];
                }else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:data.state.info
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles: nil];
                    [alert show];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        if (!self.judgeBack) {
            if (error.code == -1001) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"网络连接超时"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles: nil];
                [alert show];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"网络异常,请检查你的网络"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles: nil];
                [alert show];
            }
        }
    }];
}

//修改
- (void)doModify
{
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在保存...";
    
    //判断当前网络状况
    if (![GetNetworkStates getNetWorkStates]) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        return;
    }
    
    NSString *needListen;
    if (self.connectionButton.selected) {
        needListen = @"1";
    }else {
        needListen = @"0";
    }
    
    //发送保存请求
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = TimeoutInterval;
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/connpool/savedbconn.do;sessionid=%@",IP,port,sid];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       _connname,@"OldConnName",
                                       self.connNameTextField.text,@"ConnName",
                                       self.displayNameTextView.text,@"DisplayName",
                                       self.providerTextField.text,@"provider",
                                       self.dataSourceTextField.text,@"DataSource",
                                       self.initialCataLogTextField.text,@"InitialCataLog",
                                       self.userTextField.text,@"username",
                                       self.passwordTextField.text,@"PassWord",
                                       self.connectionTimeOutTextField.text,@"ConnectionTimeOut",
                                       self.commandTimeOutTextField.text,@"CommandTimeOut",
                                       self.poolMaxCountTextField.text,@"PoolMaxCount",
                                       self.poolTimeOutTextField.text,@"PoolTimeOut",
                                       needListen,@"NeedListen",
                                       self.checkTimeTextField.text,@"CheckTime", nil];
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            
            _connname = self.connNameTextField.text;
            
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"保存成功,重启平台后生效";
            
            //通知数据连接列表刷新列表
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DataLinkDidSave" object:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            });
            
        }else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"]) {
            
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window]animated:YES];
            
            if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"]) {
                [self.loginAgain_AlterView show];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
//        NSLog(@"%@",error);
        if (!_judgeBack) {
            [self.requestError_AlterView show];
        }
        
    }];
}

- (void)doNewAdd
{
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在保存...";
    
    //判断当前网络状况
    if (![GetNetworkStates getNetWorkStates]) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        return;
    }
    
    NSString *needListen;
    if (self.connectionButton.selected) {
        needListen = @"1";
    }else {
        needListen = @"0";
    }
    
    //发送保存请求
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = TimeoutInterval;
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/connpool/adddbconn.do;sessionid=%@",IP,port,sid];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.connNameTextField.text,@"ConnName",
                                       self.displayNameTextView.text,@"DisplayName",
                                       self.providerTextField.text,@"provider",
                                       self.dataSourceTextField.text,@"DataSource",
                                       self.initialCataLogTextField.text,@"InitialCataLog",
                                       self.userTextField.text,@"username",
                                       self.passwordTextField.text,@"PassWord",
                                       self.connectionTimeOutTextField.text,@"ConnectionTimeOut",
                                       self.commandTimeOutTextField.text,@"CommandTimeOut",
                                       self.poolMaxCountTextField.text,@"PoolMaxCount",
                                       self.poolTimeOutTextField.text,@"PoolTimeOut",
                                       needListen,@"NeedListen",
                                       self.checkTimeTextField.text,@"CheckTime", nil];
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"保存成功,重启平台后生效";
            
            self.titleLable.text = @"修改数据池连接";
            _connname = self.connNameTextField.text;
            _isNewAdd = NO;
            
            //通知数据连接列表刷新列表
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DataLinkDidSave" object:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            });
            
        }else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"]) {
            
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window]animated:YES];
            
            if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"]) {
                [self.loginAgain_AlterView show];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
//        NSLog(@"%@",error);
        if (!_judgeBack) {
            
            [self.requestError_AlterView show];
        }
        
    }];
}

#pragma mark - 选项课选择操作
- (void)doChoose:(UIButton *)button
{
    if (button.tag == 10) {
        
        if (_selectButtonNum != 1) {
            _selectButtonNum = 1;
            [self releaseKeyBoard];
        }
        
        [self.detailsButton setBackgroundImage:[UIImage imageNamed:@"bgline"] forState:UIControlStateNormal];
        [self.otherButton setBackgroundImage:[UIImage imageNamed:@"bgnull"] forState:UIControlStateNormal];
        
        [self.detailsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.otherButton setTitleColor:TAB_HaveNotBeenSelected_TitleCollor forState:UIControlStateNormal];
        
        self.detailsTableView.hidden     = NO;
        self.otherTableView.hidden       = YES;
        
    }else if (button.tag == 11) {
        
        if (_selectButtonNum != 2) {
            _selectButtonNum = 2;
            [self releaseKeyBoard];
        }
        
        [self.detailsButton setBackgroundImage:[UIImage imageNamed:@"bgnull"] forState:UIControlStateNormal];
        [self.otherButton setBackgroundImage:[UIImage imageNamed:@"bgline"] forState:UIControlStateNormal];
        
        [self.detailsButton setTitleColor:TAB_HaveNotBeenSelected_TitleCollor forState:UIControlStateNormal];
        [self.otherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        self.detailsTableView.hidden     = YES;
        self.otherTableView.hidden       = NO;
    }
}

#pragma mark - 提供程序中的剪头按钮操作
- (void)programChoose
{
    [self releaseKeyBoard];
    
    self.programChooseTableView.hidden = !self.programChooseTableView.hidden;
}


#pragma mark - “其他”列表中断网重连的按钮操作
- (void)automaticConnection
{
    self.connectionButton.selected = !self.connectionButton.selected;
}

#pragma mark - 保存按钮的保存操作
- (void)doSave
{
    [self releaseKeyBoard];
    
    //判断输入框是否符合要求
    if ([self.connNameTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请正确填写连接名称" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if ([self.providerTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写提供程序" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if ([self.dataSourceTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写服务器名称" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if ([self.connectionTimeOutTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写连接超时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if ([self.poolMaxCountTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写连接池大小" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if ([self.commandTimeOutTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写命令超时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if ([self.poolTimeOutTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写获取连接超时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if ([self.checkTimeTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写监听周期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    
    if ([self.connectionTimeOutTextField.text intValue]<5 || [self.connectionTimeOutTextField.text intValue]>300) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接超时必须在5～300之间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if ([self.poolMaxCountTextField.text intValue]<1 || [self.poolMaxCountTextField.text intValue]>256) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接池大小必须在1～256之间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if ([self.commandTimeOutTextField.text intValue]<5 || [self.commandTimeOutTextField.text intValue]>300) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"命令超时必须在5～300之间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if ([self.poolTimeOutTextField.text intValue]<5 || [self.poolTimeOutTextField.text intValue]>300) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取连接超时必须在5～300之间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if ([self.checkTimeTextField.text intValue]<5 || [self.checkTimeTextField.text intValue]>300) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"监听周期必须在5～300之间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if (_isNewAdd) {
        [self doNewAdd];
    }else {
        [self doModify];
    }
    
}

#pragma mark - 测试连接按钮的操作请求
- (void)testConnection
{
    //判断输入框是否符合要求
    if ([self.providerTextField.text isEqualToString:@""] || [self.dataSourceTextField.text isEqualToString:@""] ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请正确填写提供程序、服务器名称" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    //判断当前网络状况
    if (![super isConnectionAvailable]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常,请检查你的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在测试...";
    
    //发送保存请求
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = TimeoutInterval;
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/connpool/testdbconn2.do;sessionid=%@",IP,port,sid];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.providerTextField.text,@"provider",
                                       self.dataSourceTextField.text,@"DataSource",
                                       self.initialCataLogTextField.text,@"InitialCataLog",
                                       self.userTextField.text,@"username",
                                       self.passwordTextField.text,@"PassWord",nil];
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        resultStr                = [resultStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        resultStr                = [resultStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"连接成功";
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            });
            
        }else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"]) {
            
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            
            if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"]) {
                [self.loginAgain_AlterView show];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        if (!self.judgeBack) {
            [self.requestError_AlterView show];
        }
        
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint touchPoint = [touch locationInView:_detailsTableView];
    
    CGRect rectArrow1 = _programChooseTableView.frame;
    CGRect rectArrow2 = CGRectMake(_programChooseTableView.frame.origin.x+_programChooseTableView.frame.size.width-_pullDownButton.frame.size.width, _programChooseTableView.frame.origin.y-_pullDownButton.frame.size.height, _pullDownButton.frame.size.width, _pullDownButton.frame.size.height);
    
    //Touch either arrows or month in middle
    if (!CGRectContainsPoint(rectArrow1, touchPoint) && !CGRectContainsPoint(rectArrow2, touchPoint)) {
        _programChooseTableView.hidden = YES;
    }
    if (CGRectContainsPoint(rectArrow1, touchPoint) && !_programChooseTableView.hidden ) {
        return NO;
    }
    return YES;
}

#pragma mark - 点击空白处事件
//点击空白处释放键盘
- (void)releaseKeyBoard
{
    [self.connNameTextField          resignFirstResponder];
    [self.providerTextField          resignFirstResponder];
    [self.dataSourceTextField        resignFirstResponder];
    [self.initialCataLogTextField    resignFirstResponder];
    [self.userTextField              resignFirstResponder];
    [self.passwordTextField          resignFirstResponder];
    [self.displayNameTextView        resignFirstResponder];
    [self.connectionTimeOutTextField resignFirstResponder];
    [self.poolMaxCountTextField      resignFirstResponder];
    [self.commandTimeOutTextField    resignFirstResponder];
    [self.poolTimeOutTextField       resignFirstResponder];
    [self.checkTimeTextField         resignFirstResponder];
}

#pragma mark - Textfield Delegate
//释放键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self releaseKeyBoard];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _programChooseTableView.hidden = YES;
    
    return YES;
}

//限制输入框字符串长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"])  //按会车可以改变
        
    {
        return YES;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:nil];
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (self.connNameTextField == textField)
    {
        if ([toBeString length] > 64) { //如果输入框内容大于20则弹出警告
            //如果粘贴内容大于24，将只截取前24的字符
            textField.text = [toBeString substringToIndex:64];
            [_alterDic setObject:textField.text forKey:@"connname"];
            return NO;
        }
        
        for (int i = 0; i<[toBeString length]; i++) {
            //截取字符串中的每一个字符
            NSString *s = [toBeString substringWithRange:NSMakeRange(i, 1)];
            if (![[Regex shareInstance] judgeConnName:s]) {
                return NO;
            }
        }
    }else if (self.dataSourceTextField == textField)
    {
        
        if ([toBeString length] > 64) { //如果输入框内容大于20则弹出警告
            //如果粘贴内容大于24，将只截取前24的字符
            textField.text = [toBeString substringToIndex:64];
            [_alterDic setObject:textField.text forKey:@"datasource"];
            
            return NO;
            
        }
    }else if (self.initialCataLogTextField == textField)
    {
        
        if ([toBeString length] > 64) { //如果输入框内容大于20则弹出警告
            //如果粘贴内容大于24，将只截取前24的字符
            textField.text = [toBeString substringToIndex:64];
            [_alterDic setObject:textField.text forKey:@"initialcatalog"];
            
            return NO;
            
        }
    }else if (self.userTextField == textField)
    {
        
        if ([toBeString length] > 64) { //如果输入框内容大于20则弹出警告
            //如果粘贴内容大于24，将只截取前24的字符
            textField.text = [toBeString substringToIndex:64];
            [_alterDic setObject:textField.text forKey:@"username"];
            
            return NO;
            
        }
    }else if (self.passwordTextField == textField)
    {
        
        if ([toBeString length] > 20) { //如果输入框内容大于20则弹出警告
            //如果粘贴内容大于24，将只截取前24的字符
            textField.text = [toBeString substringToIndex:20];
            [_alterDic setObject:textField.text forKey:@"password"];
            
            return NO;
            
        }
        
        //判读是是否有中文
        for (int i = 0; i<[toBeString length]; i++) {
            //截取字符串中的每一个字符
            NSString *s = [toBeString substringWithRange:NSMakeRange(i, 1)];
            if ([[Regex shareInstance] judgeChinese:s]) {
                return NO;
            }
        }
        
    }else if (self.connectionTimeOutTextField == textField)
    {
        
        if ([toBeString length] > 3) {
            textField.text = [toBeString substringToIndex:3];
            [_alterDic setObject:textField.text forKey:@"connectiontimeout"];
            
            return NO;
            
        }
        
        for (int i = 0; i<[toBeString length]; i++) {
            //截取字符串中的每一个字符
            NSString *s = [toBeString substringWithRange:NSMakeRange(i, 1)];
            if (![[Regex shareInstance] judgeNumber:s]) {
                return NO;
            }
        }
    }else if (self.poolMaxCountTextField == textField)
    {
        
        if ([toBeString length] > 3) {
            textField.text = [toBeString substringToIndex:3];
            [_alterDic setObject:textField.text forKey:@"poolmaxcount"];
            
            return NO;
            
        }
        
        for (int i = 0; i<[toBeString length]; i++) {
            //截取字符串中的每一个字符
            NSString *s = [toBeString substringWithRange:NSMakeRange(i, 1)];
            if (![[Regex shareInstance] judgeNumber:s]) {
                return NO;
            }
        }
    }else if (self.commandTimeOutTextField == textField)
    {
        
        if ([toBeString length] > 3) {
            textField.text = [toBeString substringToIndex:3];
            [_alterDic setObject:textField.text forKey:@"commandtimeout"];
            
            return NO;
            
        }
        
        for (int i = 0; i<[toBeString length]; i++) {
            //截取字符串中的每一个字符
            NSString *s = [toBeString substringWithRange:NSMakeRange(i, 1)];
            if (![[Regex shareInstance] judgeNumber:s]) {
                return NO;
            }
        }
    }else if (self.poolTimeOutTextField == textField)
    {
        
        if ([toBeString length] > 3) {
            textField.text = [toBeString substringToIndex:3];
            [_alterDic setObject:textField.text forKey:@"pooltimeout"];
            
            return NO;
            
        }
        
        for (int i = 0; i<[toBeString length]; i++) {
            //截取字符串中的每一个字符
            NSString *s = [toBeString substringWithRange:NSMakeRange(i, 1)];
            if (![[Regex shareInstance] judgeNumber:s]) {
                return NO;
            }
        }
    }else if (self.checkTimeTextField == textField)
    {
        
        if ([toBeString length] > 3) {
            textField.text = [toBeString substringToIndex:3];
            [_alterDic setObject:textField.text forKey:@"checktime"];
            
            return NO;
            
        }
        
        for (int i = 0; i<[toBeString length]; i++) {
            //截取字符串中的每一个字符
            NSString *s = [toBeString substringWithRange:NSMakeRange(i, 1)];
            if (![[Regex shareInstance] judgeNumber:s]) {
                return NO;
            }
        }
    }
    
    return YES;
}

//监听输入框的改变，并将修改过的数据存储，以防tableview的重用机制导致数据复原
- (void)textfieldChange
{
    [_alterDic setObject:self.connNameTextField.text forKey:@"connname"];
    [_alterDic setObject:self.dataSourceTextField.text forKey:@"datasource"];
    [_alterDic setObject:self.initialCataLogTextField.text forKey:@"initialcatalog"];
    [_alterDic setObject:self.userTextField.text forKey:@"username"];
    [_alterDic setObject:self.passwordTextField.text forKey:@"password"];
    [_alterDic setObject:self.connectionTimeOutTextField.text forKey:@"connectiontimeout"];
    [_alterDic setObject:self.poolMaxCountTextField.text forKey:@"poolmaxcount"];
    [_alterDic setObject:self.commandTimeOutTextField.text forKey:@"commandtimeout"];
    [_alterDic setObject:self.poolTimeOutTextField.text forKey:@"pooltimeout"];
    [_alterDic setObject:self.checkTimeTextField.text forKey:@"checktime"];
}

#pragma mark - TextView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:nil];
    
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text]; //得到输入框的内容
    
    if (self.displayNameTextView == textView)
    {
        
        if ([toBeString length] > 1024) { //如果输入框内容大于20则弹出警告
            //如果粘贴内容大于24，将只截取前24的字符
            textView.text = [toBeString substringToIndex:1024];
            [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:nil];
            
            return NO;
            
        }
    }
    return YES;
}

//监听输入框的改变，并将修改过的数据存储，以防tableview的重用机制导致数据复原
- (void)textviewChange
{
    [_alterDic setObject:_displayNameTextView.text forKey:@"displayname"];
}

#pragma mark - view即将移除时
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.judgeBack = YES;
}


@end
