//
//  LQDataBackupData.h
//  PUER
//
//  Created by admin on 15/6/2.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LQDataBackupTableItems.h"

@interface LQDataBackupData : NSObject

/**
 *  表
 */
@property (nonatomic, strong) NSArray *tableitems;

/**
 *  存储过程
 */
@property (nonatomic, strong) NSArray *procitems;

/**
 *  视图
 */
@property (nonatomic, strong) NSArray *viewitems;

/**
 *  函数
 */
@property (nonatomic, strong) NSArray *funitems;

/**
 *  触发器
 */
@property (nonatomic, strong) NSArray *triggeritems;

/**
 *  活动监视
 */
@property (nonatomic, strong) NSArray *traninfoitems;

/**
 *  文件
 */
@property (nonatomic, strong) NSArray *dbitems;

/**
 *  sqltext
 */
@property (nonatomic, copy) NSString *sqltext;

/**
 *  能否执行SQL脚本的状态
 */
@property (nonatomic, assign) BOOL canrunsql;

/**
 *  返回最大记录数
 */
@property (nonatomic, assign) int maxrecordcount;

@end
