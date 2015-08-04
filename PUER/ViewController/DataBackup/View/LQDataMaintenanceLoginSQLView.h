//
//  LQDataMaintenanceLoginSQLView.h
//  PUER
//
//  Created by admin on 15/6/10.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LQDataMaintenanceLoginSQLView;

@protocol LQDataMaintenanceLoginSQLViewDelegate <NSObject>

/**
 *  验证安全密码
 *
 */
- (void)dataMaintenanceLoginSQLViewDidLogin:(LQDataMaintenanceLoginSQLView *)dataMaintenanceLoginSQLView;

/**
 *  忘记密码
 */
- (void)dataMaintenanceLoginSQLViewDidForgetPassword:(LQDataMaintenanceLoginSQLView *)dataMaintenanceLoginSQLView;

@end


@interface LQDataMaintenanceLoginSQLView : UIView

@property (nonatomic, weak) id<LQDataMaintenanceLoginSQLViewDelegate> delegate;
@property (nonatomic, weak) UITextField *passwordTF;

+ (instancetype)dataMaintenanceLoginSQLView;

@end
