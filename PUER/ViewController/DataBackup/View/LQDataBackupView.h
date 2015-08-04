//
//  LQDataBackupView.h
//  PUER
//
//  Created by admin on 15/6/1.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LQDataBackupView;

@protocol LQDataBackupViewDelegate <NSObject>

- (void)dataBackupButtonDidCompleteBackup:(LQDataBackupView *)dataBackupView;//完全备份
- (void)dataBackupButtonDidDifferentialBackup:(LQDataBackupView *)dataBackupView;//差异备份
- (void)dataBackupButtonDidDataShrinkage:(LQDataBackupView *)dataBackupView;//数据收缩

- (void)dataMaintenanceButtonWithTable:(LQDataBackupView *)dataBackupView;//表
- (void)dataMaintenanceButtonWithView:(LQDataBackupView *)dataBackupView;//视图
- (void)dataMaintenanceButtonWithFunction:(LQDataBackupView *)dataBackupView;//函数
- (void)dataMaintenanceButtonWithStoredProcedure:(LQDataBackupView *)dataBackupView;//存储过程
- (void)dataMaintenanceButtonWithTrigger:(LQDataBackupView *)dataBackupView;//触发器
- (void)dataMaintenanceButtonWithActivityMonitoring:(LQDataBackupView *)dataBackupView;//活动监视
- (void)dataMaintenanceButtonWithFile:(LQDataBackupView *)dataBackupView;//文件
- (void)dataMaintenanceButtonWithSQL:(LQDataBackupView *)dataBackupView;//SQL

- (void)dataBackupMenuDidClose:(LQDataBackupView *)dataBackupView;

@end

@interface LQDataBackupView : UIView

@property (nonatomic, assign) BOOL open;
@property (nonatomic, assign) int buttonNum;
@property (nonatomic, assign) CGFloat menuHeight;
@property (nonatomic, strong) id <LQDataBackupViewDelegate> dataBackupViewDelegate;

+ (instancetype)dataBackupView;

@end
