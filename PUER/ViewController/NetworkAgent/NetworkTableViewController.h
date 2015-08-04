//
//  NetworkTableViewController.h
//  PUER
//
//  Created by admin on 14-9-3.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkTableViewCell.h"

@interface NetworkTableViewController : BaseTableViewController<NetworkTableViewCellDelegate>

@property (assign, nonatomic) BOOL shouldDisableUserInteractionWhileEditing;

- (void)hideMenuOptionsAnimated:(BOOL)animated;

@end
