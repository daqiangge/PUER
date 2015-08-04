//
//  LQExecutiveSQLVC.h
//  PUER
//
//  Created by admin on 15/6/4.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "BaseViewController.h"

@class LQExecutiveSQLVC;

@protocol LQExecutiveSQLVCDelegate <NSObject>

/**
 *  进行了返回操作
 */
- (void)LQExecutiveSQLVCDidPop:(LQExecutiveSQLVC *)executiveSQLVC;

@end


@interface LQExecutiveSQLVC : BaseViewController

@property BOOL judgeBack;//判断是否以执行反悔按钮操作

/**
 *  连接名称
 */
@property (nonatomic, copy) NSString *connName;

@property (nonatomic, weak) id<LQExecutiveSQLVCDelegate> delegate;

@end
