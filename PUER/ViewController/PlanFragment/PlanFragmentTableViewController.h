//
//  PlanFragmentTableViewController.h
//  PUER
//
//  Created by admin on 14-9-12.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlanFragmentTableViewCell.h"

@interface PlanFragmentTableViewController : BaseTableViewController <PlanFragmentTableViewCellDelegate>

@property (assign, nonatomic) BOOL shouldDisableUserInteractionWhileEditing;
@property (nonatomic,retain) NSString *cellID;//记录到底是对那条cell进行了操作

- (void)hideMenuOptionsAnimated:(BOOL)animated;

@end
