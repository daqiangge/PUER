//
//  LQDataMaintenanceVC.h
//  PUER
//
//  Created by admin on 15/6/2.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DataMaintenanceFunctionNames @[@"Table",@"View",@"Fun",@"Proc",@"Trigger",@"Traninfo"]

@class LQDataMaintenanceTableVC;

@protocol LQDataMaintenanceTableVCDelegate <NSObject>

/**
 *  进行了返回操作
 */
- (void)dataMaintenanceVCDidPop:(LQDataMaintenanceTableVC *)dataMaintenanceTableVC;

@end


@interface LQDataMaintenanceTableVC : BaseViewController

@property (nonatomic, weak) id<LQDataMaintenanceTableVCDelegate> delegate;
@property (assign, nonatomic) BOOL shouldDisableUserInteractionWhileEditing;
@property BOOL judgeBack;//判断是否以执行反悔按钮操作
@property (nonatomic, copy) NSString *mainURLStr;//区分功能的主要一段的URL
@property (nonatomic, copy) NSString *viewTitle;//界面标题
@property (nonatomic, copy) NSString *connName;//连接名称
@property (nonatomic, strong) NSArray *titleNames;

/**
 *  功能名称,区分各个功能点
 */
@property (nonatomic, copy) NSString *functionName;

@end
