//
//  LQDataMaintenanceLoginSQLView.m
//  PUER
//
//  Created by admin on 15/6/10.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "LQDataMaintenanceLoginSQLView.h"

@interface LQDataMaintenanceLoginSQLView()<UITextFieldDelegate>

@end

@implementation LQDataMaintenanceLoginSQLView

+ (instancetype)dataMaintenanceLoginSQLView
{
    CGRect frame = CGRectMake(0, NavgationBarAndStareBar_height, SCREEN_WIDTH, SCREEN_HEIGHT-NavgationBarAndStareBar_height);
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self loadingView];
    }
    
    return self;
}

- (void)loadingView
{
    //提示语
    CGFloat lableX = 10 ;
    CGFloat lableY = lableX ;
    CGFloat lableW = SCREEN_WIDTH - 2*lableX ;
    
    UILabel *lable = [[UILabel alloc] init];
    lable.text = @"SQL语句执行功能在安全密码保护下，请输入安全密码";
    lable.font = [UIFont systemFontOfSize:15];
    lable.numberOfLines = 0;
    CGFloat lableH = [lable.text calculationHeightWithString:lable.text stringWidth:lableW font:lable.font] ;
    CGRect  lableF = CGRectMake(lableX, lableY, lableW, lableH);
    lable.frame = lableF;
    [self addSubview:lable];
    
    //密码输入框
    CGFloat passwordTFX = CGRectGetMinX(lable.frame);
    CGFloat passwordTFY = CGRectGetMaxY(lable.frame) + 10;
    CGFloat passwordTFW = CGRectGetWidth(lable.frame);
    CGFloat passwordTFH = 40;
    CGRect  passwordTFF = CGRectMake(passwordTFX, passwordTFY, passwordTFW, passwordTFH);
    
    LQTextField *passwordTF = [[LQTextField alloc] init];
    passwordTF.frame = passwordTFF;
    passwordTF.secureTextEntry = YES;
    passwordTF.delegate = self;
    passwordTF.font = [UIFont systemFontOfSize:15];
    passwordTF.layer.borderColor  = layer_borderColor;
    passwordTF.layer.borderWidth  = layer_borderWidth;
    passwordTF.layer.cornerRadius = layer_cornerRadius;
    [self addSubview:passwordTF];
    self.passwordTF = passwordTF;
    
    //验证密码按钮
    CGFloat loginBtnX = CGRectGetMinX(passwordTF.frame);
    CGFloat loginBtnY = CGRectGetMaxY(passwordTF.frame) + 20;
    CGFloat loginBtnW = CGRectGetWidth(passwordTF.frame);
    CGFloat loginBtnH = CGRectGetHeight(passwordTF.frame);
    CGRect  loginBtnF = CGRectMake(loginBtnX, loginBtnY, loginBtnW, loginBtnH);
    
    UIButton *loginBtn = [[UIButton alloc] init];
    loginBtn.frame = loginBtnF;
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"buttonbg3"] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitle:@"进入SQL语句执行功能" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:loginBtn];
    
    //忘记密码
    CGFloat forgetPWBtnX = CGRectGetMinX(loginBtn.frame);
    CGFloat forgetPWBtnY = CGRectGetMaxY(loginBtn.frame) + 10;
    CGFloat forgetPWBtnW = CGRectGetWidth(loginBtn.frame);
    CGFloat forgetPWBtnH = CGRectGetHeight(loginBtn.frame);
    CGRect  forgetPWBtnF = CGRectMake(forgetPWBtnX, forgetPWBtnY, forgetPWBtnW, forgetPWBtnH);
    
    UIButton *forgetPWBtn = [[UIButton alloc] init];
    forgetPWBtn.frame = forgetPWBtnF;
    [forgetPWBtn setBackgroundImage:[UIImage imageNamed:@"buttonbg4"] forState:UIControlStateNormal];
    [forgetPWBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [forgetPWBtn setTitle:@"修改安全密码" forState:UIControlStateNormal];
    [forgetPWBtn addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    forgetPWBtn.titleLabel.font = loginBtn.titleLabel.font;
    [self addSubview:forgetPWBtn];
}

- (void)login
{
    if ([self.delegate respondsToSelector:@selector(dataMaintenanceLoginSQLViewDidLogin:)]) {
        [self.delegate dataMaintenanceLoginSQLViewDidLogin:self];
    }
}

- (void)forgetPassword
{
    if ([self.delegate respondsToSelector:@selector(dataMaintenanceLoginSQLViewDidForgetPassword:)]) {
        [self.delegate dataMaintenanceLoginSQLViewDidForgetPassword:self];
    }
}

#pragma mark - textFieldDelegate
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
    
    //判读是是否有中文
    for (int i = 0; i<[toBeString length]; i++)
    {
        //截取字符串中的每一个字符
        NSString *s = [toBeString substringWithRange:NSMakeRange(i, 1)];
        if ([[Regex shareInstance] judgeChinese:s])
        {
            return NO;
        }
    }
    
    return YES;
}

@end
