//
//  IpAndOther.m
//  GOBO
//
//  Created by admin on 14/11/12.
//  Copyright (c) 2014年 蝶尚软件. All rights reserved.
//

#import "IpAndOther.h"

static IpAndOther *sigleton = nil;

@implementation IpAndOther

+ (IpAndOther *)shareInstance {
    if (sigleton == nil) {
        @synchronized(self){
            sigleton = [[IpAndOther alloc] init];
        }
    }
    return sigleton;
}

- (id)init {
    self = [super init];
    
    if (self) {
        //初始化一些参数
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        _IP                = [ud objectForKey:@"IP"];
        _port              = [ud objectForKey:@"port"];
        _sid               = [ud objectForKey:@"sid"];
    }
    
    return self;
}

//限制当前对象创建多实例
#pragma mark - sengleton setting
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sigleton == nil) {
            sigleton = [super allocWithZone:zone];
        }
    }
    return sigleton;
}

+ (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (NSString *)getIP
{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    _IP                = [ud objectForKey:@"IP"];
    return _IP;
}

- (NSString *)getPort
{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    _port              = [ud objectForKey:@"port"];
    
    return _port;
}

- (NSString *)getSid
{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    _sid               = [ud objectForKey:@"sid"];
    
    return _sid;
}

@end
