//
//  SettingViewController.m
//  PUER
//
//  Created by admin on 14-8-14.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "SettingViewController.h"
#import "ContactSettingViewController.h"
#import "PwdSettingViewController.h"
#import "SystemSettingViewController.h"
#import "MailboxSettingViewController.h"
#import "FTPSettingViewController.h"
#import "VersionViewController.h"
#import "FirstCreateGestureLockVC.h"
#import "LockSettingVC.h"
#import "LQResourcesViewTBV.h"
#import "LQSQLSettingVC.h"


@interface SettingViewController ()

@property (nonatomic, weak) UITableView *settingTableView;

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [super menuButton:@"设置"];
    [self doLoading];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (self.view.window == nil) {
        self.view = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.settingTableView reloadData];
}

- (void)doLoading
{
    UITableView *settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    settingTableView.delegate     = self;
    settingTableView.dataSource   = self;
    [settingTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    settingTableView.delaysContentTouches = NO;
    [self.view addSubview:settingTableView];
    self.settingTableView = settingTableView;
    
    UIButton *logOutButton  = [[UIButton alloc] init];
    logOutButton.frame      = CGRectMake(10, 20*5+44*9, SCREEN_WIDTH-20, 40);
    logOutButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [logOutButton setBackgroundImage:[UIImage imageNamed:@"logoutbg"] forState:UIControlStateNormal];
    [logOutButton setTitle:@"退出系统" forState:UIControlStateNormal];
    [logOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logOutButton addTarget:self action:@selector(doLogOut) forControlEvents:UIControlEventTouchUpInside];
    [settingTableView addSubview:logOutButton];
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    else if (section == 1)
    {
        return 4;
    }
    else if (section == 2)
    {
        return 1;
    }
    else
    {
        return 2;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idenifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idenifier];
        
        //使该tableview上的按钮能有高亮状态
        for (id obj in cell.subviews)
        {
            if ([NSStringFromClass([obj class]) isEqualToString:@"UITableViewCellScrollView"])
            {
                UIScrollView *scroll = (UIScrollView *) obj;
                scroll.delaysContentTouches = NO;
                break;
            }
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//显示右侧的箭头
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if (indexPath.section == 0) {
        NSArray *array = @[@"联系方式",@"修改密码"];
        cell.textLabel.text = array[indexPath.row];
    }
    
    if (indexPath.section == 1) {
        NSArray *array = @[@"系统设置",@"邮箱设置",@"FTP设置",@"SQL执行设置"];
        cell.textLabel.text = array[indexPath.row];
    }
    
    if (indexPath.section == 2) {
        NSArray *array = @[@"资源查看"];
        cell.textLabel.text = array[indexPath.row];
    }
    
    if (indexPath.section == 3) {
        NSArray *array = @[@"手势、指纹锁定",@"关于PUER"];
        cell.textLabel.text = array[indexPath.row];
        
        //判断手势、指纹锁定的状态
        if (indexPath.row == 0)
        {
            BOOL lockSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"lockSwitch"];
            NSString *lock = [[NSUserDefaults standardUserDefaults] valueForKey:@"lock"];
            if (lock == nil)//未设置
            {
                cell.detailTextLabel.text = @"未设置";
                [cell.detailTextLabel setTextColor:[UIColor grayColor]];
            }
            else if (lockSwitch)//开启
            {
                cell.detailTextLabel.text = @"开启";
                [cell.detailTextLabel setTextColor:[UIColor colorWithRed:39/255.0 green:169/255.0 blue:227/255.0 alpha:1]];
            }
            else if (!lockSwitch)//关闭
            {
                cell.detailTextLabel.text = @"关闭";
                [cell.detailTextLabel setTextColor:[UIColor grayColor]];
            }
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 80;
    }
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                ContactSettingViewController *contactSettingView = [[ContactSettingViewController alloc] init];
                [self.navigationController pushViewController:contactSettingView animated:YES];
            }
                break;
                
            case 1:
            {
                PwdSettingViewController *pwSettingView = [[PwdSettingViewController alloc] init];
                pwSettingView.urlStr = @"/adminmanager/do/changepassword.do";
                pwSettingView.navTitle = @"修改密码";
                [self.navigationController pushViewController:pwSettingView animated:YES];
            }
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                SystemSettingViewController *systemSettingView = [[SystemSettingViewController alloc] init];
                [self.navigationController pushViewController:systemSettingView animated:YES];
            }
                break;
                
            case 1:
            {
                MailboxSettingViewController *mailboxSettingView = [[MailboxSettingViewController alloc] init];
                [self.navigationController pushViewController:mailboxSettingView animated:YES];
            }
                break;
                
            case 2:
            {
                FTPSettingViewController *FTPSettingView = [[FTPSettingViewController alloc] init];
                [self.navigationController pushViewController:FTPSettingView animated:YES];
            }
                break;
                
            case 3:
            {
                LQSQLSettingVC *sqlSettingVC = [[LQSQLSettingVC alloc] init];
                [self.navigationController pushViewController:sqlSettingVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 2) {
        LQResourcesViewTBV *resourcesTBV = [[LQResourcesViewTBV alloc] init];
        [self.navigationController pushViewController:resourcesTBV animated:YES];
    }else {
        switch (indexPath.row) {
            case 0:
            {
                NSString *lock = [[NSUserDefaults standardUserDefaults] valueForKey:@"lock"];
                if ([lock isEqualToString:@""] || lock == nil) {
                    FirstCreateGestureLockVC *firstCreatLockVC = [[FirstCreateGestureLockVC alloc] init];
                    [self.navigationController pushViewController:firstCreatLockVC animated:YES];
                }else {
                    LockSettingVC *lockSettingVC = [[LockSettingVC alloc] init];
                    [self.navigationController pushViewController:lockSettingVC animated:YES];
                }
            }
                break;
                
            case 1:
            {
                VersionViewController *versionView = [[VersionViewController alloc] init];
                [self.navigationController pushViewController:versionView animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - 退出登录操作
//退出系统。不管网络返回的是true还是false，都退出到登录界面
- (void)doLogOut
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LogOut" object:nil];
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:@"loginsuccess"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    //发送退出请求
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    NSString *urlStr   = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/logout.do;sessionid=%@",IP,port,sid];
    NSURL *url         = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TimeoutInterval];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [operation start];
}

@end
