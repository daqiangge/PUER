//
//  ContactSettingViewController.m
//  PUER
//
//  Created by admin on 14-8-14.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "ContactSettingViewController.h"

@interface ContactSettingViewController ()

@end

@implementation ContactSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //防止键盘遮挡住输入框
    _keyBoardController=[[UIKeyboardViewController alloc] initWithControllerDelegate:self];
    
    _judgeBack                 = NO;
    
    [super setNavTitle:@"修改联系方式"];
    [self doLoading];
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

#pragma mark - 加载视图控件
- (void)doLoading
{
    UILabel *emailLable                = [[UILabel alloc] init];
    UILabel *smsLable                  = [[UILabel alloc] init];
    _emailTextField                    = [[LQTextField alloc] init];
    _smsTextField                      = [[LQTextField alloc] init];
    
    emailLable.frame                  = CGRectMake(10, 20+64, 200, 20);
    self.emailTextField.frame          = CGRectMake(emailLable.frame.origin.x, emailLable.frame.origin.y+emailLable.frame.size.height+5, SCREEN_WIDTH-20, TextField_height);
    smsLable.frame                     = CGRectMake(emailLable.frame.origin.x, self.emailTextField.frame.origin.y+self.emailTextField.frame.size.height+20, emailLable.frame.size.width, emailLable.frame.size.height);
    self.smsTextField.frame            = CGRectMake(emailLable.frame.origin.x, smsLable.frame.origin.y+smsLable.frame.size.height+5, self.emailTextField.frame.size.width, TextField_height);
    
    self.emailTextField.backgroundColor        = TextField_backgroundCollor;
    self.smsTextField.backgroundColor          = TextField_backgroundCollor;
    
    //画框
    self.emailTextField.layer.cornerRadius        = TextField_layer_cornerRadius;
    self.emailTextField.layer.borderWidth         = TextField_layer_borderWidth;
    self.emailTextField.layer.borderColor         = TextField_layer_borderColor;
    self.smsTextField.layer.cornerRadius          = TextField_layer_cornerRadius;
    self.smsTextField.layer.borderWidth           = TextField_layer_borderWidth;
    self.smsTextField.layer.borderColor           = TextField_layer_borderColor;
    
    //设置邮箱和联系方式的lable
    emailLable.text                       = @"管理员邮箱：";
    smsLable.text                         = @"联系电话：";
    
    //向左对其
    emailLable.textAlignment              = NSTextAlignmentLeft;
    smsLable.textAlignment                = NSTextAlignmentLeft;
    
    //字体大小
    emailLable.font                       = [UIFont fontWithName:TextFont_name size:15];
    smsLable.font                         = [UIFont fontWithName:TextFont_name size:15];
    
    //textfield的回调方法
    self.emailTextField.delegate          = self;
    self.smsTextField.delegate            = self;
    
    //向左对其
    self.emailTextField.textAlignment     = NSTextAlignmentLeft;
    self.smsTextField.textAlignment       = NSTextAlignmentLeft;
    
    //输入框的键盘样式
    self.emailTextField.keyboardType      = UIKeyboardTypeASCIICapable;
    self.smsTextField.keyboardType        = UIKeyboardTypeASCIICapable;
    
    [self.view addSubview:emailLable];
    [self.view addSubview:smsLable];
    [self.view addSubview:self.emailTextField];
    [self.view addSubview:self.smsTextField];
    
    //确定按钮
    UIButton *saveButton               = [[UIButton alloc] init];
    saveButton.frame                   = CGRectMake(emailLable.frame.origin.x, self.smsTextField.frame.origin.y+self.smsTextField.frame.size.height+35, self.smsTextField.frame.size.width, 40);
    saveButton.layer.cornerRadius      = 2;
    saveButton.layer.borderColor       = [UIColor clearColor].CGColor;
    saveButton.backgroundColor         = [UIColor colorWithRed:92/255.0 green:184/255.0 blue:92/255.0 alpha:1];
    [saveButton setTitle:@"确定" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveEmailandTel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
    //设置点击空白处释放键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(releaseKeyBoard)];
    tapGestureRecognizer.numberOfTapsRequired = 1; // * 点击空白处几下
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - 网络请求
- (void)doRequest
{
    [self releaseKeyBoard];
    
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载…";
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    NSURL *url         = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/adminmanager/do/getsysadmininfo.do;sessionid=%@",IP,port,sid]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TimeoutInterval];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            if ([self.emailTextField.text isEqualToString:@""] && [self.smsTextField.text isEqualToString:@""]) {
                self.emailTextField.text = [[resultDic objectForKey:@"data"] objectForKey:@"email"];
                self.smsTextField.text = [[resultDic objectForKey:@"data"] objectForKey:@"tel"];
            }
            
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        }else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"]) {
            
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window]animated:YES];
            
            if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"]) {
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:self cancelButtonTitle:@"重试" otherButtonTitles:@"重新登录", nil];
                [alter show];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"修改联系方式报错");
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        if (!self.judgeBack) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接超时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }];
    
    [operation start];
    
}

#pragma mark - 保存操作
- (void)saveEmailandTel
{
    if (![self.emailTextField.text isEqualToString:@""]) {
        if (![[Regex shareInstance] judgeEmail:self.emailTextField.text]) {
            return;
        }
    }
    
    if (![self.smsTextField.text isEqualToString:@""]) {
        if (![[Regex shareInstance] judgeTelNumAndLandlineNum:self.smsTextField.text]) {
            return;
        }
    }
    
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在修改...";
    
    //发送保存请求
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    NSURL *url         = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/adminmanager/do/setsysadmininfo.do?email=%@&tel=%@;sessionid=%@",IP,port,self.emailTextField.text,self.smsTextField.text,sid]];
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
            hud.labelText = @"修改成功";
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            });
        }else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"]) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window]animated:YES];
            
            if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"]) {
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:self cancelButtonTitle:@"重试" otherButtonTitles:@"重新登录", nil];
                [alter show];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"修改联系方式报错");
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        if (!self.judgeBack) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接超时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }];
    
    [operation start];
    
}

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - Textfield Delegate
//释放键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self releaseKeyBoard];
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
    
    if (self.emailTextField == textField)
    {
        if ([toBeString length] > 128) {
            //如果粘贴内容大于128，将只截取前128的字符
            textField.text = [toBeString substringToIndex:128];
            
            return NO;
            
        }
    }else if (self.smsTextField == textField)
    {
        for (int i = 0; i<[toBeString length]; i++) {
        //截取字符串中的每一个字符
        NSString *s = [toBeString substringWithRange:NSMakeRange(i, 1)];
        if (![[Regex shareInstance] judgeContactSettingViewTel:s]) {
            return NO;
        }
    }
        if ([toBeString length] > 20) {
            //如果粘贴内容大于11，将只截取前11的字符
            textField.text = [toBeString substringToIndex:20];
            
            return NO;
            
        }

    }
    
    //判读是是否有中文
    for (int i = 0; i<[toBeString length]; i++) {
        //截取字符串中的每一个字符
        NSString *s = [toBeString substringWithRange:NSMakeRange(i, 1)];
        if ([[Regex shareInstance] judgeChinese:s]) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - 点击空白释放键盘
- (void)releaseKeyBoard
{
    [self.emailTextField resignFirstResponder];
    [self.smsTextField resignFirstResponder];
}

#pragma mark - view即将移除时
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.judgeBack = YES;
}

@end
