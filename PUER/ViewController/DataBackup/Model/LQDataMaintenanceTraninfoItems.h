//
//  LQDataMaintenanceTraninfoItems.h
//  PUER
//
//  Created by admin on 15/6/3.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LQDataMaintenanceTraninfoItems : NSObject

@property (nonatomic, copy) NSString *processid;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *opentransactions;
@property (nonatomic, copy) NSString *cpu;
@property (nonatomic, copy) NSString *logintime;
@property (nonatomic, copy) NSString *physicalio;
@property (nonatomic, copy) NSString *waittime;
@end
