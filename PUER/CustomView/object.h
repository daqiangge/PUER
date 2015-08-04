//
//  object.h
//  PUER
//
//  Created by admin on 14-9-18.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface object : NSObject


- (BOOL)judgeIP:(NSString *)IP;
- (BOOL)judgePort:(NSString *)port;
- (BOOL)judgeTelNum:(NSString *)TelNum;
- (BOOL)judgeEmail:(NSString *)email;
- (BOOL)judgeSmtp:(NSString *)smtp;
- (BOOL)judgeUserName:(NSString *)username;
- (BOOL)judgeLandlineNum:(NSString *)TelNum;
- (BOOL)judgeTelNumAndLandlineNum:(NSString *)TelNum;
- (BOOL)judgeNonChinese:(NSString *)string;
- (BOOL)judgeNonChinese:(NSString *)string CustomAlterView:(NSString *)alterViewTitle;
- (BOOL)judgePassword:(NSString *)string;
- (BOOL)judgeNumber:(NSString *)string CustomAlterView:(NSString *)alterViewTitle;
- (BOOL)judgeFTPAdress:(NSString *)ftp;
- (BOOL)judgeMessageViewTel:(NSString *)string;
- (BOOL)judgeContactSettingViewTel:(NSString *)string;
- (BOOL)judgeIPAndURL:(NSString *)string;
- (BOOL)judgeFromURL:(NSString *)string;
- (BOOL)judgeConnName:(NSString *)string;
- (BOOL)judgeSmtpport:(NSString *)smtpport;

@end
