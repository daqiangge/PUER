//
//  LQDataMaintenanceDetailsVC.m
//  PUER
//
//  Created by admin on 15/6/3.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "LQDataMaintenanceDetailsVC.h"
#import "LQDataBackupJson.h"

@interface LQDataMaintenanceDetailsVC ()<UIAlertViewDelegate>

@property (nonatomic, weak) UITextView *textView;

@end

@implementation LQDataMaintenanceDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [super setNavTitle:self.navTitle];
    [self loading];
    [self request];
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
}

- (void)setNavTitle:(NSString *)navTitle
{
    _navTitle = navTitle;
}

- (void)setInfoName:(NSString *)infoName
{
    _infoName = infoName;
}

- (void)setConnName:(NSString *)ConnName
{
    _ConnName = ConnName;
}

- (void)setMainUrlStr:(NSString *)mainUrlStr
{
    _mainUrlStr = mainUrlStr;
}

- (void)setInfoParameterName:(NSString *)infoParameterName
{
    _infoParameterName = infoParameterName;
}

- (void)loading
{
    UITextView *textView = [[UITextView alloc] init];
    textView.frame = CGRectMake(10, NavgationBarAndStareBar_height+10, SCREEN_WIDTH-20, SCREEN_HEIGHT-NavgationBarAndStareBar_height-90);
    textView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    textView.layer.borderColor = layer_borderColor;
    textView.layer.borderWidth = layer_borderWidth;
    textView.layer.cornerRadius = layer_cornerRadius;
    textView.editable = NO;
    textView.textAlignment = NSTextAlignmentLeft;
    textView.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:textView];
    self.textView = textView;
    
    UIButton *copyButton = [[UIButton alloc] init];
    copyButton.frame = CGRectMake(CGRectGetMinX(textView.frame), CGRectGetMaxY(textView.frame)+20, CGRectGetWidth(textView.frame), 40);
    copyButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [copyButton setTitle:@"复制" forState:UIControlStateNormal];
    [copyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [copyButton setBackgroundImage:[UIImage imageNamed:@"buttonbg3"] forState:UIControlStateNormal];
    [copyButton addTarget:self action:@selector(copyText) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:copyButton];
}

- (void)copyText
{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.textView.text;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"复制成功";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    });
}

- (void)request
{
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载…";
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/db/%@.do;sessionid=%@",IP,port,self.mainUrlStr,sid];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"ConnName": self.ConnName,self.infoParameterName:self.infoName};
    
    [manager POST:urlStr parameters:parameter timeoutInterval:20 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        LQDataBackupJson *data = [LQDataBackupJson objectWithKeyValues:operation.responseString];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([data.state.returnn isEqualToString:@"true"]) {
            
            self.textView.text = data.data.sqltext;
            
        }else {
            if (!self.judgeBack) {
                if ([data.state.code isEqualToString:@"1006"]) {
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:data.state.info
                                                                   delegate:self
                                                          cancelButtonTitle:@"重试"
                                                          otherButtonTitles:@"重新登录", nil];
                    alter.tag = 1000;
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

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

@end
