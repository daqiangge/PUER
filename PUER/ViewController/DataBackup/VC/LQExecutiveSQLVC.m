//
//  LQExecutiveSQLVC.m
//  PUER
//
//  Created by admin on 15/6/4.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "LQExecutiveSQLVC.h"
#import "LQDataMaintenanceLoginSQLView.h"
#import "LQDataMaintenanceSQLView.h"
#import "LQExecutiveSQLHeaderView.h"
#import "LQDataBackupJson.h"
#import "PwdSettingViewController.h"

@interface LQExecutiveSQLVC ()<LQExecutiveSQLHeaderViewDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIWebViewDelegate,LQDataMaintenanceLoginSQLViewDelegate,LQDataMaintenanceSQLViewDelegate>

@property (nonatomic, strong) LQDataMaintenanceSQLView *sqlView;
@property (nonatomic, strong) LQDataMaintenanceLoginSQLView *loginView;

@end

@implementation LQExecutiveSQLVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [super setDataBackVCTitile:@"SQL执行" viceTitle:self.connName];
    
    [self loadingView];
    [self getCanRunState];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _judgeBack                = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.judgeBack = YES;
    
        if (![[self.navigationController viewControllers] containsObject:self])
        {
            if ([self.delegate respondsToSelector:@selector(LQExecutiveSQLVCDidPop:)]) {
                [self.delegate LQExecutiveSQLVCDidPop:self];
            }
        }
}

- (LQDataMaintenanceLoginSQLView *)loginView
{
    if (_loginView == nil)
    {
        LQDataMaintenanceLoginSQLView *loginView = [LQDataMaintenanceLoginSQLView dataMaintenanceLoginSQLView];
        loginView.delegate = self;
        loginView.hidden = YES;
        [self.view addSubview:loginView];
        self.loginView = loginView;
    }
    
    return _loginView;
}

- (LQDataMaintenanceSQLView *)sqlView
{
    if (_sqlView == nil)
    {
        LQDataMaintenanceSQLView *sqlView = [LQDataMaintenanceSQLView dataMaintenanceSQLView];
        sqlView.delegate = self;
        sqlView.headerView.delegate = self;
        sqlView.hidden = YES;
        [self.view addSubview:sqlView];
        self.sqlView = sqlView;
    }
    
    return _sqlView;
}

- (void)loadingView
{
    self.loginView.hidden = NO;
}

- (void)setConnName:(NSString *)connName
{
    _connName = connName;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

/**
 *  获得能否执行SQL脚本的状态
 */
- (void)getCanRunState
{
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在获取执行SQL脚本的状态…";
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/db/getcanrunstate.do;sessionid=%@",IP,port,sid];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:urlStr parameters:nil timeoutInterval:20 cachePolicy:NSURLRequestUseProtocolCachePolicy success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        LQDataBackupJson *data = [LQDataBackupJson objectWithKeyValues:operation.responseString];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([data.state.returnn isEqualToString:@"true"]) {
            if (data.data.canrunsql) {
                self.loginView.hidden = YES;
                self.sqlView.hidden = NO;
                [self getCommonSqlNameList];
            }
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
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
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

/**
 *  获取常用命令列表
 */
- (void)getCommonSqlNameList
{
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载常用命令列表…";
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/db/getcommonsqlnamelist.do;sessionid=%@",IP,port,sid];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil timeoutInterval:20 cachePolicy:NSURLRequestUseProtocolCachePolicy success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error;
        NSDictionary *resultDic  = [[CJSONDeserializer deserializer] deserialize:operation.responseData error:&error];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            self.sqlView.dataArray = [resultDic objectForKey:@"data"];
        }else {
            if (!self.judgeBack) {
                if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"]) {
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:[[resultDic objectForKey:@"state"] objectForKey:@"info"]
                                                                   delegate:self
                                                          cancelButtonTitle:@"重试"
                                                          otherButtonTitles:@"重新登录", nil];
                    [alter show];
                }else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:[[resultDic objectForKey:@"state"] objectForKey:@"info"]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles: nil];
                    [alert show];
                }
            }
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
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

/**
 *  执行这段SQL
 */
- (void)executiveSQL
{
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在执行SQL…";
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/db/executesql.do;sessionid=%@",IP,port,sid];
    
    NSString *jsonString = self.sqlView.textView.text;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameter = @{@"ConnName":self.connName,@"Sql":jsonString};
    
    [manager POST:urlStr parameters:parameter timeoutInterval:20 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *dataStr = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        
        NSString *str = [dataStr stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        str = [str stringByReplacingOccurrencesOfString:@"\r\n" withString:@" "];
        str = [str stringByReplacingOccurrencesOfString:@"\n\r" withString:@" "];
        
        LQDataBackupJson *data = [LQDataBackupJson objectWithKeyValues:str];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([data.state.returnn isEqualToString:@"true"]) {
            [self webViewLoadDataWithDataStr:operation.responseString];
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
        NSLog(@"%@",error);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
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

/**
 *  退出执行SQL状态
 */
- (void)logout
{
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在退出执行SQL…";
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/db/logout.do;sessionid=%@",IP,port,sid];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:urlStr parameters:nil timeoutInterval:20 cachePolicy:NSURLRequestUseProtocolCachePolicy success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        LQDataBackupJson *data = [LQDataBackupJson objectWithKeyValues:operation.responseString];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([data.state.returnn isEqualToString:@"true"]) {
            
            self.sqlView.hidden = YES;
            self.loginView.hidden = NO;
            
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
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
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

/**
 *  登陆
 */
- (void)loginRequest
{
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在验证安全密码…";
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/db/login.do;sessionid=%@",IP,port,sid];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"PassWord": self.loginView.passwordTF.text};
    
    [manager POST:urlStr parameters:parameter timeoutInterval:20 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        LQDataBackupJson *data = [LQDataBackupJson objectWithKeyValues:operation.responseString];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([data.state.returnn isEqualToString:@"true"]) {
            self.sqlView.hidden = NO;
            self.loginView.hidden = YES;
            [self getCommonSqlNameList];
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
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
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

/**
 *  webview加载数据
 */
- (void)webViewLoadDataWithDataStr:(NSString *)dataStr
{
    [self.sqlView.webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"showResult(%@);",dataStr]];
}

#pragma mark - LQDataMaintenanceLoginSQLViewDelegate
/**
 *  验证安全密码
 */
- (void)dataMaintenanceLoginSQLViewDidLogin:(LQDataMaintenanceLoginSQLView *)dataMaintenanceLoginSQLView
{
    [self.view endEditing:YES];
    
    if ([self.loginView.passwordTF.text isEqualToString:@""]) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"进入失败"
                                                        message:@"请输入安全密码"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        [alter show];
        return;
    }
    
    [self loginRequest];
}

/**
 *  忘记密码
 */
- (void)dataMaintenanceLoginSQLViewDidForgetPassword:(LQDataMaintenanceLoginSQLView *)dataMaintenanceLoginSQLView
{
    [self.view endEditing:YES];
    
    PwdSettingViewController *modifyPW = [[PwdSettingViewController alloc] init];
    modifyPW.urlStr = @"/adminmanager/do/db/changepassword.do";
    modifyPW.navTitle = @"修改安全密码";
    [self.navigationController pushViewController:modifyPW animated:YES];
}

#pragma mark - LQDataMaintenanceSQLViewDelegate
- (void)dataMaintenanceSQLViewGetCommonSqlTextWithIndexPath:(NSIndexPath *)indexPath sqlView:(LQDataMaintenanceSQLView *)sqlView
{
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载命令内容…";
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/db/getcommonsqltext.do;sessionid=%@",IP,port,sid];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"SqlName":self.sqlView.dataArray[indexPath.row]};
    
    [manager POST:urlStr parameters:parameter timeoutInterval:20 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        LQDataBackupJson *data = [LQDataBackupJson objectWithKeyValues:operation.responseString];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([data.state.returnn isEqualToString:@"true"]) {
            
            self.sqlView.textView.text = data.data.sqltext;
            
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
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
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

#pragma mark - LQExecutiveSQLHeaderViewDelegate
- (void)executiveSQLHeaderViewDidExecutive:(LQExecutiveSQLHeaderView *)executiveSQLHeaderView
{
    self.sqlView.pulldownTableView.hidden = YES;
    [self.view endEditing:YES];
    
    if ([self.sqlView.textView.text isEqualToString:@""]) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入SQL语句"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        [alter show];
        return;
    }
    
    [self executiveSQL];
}

- (void)executiveSQLHeaderViewDidPullDown:(LQExecutiveSQLHeaderView *)executiveSQLHeaderView
{
    self.sqlView.pulldownTableView.hidden = !self.sqlView.pulldownTableView.hidden;
    [self.view endEditing:YES];
}

- (void)executiveSQLHeaderViewDidLock:(LQExecutiveSQLHeaderView *)executiveSQLHeaderView
{
    [self.view endEditing:YES];
    [self logout];
}

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

@end
