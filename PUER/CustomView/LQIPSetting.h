//
//  LQIPSetting.h
//  PUER
//
//  Created by admin on 15/3/19.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface LQIPSetting : NSObject
singleton_h(LQIPSetting)

@property (nonatomic, copy) NSString *IP;
@property (nonatomic, copy) NSString *port;
@property (nonatomic, copy) NSString *sid;

@end
