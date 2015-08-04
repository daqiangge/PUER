//
//  object.m
//  PUER
//
//  Created by admin on 14-9-18.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "object.h"

#define IP_RE     @"(^(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])$)"
#define NON_Chinese_RE @"[\u4e00-\u9fa5]+"
#define PORT_RE @"^[0-9]*$"//端口号判断
#define PhoneNum_RE @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$"//手机号码判断,多个号码以都好隔开
#define TelNum_RE @"^(((\\+?\\d{1,20})|(\\d{3}-\\d{8}|\\d{4}-\\d{7,8}))|.{0})$"//联系电话可以填写座机或手机
#define LANDLINE_RE @"^\\d{3,4}-\\d{7,8}$"//座机号码判断
#define EMAIL_RE  @"^(([a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+\\.){1,63}[a-z0-9]+)|.{0})$"//邮箱的判断
#define SMTP      @"^((([0-9a-z_!~*''()-]+.)?([0-9a-z][0-9a-z-]{0,61})?[0-9a-z].[a-z]{2,6})|.{0})$"
#define FTP_RE      @"^(\\d{0,4}|.{0})$"
#define USERNAME  @"^[0-9A-Za-z_]+$"
//#define Password_RE @"^\\w*$"
#define MessageViewTel_RE @"[0-9]|,"
#define ContactSettingViewTel_RE @"[0-9]|-"
#define IPAndURL @"^((25[0-5])|(2[0-4]\\d)|(1\\d\\d)|([1-9]\\d)|\\d)(\\.((25[0-5])|(2[0-4]\\d)|(1\\d\\d)|([1-9]\\d)|\\d)){3}$|^([a-zA-Z0-9]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?\\.)+[a-zA-Z]{2,6}$"
#define FromURL @"^(((\\/(([^\\/\\s][^\\/]*[^\\/\\s])|([^\\/\\s]+)))+\\/?)|.{0})$"
#define ConnName @"[^<>?\":|*\\\\]"


@implementation object

- (BOOL)judgeText:(NSString *)text Regex:(NSString *)RE
{
    //正则表达式判断IP地址是否符合规范
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:RE options:0 error:&error];
    
    NSTextCheckingResult *firstMatch = [regex firstMatchInString:text options:0 range:NSMakeRange(0, [text length])];
    NSTextCheckingResult *secondMatch = [regex firstMatchInString:text options:0 range:NSMakeRange(0, [text length])];
    if (firstMatch || secondMatch) {
        return YES;
    }else{
        return NO;
    }
}

//- (BOOL)judgePassword:(NSString *)string
//{
//    if ([self judgeText:string Regex:Password_RE]) {
//        return YES;
//    }else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码只能包含数字、英文、下划线" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alert show];
//        return NO;
//    }
//}

//判断ip格式
- (BOOL)judgeIP:(NSString *)IP
{
    if ([self judgeText:IP Regex:IP_RE]) {
        return YES;
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的IP地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
}

//用于判断ip不能出现中文
- (BOOL)judgeNonChinese:(NSString *)string
{
    if ([self judgeText:string Regex:NON_Chinese_RE]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的服务器地址地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return NO;
    }else {
        return YES;
    }
}

//用于判断不能出现中文,用于自定义弹出框
- (BOOL)judgeNonChinese:(NSString *)string CustomAlterView:(NSString *)alterViewTitle
{
    if ([self judgeText:string Regex:NON_Chinese_RE]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:alterViewTitle delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return NO;
    }else {
        return YES;
    }
}

//用于判断只能为数字,用于自定义弹出框
- (BOOL)judgeNumber:(NSString *)string CustomAlterView:(NSString *)alterViewTitle
{
    if ([self judgeText:string Regex:PORT_RE]) {
        return YES;
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:alterViewTitle delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
}

//端口号
- (BOOL)judgePort:(NSString *)port
{
    if ([self judgeText:port Regex:PORT_RE]) {
        return YES;
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的端口号地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
}

//判断smtp端口
- (BOOL)judgeSmtpport:(NSString *)smtpport
{
    if ([self judgeText:smtpport Regex:PORT_RE]) {
        return YES;
    }else {
        return NO;
    }

}

//手机号码判断,多个号码以都好隔开
- (BOOL)judgeTelNum:(NSString *)TelNum
{
    if ([self judgeText:TelNum Regex:PhoneNum_RE]) {
        return YES;
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的电话号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
}

//座机号码判断
- (BOOL)judgeLandlineNum:(NSString *)TelNum
{
    if ([self judgeText:TelNum Regex:LANDLINE_RE]) {
        return YES;
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的电话号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
}

//联系电话可以填写座机或手机
- (BOOL)judgeTelNumAndLandlineNum:(NSString *)TelNum
{
    if ([self judgeText:TelNum Regex:TelNum_RE]) {
        return YES;
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的电话号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
}

//邮箱的判断
- (BOOL)judgeEmail:(NSString *)email
{
    if ([self judgeText:email Regex:EMAIL_RE]) {
        return YES;
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的邮箱" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
}

//判断SMTP
- (BOOL)judgeSmtp:(NSString *)smtp
{
    if ([self judgeText:smtp Regex:SMTP]) {
        return YES;
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的Smtp地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
}

//判断ftp地址
- (BOOL)judgeFTPAdress:(NSString *)ftp
{
    if ([self judgeText:ftp Regex:FTP_RE]) {
        return YES;
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的FTP地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
}

//判断用户名格式
- (BOOL)judgeUserName:(NSString *)username
{
    if ([self judgeText:username Regex:USERNAME]) {
        return YES;
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的用户名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
}

//短信消息界面的号码控制
- (BOOL)judgeMessageViewTel:(NSString *)string
{
    if ([self judgeText:string Regex:MessageViewTel_RE]) {
        return YES;
    }else {
        return NO;
    }
}

//修改联系方式的号码控制
- (BOOL)judgeContactSettingViewTel:(NSString *)string
{
    
    if ([self judgeText:string Regex:ContactSettingViewTel_RE]) {
        return YES;
    }else {
        return NO;
    }
}

//判断IP和域名
- (BOOL)judgeIPAndURL:(NSString *)string
{
    
    if ([self judgeText:string Regex:IPAndURL]) {
        return YES;
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的服务器地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
}

//判断代理标记
- (BOOL)judgeFromURL:(NSString *)string
{
    
    if ([self judgeText:string Regex:FromURL]) {
        return YES;
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"代理标记必须是以\"/\"开头的路径名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
}

//判断修改数据连接池中的连接名称
- (BOOL)judgeConnName:(NSString *)string
{
    if ([self judgeText:string Regex:ConnName]) {
        return YES;
    }else {
        return NO;
    }
}

@end
