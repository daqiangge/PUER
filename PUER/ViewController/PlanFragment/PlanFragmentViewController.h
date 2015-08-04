//
//  PlanFragmentViewController.h
//  PUER
//
//  Created by admin on 14-9-12.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlanFragmentTableViewCell.h"
#import "PlanFragmentTwoTableViewCell.h"
#import "PlanFragmentTableViewController.h"

@interface PlanFragmentViewController : PlanFragmentTableViewController<UIAlertViewDelegate>

@property (nonatomic,retain) NSMutableArray *planFragmentArray;
@property BOOL judgeBack;//判断是否以执行反悔按钮操作

@property (nonatomic,retain) UIButton *menuButton;

@end
