//
//  LockSettingVC.m
//  PUER
//
//  Created by admin on 15/3/13.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "LockSettingVC.h"
#import "LLLockViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

static BOOL fingerprint = NO;

@interface LockSettingVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation LockSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super setNavTitle:@"手势、指纹设置"];
    
    UIButton *backbtn = [[UIButton alloc] init];
    backbtn.frame = CGRectMake(0, 0, 70, 44);
//    [backbtn setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backbtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backbtn setTitle:@"返回" forState:UIControlStateNormal];
    [backbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(popMainVC) forControlEvents:UIControlEventTouchUpInside];
    backbtn.titleLabel.font = [UIFont systemFontOfSize:17];
    backbtn.imageEdgeInsets = UIEdgeInsetsMake(7, -5, 7, 59);
    backbtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);;
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = backBtn;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    
    [self judgeFingerprint];
    [self initView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)popMainVC
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  判断是否可以指纹解锁
 */
- (void)judgeFingerprint
{
    LAContext *context = [LAContext new];
    NSError *error;
    
    //判断是否能使用指纹解锁
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        fingerprint = YES;
    }
    else
    {
        fingerprint = NO;
    }
}

#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    BOOL lockSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"lockSwitch"];
    
    if (lockSwitch && fingerprint)
    {
        return 3;
    }
    else if (lockSwitch && !fingerprint)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if (indexPath.section == 0)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"开启密码锁定";
        
        UISwitch *mySwitch = [[UISwitch alloc] init];
        
        BOOL lockSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"lockSwitch"];
        mySwitch.on = lockSwitch;
        
        [mySwitch addTarget:self action:@selector(lockSwitch:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = mySwitch;
    }
    else if (indexPath.section == 1)
    {
        if (fingerprint) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textLabel.text = @"开启Touch ID指纹解锁";
            
            UISwitch *mySwitch = [[UISwitch alloc] init];
            
            BOOL fingerprintSwitch = [[[NSUserDefaults standardUserDefaults] valueForKey:@"fingerprintSwitch"] boolValue];
            mySwitch.on = fingerprintSwitch;
            
            [mySwitch addTarget:self action:@selector(fingerprintSwitch:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = mySwitch;
        }else {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            cell.textLabel.text = @"重置手势密码";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else if (indexPath.section == 2)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        cell.textLabel.text = @"重置手势密码";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL lockSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"lockSwitch"];
    if (lockSwitch) {
        if (fingerprint) {
            if (indexPath.section == 2) {
                LLLockViewController *lockVc = [[LLLockViewController alloc] init];
                lockVc.nLockViewType = LLLockViewTypeModify;
                lockVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                lockVc.title = @"手势密码";
                [self.navigationController pushViewController:lockVc animated:YES];
            }
        }else {
            if (indexPath.section == 1) {
                LLLockViewController *lockVc = [[LLLockViewController alloc] init];
                lockVc.nLockViewType = LLLockViewTypeModify;
                lockVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                lockVc.title = @"手势密码";
                [self.navigationController pushViewController:lockVc animated:YES];
            }
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)lockSwitch:(UISwitch *)mySwitch
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:mySwitch.on] forKey:@"lockSwitch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView reloadData];
}

- (void)fingerprintSwitch:(UISwitch *)mySwitch
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:mySwitch.on] forKey:@"fingerprintSwitch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
