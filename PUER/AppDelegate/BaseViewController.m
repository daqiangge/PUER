//
//  BaseViewController.m
//  PUER
//
//  Created by admin on 14-8-13.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

#define NAVTITLEFRAME (CGRectMake(0, 0, 100, 44))

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:39/255.0 green:169/255.0 blue:227/255.0 alpha:1]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showMeun" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideMeun" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMeun) name:@"showMeun" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMeun) name:@"hideMeun" object:nil];
    
    //重新登陆提示框
    _loginAgain_AlterView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                       message:@"未发现当前会话,可能会话超时或已经清除."
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"重新登录", nil];
    
    //请求发生错位的提示框
    _requestError_AlterView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"当前无法连接到服务器，请稍后重试"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles: nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//菜单按钮
- (void)menuButton:(NSString *)navigationTitle
{
    
    //自定义navigationbar的背景view
    UIView *view          = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 44)];
    view.backgroundColor  = [UIColor clearColor];
    
    //菜单按钮
    _menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [self.menuButton setBackgroundImage:[UIImage imageNamed:@"home"] forState:UIControlStateNormal];
    [self.menuButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.menuButton];
    
    //标题lable
    UILabel *titleLable        = [[UILabel alloc] init];
    titleLable.frame           = CGRectMake((view.frame.size.width-200)/2, 0, 200, view.frame.size.height);
    titleLable.textAlignment   = NSTextAlignmentCenter;
    titleLable.textColor       = [UIColor whiteColor];
    titleLable.font            = [UIFont fontWithName:TextFont_name_Bold size:18];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.text            = navigationTitle;
    [view addSubview:titleLable];
    
    self.navigationItem.titleView =view;
}

//返回按钮
- (void)setNavTitle:(NSString *)navigationTitle
{
    //标题lable
    _titleLable                 = [[UILabel alloc] init];
    _titleLable.frame           = CGRectMake(0, 0, 100, 44);
    _titleLable.textAlignment   = NSTextAlignmentCenter;
    _titleLable.textColor       = [UIColor whiteColor];
    _titleLable.font            = [UIFont fontWithName:TextFont_name_Bold size:18];
    _titleLable.backgroundColor = [UIColor clearColor];
    _titleLable.text            = navigationTitle;
    
    self.navigationItem.titleView =_titleLable;
    
}

- (void)setDataBackVCTitile:(NSString *)mainTitle viceTitle:(NSString *)viceTitle
{
    //标题lable
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, 200, 44);
    self.navigationItem.titleView = view;
    
    UILabel *mainTitleLable        = [[UILabel alloc] init];
    mainTitleLable.frame           = CGRectMake(0, 0, CGRectGetWidth(view.frame), 25);
    mainTitleLable.textAlignment   = NSTextAlignmentCenter;
    mainTitleLable.textColor       = [UIColor whiteColor];
    mainTitleLable.font            = [UIFont fontWithName:TextFont_name_Bold size:17];
    mainTitleLable.backgroundColor = [UIColor clearColor];
    mainTitleLable.text            = mainTitle;
    [view addSubview:mainTitleLable];
    
    UILabel *viceTitleLable        = [[UILabel alloc] init];
    viceTitleLable.frame           = CGRectMake(0, CGRectGetMaxY(mainTitleLable.frame), CGRectGetWidth(view.frame), CGRectGetHeight(view.frame)-CGRectGetHeight(mainTitleLable.frame));
    viceTitleLable.textAlignment   = NSTextAlignmentCenter;
    viceTitleLable.textColor       = [UIColor whiteColor];
    viceTitleLable.font            = [UIFont fontWithName:TextFont_name_Bold size:12];
    viceTitleLable.backgroundColor = [UIColor clearColor];
    viceTitleLable.text            = viceTitle;
    [view addSubview:viceTitleLable];
}

//返回操作
- (void)doBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

//每个界面的title设置
- (void)navTitle
{
//    _navigationTitle             = [[UILabel alloc] initWithFrame:NAVTITLEFRAME];
//    self.navigationTitle.font                 = [UIFont systemFontOfSize:16];
//    self.navigationTitle.textAlignment        = NSTextAlignmentCenter;
//    self.navigationTitle.textColor            = [UIColor whiteColor];
//    self.navigationTitle.backgroundColor      = [UIColor clearColor];
//    self.navigationItem.titleView = self.navigationTitle;
}

//网络状况测试
-(BOOL)isConnectionAvailable
{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.qq.com"];
    switch ([reach currentReachabilityStatus])
    {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    return isExistenceNetwork;
}

- (void)showMeun
{
    [UIView animateWithDuration:0.35f animations:^
    {
        self.menuButton.alpha = 0;
    }];
}

- (void)hideMeun
{
    [UIView animateWithDuration:0.35f animations:^
    {
        self.menuButton.alpha = 1;
    }];
}

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == _loginAgain_AlterView)
    {
        if (buttonIndex == 1)
        {
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }
}

#pragma mark - 字符串转码
- (NSString *)ASCIIString:(NSString *)unicodeStr
{
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"%u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2]stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUnicodeStringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
}

- (void)sessionToRemove:(NSString *)code info:(NSString *)info
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:info
                                                   delegate:self
                                          cancelButtonTitle:@"重试"
                                          otherButtonTitles:@"重新登录", nil];
    [alter show];
}

@end
