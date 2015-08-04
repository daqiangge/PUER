//
//  LQDataMaintenanceTraninfoVC.h
//  PUER
//
//  Created by admin on 15/6/3.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "BaseViewController.h"

@class LQDataMaintenanceTraninfoVC;

@protocol LQDataMaintenanceTraninfoVCDelegate <NSObject>

/**
 *  进行了返回操作
 */
- (void)dataMaintenanceTraninfoVCDidPop:(LQDataMaintenanceTraninfoVC *)dataMaintenanceTraninfoVC;

@end

@interface LQDataMaintenanceTraninfoVC : BaseViewController

@property (nonatomic, weak) id<LQDataMaintenanceTraninfoVCDelegate> delegate;
@property (assign, nonatomic) BOOL shouldDisableUserInteractionWhileEditing;
@property (nonatomic, copy) NSString *connName;//连接名称
@property BOOL judgeBack;//判断是否以执行反悔按钮操作

@end
