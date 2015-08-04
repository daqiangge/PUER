//
//  FindPWViewController.m
//  PUER
//
//  Created by admin on 14-8-14.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "FindPWViewController.h"
#import "SetIPConfigViewController.h"

@interface FindPWViewController ()

@end

@implementation FindPWViewController

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
    
    //初始化一个ob，提供调用object中的方法
    _ob = [[object alloc] init];
    
    [super setNavTitle:@"找回密码"];
    [self doLoading];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 加载视图控件
- (void)doLoading
{
    UILabel *enterUnLable                 = [[UILabel alloc] init];
    UIView *accountbgView                 = [[UIView alloc] init];
    _accountTextField                     = [[UITextField alloc] init];
    UILabel *accessLable                  = [[UILabel alloc] init];
    _smsButton                            = [[UIButton alloc] init];
    _emailButton                          = [[UIButton alloc] init];
    _smsButton1                           = [[UIButton alloc] init];
    _emailButton1                         = [[UIButton alloc] init];
    UILabel *promptLable                  = [[UILabel alloc] init];
    UIButton *confirmButton               = [[UIButton alloc] init];
    
    [self enterUnLable:enterUnLable andAccountbgView:accountbgView andAccountTextField:self.accountTextField andAccessLable:accessLable];
    
    self.smsButton.frame   = CGRectMake(accountbgView.frame.origin.x, accessLable.frame.origin.y+accessLable.frame.size.height+10, 13, 13);
    self.emailButton.frame = CGRectMake(SCREEN_WIDTH/2+10, self.smsButton.frame.origin.y, self.smsButton.frame.size.width, self.smsButton.frame.size.height);
    [self smsButtonAndEmailButton];
    
    [self smsButton1:self.smsButton1 andEmailButton1:self.emailButton1];
    
    promptLable.frame         = CGRectMake(self.smsButton.frame.origin.x, self.emailButton.frame.origin.y+self.emailButton.frame.size.height+20, SCREEN_WIDTH-20, 95);
    [self prompt:promptLable];
    
    confirmButton.frame     = CGRectMake(enterUnLable.frame.origin.x, promptLable.frame.origin.y+promptLable.frame.size.height+25, accountbgView.frame.size.width, 40);
    [self confirmButton:confirmButton];
    
    //设置点击空白处释放键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textFieldShouldReturn:)];
    tapGestureRecognizer.numberOfTapsRequired = 1; // * 点击空白处几下
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - 个个控件的属性参数设置
- (void)enterUnLable:(UILabel *)enterUnLable andAccountbgView:(UIView *)accountbgView andAccountTextField:(UITextField *)accountTextField andAccessLable:(UILabel *)accessLable
{
    enterUnLable.text                     = @"1.请输入您的用户名";
    accessLable.text                      = @"2.请选择您获取密码的方式";
    
    enterUnLable.font                     = [UIFont fontWithName:TextFont_name size:15];
    accessLable.font                      = [UIFont fontWithName:TextFont_name size:15];
    
    enterUnLable.textAlignment            = NSTextAlignmentLeft;
    self.accountTextField.textAlignment   = NSTextAlignmentLeft;
    accessLable.textAlignment             = NSTextAlignmentLeft;
    
    self.accountTextField.delegate        = self;
    
    self.accountTextField.text            = @"Sysadmin";
    
    self.accountTextField.keyboardType     = UIKeyboardTypeASCIICapable;
    
    accountbgView.layer.cornerRadius      = layer_cornerRadius;
    accountbgView.layer.borderWidth       = layer_borderWidth;
    accountbgView.layer.borderColor       = layer_borderColor;
    
    accountbgView.backgroundColor         = TextField_backgroundCollor;
    self.accountTextField.backgroundColor = [UIColor clearColor];
    
    enterUnLable.frame          = CGRectMake(10, 25+64, 200, 20);
    
    accountbgView.frame         = CGRectMake(enterUnLable.frame.origin.x, enterUnLable.frame.origin.y+enterUnLable.frame.size.height+10, SCREEN_WIDTH-20, TextField_height);
    accessLable.frame           = CGRectMake(enterUnLable.frame.origin.x, accountbgView.frame.origin.y+accountbgView.frame.size.height+20, enterUnLable.frame.size.width, enterUnLable.frame.size.height);
    self.accountTextField.frame = CGRectMake(5, 0, accountbgView.frame.size.width-5, accountbgView.frame.size.height);
    
    [self.view     addSubview:enterUnLable];
    [self.view     addSubview:accountbgView];
    [self.view     addSubview:accessLable];
    [accountbgView addSubview:self.accountTextField];
}

- (void)smsButtonAndEmailButton
{
    [self.smsButton setBackgroundImage:[UIImage imageNamed:@"notselected"] forState:UIControlStateNormal];
    [self.emailButton setBackgroundImage:[UIImage imageNamed:@"notselected"] forState:UIControlStateNormal];
    
    [self.smsButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [self.emailButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    
    [self.smsButton addTarget:self action:@selector(doChoose:) forControlEvents:UIControlEventTouchUpInside];
    [self.emailButton addTarget:self action:@selector(doChoose:) forControlEvents:UIControlEventTouchUpInside];
    
    self.smsButton.tag        = 10;
    self.emailButton.tag      = 11;
    
    self.smsButton.selected   = YES;
    self.emailButton.selected = NO;
    
    [self.view addSubview:self.smsButton];
    [self.view addSubview:self.emailButton];
}

- (void)smsButton1:(UIButton *)smsButton1 andEmailButton1:(UIButton *)emailButton1
{
    [self.smsButton1 setTitle:@"通过手机短信" forState:UIControlStateNormal];
    [self.emailButton1 setTitle:@"通过电子邮件" forState:UIControlStateNormal];
    
    [self.smsButton1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.emailButton1 setTitleColor:[UIColor blackColor ] forState:UIControlStateNormal];
    
    self.smsButton1.titleLabel.font = [UIFont systemFontOfSize:15];
    self.emailButton1.titleLabel.font = [UIFont systemFontOfSize:15];
    
    self.smsButton1.tag        = 12;
    self.emailButton1.tag      = 13;
    
    [self.smsButton1 addTarget:self action:@selector(doChoose:) forControlEvents:UIControlEventTouchUpInside];
    [self.emailButton1 addTarget:self action:@selector(doChoose:) forControlEvents:UIControlEventTouchUpInside];
    
    self.smsButton1.frame            = CGRectMake(self.smsButton.frame.origin.x+self.smsButton.frame.size.width+3, self.smsButton.frame.origin.y-2, 100, 17);
    self.emailButton1.frame          = CGRectMake(self.emailButton.frame.origin.x+self.emailButton.frame.size.width+3, self.smsButton1.frame.origin.y, self.smsButton1.frame.size.width, self.smsButton1.frame.size.height);
    
    [self.view addSubview:self.smsButton1];
    [self.view addSubview:self.emailButton1];
}

- (void)prompt:(UILabel *)promptLable
{
    promptLable.numberOfLines = 0;
    promptLable.font          = [UIFont systemFontOfSize:13];
    NSString *labelText       = @"       密码将通过短信发送到您的账户对应的手机号码。请牢记密码，以免再次遗忘，如果您没有维护账号的手机号码，可以尝试通过电子邮箱获取。";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle     = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:5];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    promptLable.attributedText = attributedString;
    [self.view addSubview:promptLable];
    [promptLable sizeToFit];
}

- (void)confirmButton:(UIButton *)confirmButton
{
    confirmButton.layer.cornerRadius     = 2;
    confirmButton.layer.borderColor      = [UIColor clearColor].CGColor;
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    confirmButton.titleLabel.font        = [UIFont systemFontOfSize:16];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"buttonbg1"] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(doConfirm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
}

#pragma mark - smsButton和emailButton的选择操作
- (void)doChoose:(UIButton *)button
{
    switch (button.tag)
    {
        case 10:
        {
            self.smsButton.selected = YES;
            self.emailButton.selected = NO;
        }
            break;
            
        case 11:
        {
            self.smsButton.selected = NO;
            self.emailButton.selected = YES;
        }
            break;
            
        case 12:
        {
            self.smsButton.selected = YES;
            self.emailButton.selected = NO;
        }
            break;
            
        case 13:
        {
            self.smsButton.selected = NO;
            self.emailButton.selected = YES;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 确定按钮的操作
- (void)doConfirm
{
    if (![_ob judgeNonChinese:self.accountTextField.text CustomAlterView:@"请输入正确的用户名"])
    {
        return;
    }
    
    if ([self.accountTextField.text isEqualToString:@"Sysadmin"])
    {
        
    }
    
    
    if (self.smsButton.selected)
    {
        [self doRequest:@"fromTel"];
    }
    else if (self.emailButton.selected)
    {
        [self doRequest:@"fromEmail"];
    }
}

#pragma mark - 发起网络请求
- (void)doRequest:(NSString *)string
{
    NSString *IP        = [LQIPSetting sharedLQIPSetting].IP;
    NSString *port      = [LQIPSetting sharedLQIPSetting].port;
    
    //判断IP和端口号shiufou设置了
    if (IP == nil || port == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"你还未设置服务器地址，请问是否现在设置"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        [alert show];
        alert.tag = 20;
        return;
    }
    
    //判断输入框是否为空
    if ([self.accountTextField.text isEqualToString:@""] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入管理员账号"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    //判断两个字符串不区分大小写是否相同
    NSString *astring01 = self.accountTextField.text;
    NSString *astring02 = @"sysadmin";
    BOOL result = [astring01 compare:astring02
                             options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame;
    if (!result)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入正确的管理员账号"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    //设置url并网络请求
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/adminmanager/expand/getPassword/%@.prs",IP,port,string]];
    NSData *data = [[NSString stringWithFormat:@"username=%@",self.accountTextField.text] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:20];
    [request setHTTPBody:data];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在发送";
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError){
                               NSString *str     = [[NSString alloc]initWithData:data
                                                                        encoding:NSUTF8StringEncoding];
                               NSDictionary *dic = [str JSONValue];
                               
                               if (connectionError) {
                                   dispatch_sync(dispatch_get_main_queue(), ^()
                                   {
                                       [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                       message:@"请检查您的网络"
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"确定"
                                                                             otherButtonTitles: nil];
                                       [alert show];
                                   });
                               }
                               
                               if ([[[dic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"])
                               {
                                   //GCD回到主线程
                                   dispatch_sync(dispatch_get_main_queue(), ^()
                                   {
                                       [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                       message:[[dic objectForKey:@"state"] objectForKey:@"info"]
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"确定"
                                                                             otherButtonTitles: nil];
                                       [alert show];
                                       
                                   });
                               }
                               else if ([[[dic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"])
                               {
                                   //GCD回到主线程
                                   dispatch_sync(dispatch_get_main_queue(), ^()
                                   {
                                       [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                       message:[[dic objectForKey:@"state"] objectForKey:@"info"]
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"确定"
                                                                             otherButtonTitles: nil];
                                       [alert show];
                                   });
                               }
                           }];
    
}

#pragma mark - alertview调用的方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 20)
    {
        if (buttonIndex == 1)
        {
            SetIPConfigViewController *setIPView = [[SetIPConfigViewController alloc] init];
            [self.navigationController pushViewController:setIPView animated:YES];
        }
    }
}

#pragma mark - Textfield Delegate
//释放键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.accountTextField resignFirstResponder];
    
    return YES;
}

//限制textfield字符长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if ([toBeString length] > 24)
    {
        textField.text = [toBeString substringToIndex:24];
        
        return NO;
    }
    return YES;
}

@end
