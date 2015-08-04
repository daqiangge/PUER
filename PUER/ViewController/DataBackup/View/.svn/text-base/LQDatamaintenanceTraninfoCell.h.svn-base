//
//  LQDatamaintenanceTraninfoCell.h
//  PUER
//
//  Created by admin on 15/6/3.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

#define cellHeight 45

@class LQDatamaintenanceTraninfoCell;

@protocol LQDatamaintenanceTraninfoCellDelegate <NSObject>

- (void)contextMenuCellDidSee:(LQDatamaintenanceTraninfoCell *)cell;
- (void)contextMenuCellDidLastRun:(LQDatamaintenanceTraninfoCell *)cell;
- (void)contextMenuDidHideInCell:(LQDatamaintenanceTraninfoCell *)cell;
- (void)contextMenuDidShowInCell:(LQDatamaintenanceTraninfoCell *)cell;
- (void)contextMenuWillHideInCell:(LQDatamaintenanceTraninfoCell *)cell;
- (void)contextMenuWillShowInCell:(LQDatamaintenanceTraninfoCell *)cell;
- (BOOL)shouldShowMenuOptionsViewInCell:(LQDatamaintenanceTraninfoCell *)cell;
@optional
- (void)contextMenuCellDidDelete:(LQDatamaintenanceTraninfoCell *)cell;


@end

@interface LQDatamaintenanceTraninfoCell : UITableViewCell

@property (strong, nonatomic) UIView *actualContentView;

@property (readonly, assign, nonatomic, getter = isContextMenuHidden) BOOL contextMenuHidden;
@property (assign, nonatomic) BOOL editable;
@property (assign, nonatomic) CGFloat menuOptionButtonTitlePadding;
@property (assign, nonatomic) CGFloat menuOptionsAnimationDuration;
@property (assign, nonatomic) CGFloat bounceValue;

@property (weak, nonatomic) UILabel *IDLable;

/**
 *  进程ID
 */
@property (weak, nonatomic) UILabel *processid;

/**
 *  状态
 */
@property (weak, nonatomic) UILabel *status;

/**
 *  开启的事务
 */
@property (weak, nonatomic) UILabel *opentransactions;

@property (nonatomic, retain) UIView *coverView;

@property (nonatomic, weak) id<LQDatamaintenanceTraninfoCellDelegate> delegate;

- (CGFloat)contextMenuWidth;
- (void)setMenuOptionsViewHidden:(BOOL)hidden animated:(BOOL)animated completionHandler:(void (^)(void))completionHandler;
+ (instancetype)datamaintenanceTraninfoCellWithTableView:(UITableView *)tableView;

@end
