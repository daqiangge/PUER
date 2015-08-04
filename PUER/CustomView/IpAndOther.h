//
//  IpAndOther.h
//  GOBO
//
//  Created by admin on 14/11/12.
//  Copyright (c) 2014年 蝶尚软件. All rights reserved.
//
//------------------------------------------------------------
//--------------------单例IP，Port和其他----------------------
//------------------------------------------------------------

#import <Foundation/Foundation.h>

@interface IpAndOther : NSObject

@property (nonatomic,retain) NSString *IP;
@property (nonatomic,retain) NSString *port;
@property (nonatomic,retain) NSString *sid;

+ (IpAndOther *)shareInstance;//实例化--单例模式
- (NSString *)getIP;
- (NSString *)getPort;
- (NSString *)getSid;

@end
