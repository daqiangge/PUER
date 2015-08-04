//
//  LQResourcesFile.m
//  PUER
//
//  Created by admin on 15/3/24.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "LQResourcesFile.h"

@implementation LQResourcesFile

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self == [super init])
    {
//        [self setValuesForKeysWithDictionary:dic];
        self.name = dic[@"name"];
        self.lastchgtime = dic[@"lastchgtime"];
        self.version = dic[@"version"];
        self.type = dic[@"type"];
        
        if ([dic[@"size"] intValue]>1024) {
            self.size = [NSString stringWithFormat:@"%d KB",[dic[@"size"] intValue]/1024];
        }else {
            self.size = [NSString stringWithFormat:@"%d B",[dic[@"size"] intValue]];
        }
    }
    
    return self;
}

+ (instancetype)resourcesFileWithDic:(NSDictionary *)dic
{
    return [[LQResourcesFile alloc] initWithDic:dic];
}


@end
