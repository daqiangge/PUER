//
//  ShowAllFilterOrCustomFilter.m
//  PUER
//
//  Created by admin on 14/12/30.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "ShowAllFilterOrCustomFilter.h"

static ShowAllFilterOrCustomFilter *sigleton = nil;

@implementation ShowAllFilterOrCustomFilter

+ (ShowAllFilterOrCustomFilter *)shareInstance {
    if (sigleton == nil) {
        @synchronized(self){
            sigleton = [[ShowAllFilterOrCustomFilter alloc] init];
        }
    }
    return sigleton;
}

- (id)init {
    self = [super init];
    
    if (self) {
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"showAllFilter"] == nil) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"showAllFilter"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        _showAllFilter = [[[NSUserDefaults standardUserDefaults] objectForKey:@"showAllFilter"] boolValue];
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

- (void)setShowAllFilter:(BOOL)showAllFilter
{
    _showAllFilter = showAllFilter;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:showAllFilter] forKey:@"showAllFilter"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
