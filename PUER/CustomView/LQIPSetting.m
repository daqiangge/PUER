//
//  LQIPSetting.m
//  PUER
//
//  Created by admin on 15/3/19.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "LQIPSetting.h"

@implementation LQIPSetting

singleton_m(LQIPSetting)

- (id)init
{
    if (self = [super init]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            self.IP   = [[NSUserDefaults standardUserDefaults] valueForKey:@"IP"];
            self.port = [[NSUserDefaults standardUserDefaults] valueForKey:@"port"];
            self.sid  = [[NSUserDefaults standardUserDefaults] valueForKey:@"sid"];
        });
    }
    
    return self;
}

- (NSString *)IP
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"IP"];
}

- (NSString *)port
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"port"];
}

- (NSString *)sid
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"sid"];
}

@end
