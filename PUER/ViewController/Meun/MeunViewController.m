//
//  MeunViewController.m
//  PUER
//
//  Created by admin on 14-8-14.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "MeunViewController.h"
#import "MainViewController.h"
#import "DataLinkViewController.h"
#import "NetworkViewController.h"
#import "SessionManagerViewController.h"
#import "DataBackupViewController.h"
#import "LogQueryViewController.h"
#import "SettingViewController.h"
#import "PwdSettingViewController.h"
#import "ContactSettingViewController.h"
#import "PlanFragmentViewController.h"
#import "CustomStatueBar.h"
#import "FilterViewController.h"
#import "LQCommunicationTestVC.h"

#define HeadPortraitIV_Proportion (SCREEN_HEIGHT==736?1.295:(SCREEN_HEIGHT==667?1.174:(SCREEN_HEIGHT==568?1:0.5)))//logo在不同屏幕下的比例
#define Cell_height 40*Proportion_height //菜单tableview每行的高
#define Cell_ImageView_width 21*Proportion_width //菜单tableview上每行的图标

@interface MeunViewController ()

@end

@implementation MeunViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isLogOut) name:@"LogOut" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lockError) name:@"Notification_lockError" object:nil];
    
    _clientTag = arc4random()%9999999999999999 + arc4random()%9999999999999999 + arc4random()%9999999999999999;
    //    NSLog(@"%d",_clientTag);
    
    statueBar = [[CustomStatueBar alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    [statueBar.msgButton addTarget:self action:@selector(showMsg) forControlEvents:UIControlEventTouchUpInside];
    [statueBar showStatusMessage:@"message new!"];
    _msgDic   = [[NSMutableDictionary alloc] init];
    [self getMsg];
    
    _msgAlterShow = NO;
    
    _logOut       = NO;
    
    _heartbeatPacketsNum = 0;
    
    [self doLoading];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (self.view.window == nil)
    {
        self.view = nil;
    }
}

- (void)doLoading
{
    NSUserDefaults *ud              = [NSUserDefaults standardUserDefaults];
    NSString *username              = [ud objectForKey:@"acceptUserId"];
    NSString *ipAndPort             = [NSString stringWithFormat:@"%@:%@",[ud objectForKey:@"IP"],[ud objectForKey:@"port"]];
    
    //用户头像
    UIImageView *headPortraitIV     = [[UIImageView alloc] init];
    headPortraitIV.image            = [UIImage imageNamed:@"logo"];
    headPortraitIV.frame            = CGRectMake(20, 50*HeadPortraitIV_Proportion, 50*Proportion_height, 50*Proportion_height);
    [self.view addSubview:headPortraitIV];
    
    //用户昵称
    UILabel *usernameLable          = [[UILabel alloc] init];
    usernameLable.frame             = CGRectMake(headPortraitIV.frame.origin.x+headPortraitIV.frame.size.width+10, headPortraitIV.frame.origin.y+5*Proportion_height, 150, 15*Proportion_text);
    usernameLable.textAlignment     = NSTextAlignmentLeft;
    usernameLable.backgroundColor   = [UIColor clearColor];
    usernameLable.text              = username;
    usernameLable.font              = [UIFont fontWithName:TextFont_name_Bold size:15*Proportion_text];
    [self.view addSubview:usernameLable];
    
    //IP和端口号的显示
    UILabel *ipAndPortLable         = [[UILabel alloc] init];
    ipAndPortLable.frame             = CGRectMake(usernameLable.frame.origin.x, usernameLable.frame.origin.y+usernameLable.frame.size.height+5, usernameLable.frame.size.width*Proportion_width, usernameLable.frame.size.height);
    ipAndPortLable.textAlignment     = usernameLable.textAlignment;
    ipAndPortLable.backgroundColor   = usernameLable.backgroundColor;
    ipAndPortLable.text              = ipAndPort;
    ipAndPortLable.font              = [UIFont fontWithName:TextFont_name size:13*Proportion_text];
    [self.view addSubview:ipAndPortLable];
    
    //    //华丽的分割线
    //    UIView *lineViewTwo             = [[UIView alloc] init];
    //    lineViewTwo.frame               = CGRectMake(15, headPortraitIV.frame.origin.y+headPortraitIV.frame.size.height+20*Proportion_height, 210*Proportion_width, 0.5);
    //    lineViewTwo.backgroundColor     = [UIColor colorWithRed:31/255.0 green:38/255.0 blue:46/255.0 alpha:1];
    //    lineViewTwo.alpha               = 0.5;
    //    [self.view addSubview:lineViewTwo];
    
    //菜单列表
    UITableView *meunTableView      = [[UITableView alloc] init];
    meunTableView.frame             = CGRectMake(0, headPortraitIV.frame.origin.y+headPortraitIV.frame.size.height+22*Proportion_height, SCREEN_WIDTH, Cell_height*9);
    meunTableView.delegate          = self;
    meunTableView.dataSource        = self;
    meunTableView.scrollEnabled     = YES;
    meunTableView.backgroundColor   = [UIColor clearColor];
    [meunTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:meunTableView];
    
    
    UIButton *settingButton = [[UIButton alloc] init];
    settingButton.frame  = CGRectMake(20, SCREEN_HEIGHT-45*Proportion_height, 60, 20);
    settingButton.titleLabel.font   = [UIFont fontWithName:TextFont_name size:14];
    [settingButton setTitle:@"设置" forState:UIControlStateNormal];
    [settingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [settingButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [settingButton setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    settingButton.imageEdgeInsets          = UIEdgeInsetsMake(2,2,2,42);
    settingButton.titleEdgeInsets          = UIEdgeInsetsMake(1,-30,0,0);
    [settingButton addTarget:self action:@selector(gotoSettingView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingButton];
    
    //设置按钮和重启按钮之间的分割线
    UIView *lineViewThree           = [[UIView alloc] init];
    lineViewThree.frame             = CGRectMake(settingButton.frame.origin.x+settingButton.frame.size.width+5, settingButton.frame.origin.y+2, 1, settingButton.frame.size.height-4);
    lineViewThree.backgroundColor   = [UIColor whiteColor];
    [self.view addSubview:lineViewThree];
    
    UIButton *restartButton = [[UIButton alloc] init];
    restartButton.frame  = CGRectMake(lineViewThree.frame.origin.x+lineViewThree.frame.size.width+10, settingButton.frame.origin.y, settingButton.frame.size.width, settingButton.frame.size.height);
    restartButton.titleLabel.font   = settingButton.titleLabel.font;
    [restartButton setTitle:@"重启" forState:UIControlStateNormal];
    [restartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [restartButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [restartButton setImage:[UIImage imageNamed:@"restart"] forState:UIControlStateNormal];
    restartButton.imageEdgeInsets          = settingButton.imageEdgeInsets;
    restartButton.titleEdgeInsets          = settingButton.titleEdgeInsets;
    [restartButton addTarget:self action:@selector(doRestart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:restartButton];
    
}

/**
 *  手势发生错误
 */
- (void)lockError
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    NSArray *array = @[@"平台监控",@"数据连接",@"网络代理",@"动作过滤",@"会话管理",@"通信测试",@"计划作业",@"数据维护",@"日志查询"];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:70/255.0 green:80/255.0 blue:90/255.0 alpha:1];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame        = CGRectMake(20, (Cell_height-Cell_ImageView_width)/2, Cell_ImageView_width, Cell_ImageView_width);
    imageView.image        = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    
    UILabel *lable         = [[UILabel alloc] init];
    lable.frame            = CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+10,0, 100*Proportion_width, Cell_height);
    lable.backgroundColor  = [UIColor clearColor];
    lable.text             = array[indexPath.row];
    lable.textAlignment    = NSTextAlignmentLeft;
    lable.textColor        = [UIColor whiteColor];
    lable.font             = [UIFont fontWithName:TextFont_name size:15*Proportion_text];
    
    [cell addSubview:imageView];
    [cell addSubview:lable];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Cell_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *ud  = [NSUserDefaults standardUserDefaults];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row)
    {
        case 0:
        {
            if ([[ud objectForKey:@"ContentViewController"] isEqualToString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
            {
                [self.sideMenuViewController hideMenuViewController];
            }
            else
            {
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AAAA" object:nil];
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[MainViewController alloc] init]]
                                                             animated:YES];
                [ud setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"ContentViewController"];
                [ud synchronize];
                [self.sideMenuViewController hideMenuViewController];
            }
        }
            
            break;
            
        case 1:
        {
            if ([[ud objectForKey:@"ContentViewController"] isEqualToString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
            {
                [self.sideMenuViewController hideMenuViewController];
            }
            else
            {
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[DataLinkViewController alloc] init]]
                                                             animated:YES];
                [ud setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"ContentViewController"];
                [ud synchronize];
                [self.sideMenuViewController hideMenuViewController];
            }
        }
            break;
            
        case 2:
        {
            if ([[ud objectForKey:@"ContentViewController"] isEqualToString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
            {
                [self.sideMenuViewController hideMenuViewController];
            }
            else
            {
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[NetworkViewController alloc] init]]
                                                             animated:YES];
                [ud setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"ContentViewController"];
                [ud synchronize];
                [self.sideMenuViewController hideMenuViewController];
            }
        }
            break;
            
        case 3:
        {
            if ([[ud objectForKey:@"ContentViewController"] isEqualToString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
            {
                [self.sideMenuViewController hideMenuViewController];
            }
            else
            {
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[FilterViewController alloc] init]]
                                                             animated:YES];
                [ud setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"ContentViewController"];
                [ud synchronize];
                [self.sideMenuViewController hideMenuViewController];
            }
        }
            break;
            
        case 4:
        {
            if ([[ud objectForKey:@"ContentViewController"] isEqualToString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
            {
                [self.sideMenuViewController hideMenuViewController];
            }
            else
            {
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[SessionManagerViewController alloc] init]]
                                                             animated:YES];
                [ud setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"ContentViewController"];
                [ud synchronize];
                [self.sideMenuViewController hideMenuViewController];
            }
        }
            break;
            
        case 5:
        {
            if ([[ud objectForKey:@"ContentViewController"] isEqualToString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
            {
                [self.sideMenuViewController hideMenuViewController];
            }
            else
            {
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[LQCommunicationTestVC alloc] init]]
                                                             animated:YES];
                [ud setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"ContentViewController"];
                [ud synchronize];
                [self.sideMenuViewController hideMenuViewController];
            }
        }
            break;
            
        case 6:
        {
            if ([[ud objectForKey:@"ContentViewController"] isEqualToString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
            {
                [self.sideMenuViewController hideMenuViewController];
            }
            else
            {
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[PlanFragmentViewController alloc] init]]
                                                             animated:YES];
                [ud setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"ContentViewController"];
                [ud synchronize];
                [self.sideMenuViewController hideMenuViewController];
            }
        }
            break;
            
        case 7:
        {
            if ([[ud objectForKey:@"ContentViewController"] isEqualToString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
            {
                [self.sideMenuViewController hideMenuViewController];
            }
            else
            {
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[DataBackupViewController alloc] init]]
                                                             animated:YES];
                [ud setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"ContentViewController"];
                [ud synchronize];
                [self.sideMenuViewController hideMenuViewController];
            }
        }
            break;
            
        case 8:
        {
            if ([[ud objectForKey:@"ContentViewController"] isEqualToString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
            {
                [self.sideMenuViewController hideMenuViewController];
            }
            else
            {
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[LogQueryViewController alloc] init]]
                                                             animated:YES];
                [ud setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"ContentViewController"];
                [ud synchronize];
                [self.sideMenuViewController hideMenuViewController];
            }
        }
            break;
            
        default:
            break;
    }
}

/** 前往设置界面 */
- (void)gotoSettingView
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ContentViewController"] isEqualToString:[NSString stringWithFormat:@"%d",9]])
    {
        [self.sideMenuViewController hideMenuViewController];
    }
    else
    {
        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[SettingViewController alloc] init]]
                                                     animated:YES];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",9] forKey:@"ContentViewController"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.sideMenuViewController hideMenuViewController];
    }
}

#pragma mark - actionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self getPlatformFirstdatetime:@"service"];
    }
    else if (buttonIndex == 1)
    {
        [self getPlatformFirstdatetime:@"application"];
    }
}

#pragma mark - 重启按钮及操作
/** 重启操作 */
- (void)doRestart
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"重启平台",@"重启应用", nil];
    [actionSheet showInView:self.view];
}

/** 获取平台启动时间 */
- (void)getPlatformFirstdatetime:(NSString *)string
{
    //发送保存请求
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    NSString *urlString;
    
    //此处两个选项已相反，做的是相反的操作
    if ([string isEqualToString:@"application"])
    {
        //等待指示器
        _restartTheApplicationHUD = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        _restartTheApplicationHUD.mode = MBProgressHUDModeIndeterminate;
        _restartTheApplicationHUD.labelText = @"正在重启应用...";
        
        urlString = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/system/closeandopen.do;sessionid=%@",IP,port,sid];
        
    }
    else if ([string isEqualToString:@"service"])
    {
        //等待指示器
        _restartTheServiceHUD = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        _restartTheServiceHUD.mode = MBProgressHUDModeIndeterminate;
        _restartTheServiceHUD.labelText = @"正在重启服务...";
        
        urlString = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/system/reset.do;sessionid=%@",IP,port,sid];
    }
    
    //判断当前是否有网络
    if (![GetNetworkStates getNetWorkStates])
    {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/public/dosystem/getfirstruntime.do",IP,port]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TimeoutInterval];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
         
         _platformFirstdatetime   = resultStr;
         
         [self restart:urlString];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"网络连接超时"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles: nil];
         [alert show];
     }];
    
    [operation start];
}

- (void)restart:(NSString *)urlString
{
    _heartbeatPacketsNum = 0;
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TimeoutInterval];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
         NSDictionary *resultDic  = [resultStr JSONValue];
         
         if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"])
         {
             [self heartbeatPackets];
         }
         else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"])
         {
             [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
             
             if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"])
             {
                 UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:[[resultDic objectForKey:@"state"] objectForKey:@"info"]
                                                                delegate:self
                                                       cancelButtonTitle:@"重试"
                                                       otherButtonTitles:@"重新登录", nil];
                 [alter show];
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:[[resultDic objectForKey:@"state"] objectForKey:@"info"]
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles: nil];
                 [alert show];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"网络异常,请检查你的网络"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles: nil];
         [alert show];
     }];
    
    [operation start];
}

/** 心跳检测，检查是否重启完成 */
- (void)heartbeatPackets
{
    _heartbeatPacketsNum += 1;
    
    //    NSLog(@"-----%d",_heartbeatPacketsNum);
    
    if (_heartbeatPacketsNum == 20)
    {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败"
                                                        message:@"重启服务失败"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        [alert show];
        _heartbeatPacketsNum = 0;
        return;
    }
    
    //发送保存请求
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    
    NSURL *url         = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/public/dosystem/getfirstruntime.do",IP,port]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:5];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
         
         if ([_platformFirstdatetime isEqualToString:resultStr])
         {
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                            {
                                [self heartbeatPackets];
                            });
         }
         else
         {
             _restartTheApplicationHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
             _restartTheApplicationHUD.mode = MBProgressHUDModeCustomView;
             _restartTheApplicationHUD.labelText = @"重启成功";
             
             _restartTheServiceHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
             _restartTheServiceHUD.mode = MBProgressHUDModeCustomView;
             _restartTheServiceHUD.labelText = @"重启成功";
             
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                            {
                                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                                
                                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[MainViewController alloc] init]]
                                                                             animated:YES];
                                [ud setObject:@"0" forKey:@"ContentViewController"];
                                [ud synchronize];
                                [self.sideMenuViewController hideMenuViewController];
                            });
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //        NSLog(@"-----%ld",error.code);
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self heartbeatPackets];
         });
     }];
    
    [operation start];
}

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 150)
    {
        _msgAlterShow = NO;
        [self getMsg];
        return;
    }
    
    if (buttonIndex == 1)
    {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - 接受广播
- (void)getMsg
{
    
    //发送保存请求
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    NSURL *url         = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/adminmanager/do/msg/getmsg.do?ClientTag=%d;sessionid=%@",IP,port,_clientTag,sid]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:60];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        resultStr                = [resultStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        resultStr                = [resultStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"])
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"msgid"] forKey:@"msgid"];
            [dic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"sender"] forKey:@"sender"];
            [dic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"msgtxt"] forKey:@"msgtxt"];
            [dic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"sendtime"] forKey:@"sendtime"];
            _msgDic = dic;
            
            //当已经退出时，不在显示消息的提示，防止刚退出，此时连接未断而获取来的数据
            if (!_logOut)
            {
                [statueBar.msgButton setTitle:[dic objectForKey:@"msgtxt"] forState:UIControlStateNormal];
                [statueBar showStatusBar];
            }
            
            //停止5s后执行刷新列表，并停止刷新的动画
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                           {
                               if (!_logOut)
                               {
                                   //如果为NO，说明没有点击消息进行详细查看，如果为YES，说明进行了查看消息，此时，停止下一轮的请求的发送
                                   if (!_msgAlterShow)
                                   {
                                       [statueBar closeStatusBar];//关闭消息的提示，并再次请求
                                       
                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                                                      {
                                                          [self getMsg];
                                                      });
                                   }
                               }
                           });
        }
        else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"])
        {
            [self getMsg];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //        NSLog(@"%@",error);
         if (!_logOut)
         {
             //如果错误为-1001说明为超时，此时立即发送下一轮请求，如果不是在停滞30s在发送请求
             if (error.code == -1001)
             {
                 [self getMsg];
             }
             else
             {
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                                {
                                    [self getMsg];
                                });
             }
         }
     }];
    
    [operation start];
}

/** 展示接受的后台消息 */
- (void)showMsg
{
    _msgAlterShow = YES;
    [statueBar closeStatusBar];//关闭消息的提示，并再次请求
    
    //展示详细的消息，在未关闭提示框时，不在重新发送获取消息的请求，只有当关闭了提示框才从新发送
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"来自于%@的消息",
                                                                 [_msgDic objectForKey:@"sender"]]
                                                        message:[_msgDic objectForKey:@"msgtxt"]
                                                       delegate:self cancelButtonTitle:@"关闭"
                                              otherButtonTitles: nil];
    alterView.tag = 150;
    [alterView show];
}

/** 监听退出登陆操作 */
- (void)isLogOut
{
    //退出登陆，并关闭还未消失的消失提示
    _logOut = YES;
    [statueBar closeStatusBar];
}

@end
