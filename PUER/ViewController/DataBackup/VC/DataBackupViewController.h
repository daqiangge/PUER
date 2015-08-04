//
//  DataBackupViewController.h
//  PUER
//
//  Created by admin on 14-8-14.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBackupTableViewController.h"

@interface DataBackupViewController : DataBackupTableViewController<UIAlertViewDelegate>

@property (nonatomic,retain) NSMutableArray *dataBackupArray;
@property BOOL judgeBack;//判断是否以执行反悔按钮操作

@property (nonatomic,retain) UIButton *menuButton;


@end
