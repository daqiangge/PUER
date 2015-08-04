//
//  LQDataMaintenanceTableCell.h
//  PUER
//
//  Created by admin on 15/6/2.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

#define cellHeight 60

@class LQDataMaintenanceTableCell;

@protocol LQDataMaintenanceTableCellDelegate <NSObject>

- (void)contextMenuDidHideInCell:(LQDataMaintenanceTableCell *)cell;
- (void)contextMenuDidShowInCell:(LQDataMaintenanceTableCell *)cell;
- (void)contextMenuWillHideInCell:(LQDataMaintenanceTableCell *)cell;
- (void)contextMenuWillShowInCell:(LQDataMaintenanceTableCell *)cell;
- (BOOL)shouldShowMenuOptionsViewInCell:(LQDataMaintenanceTableCell *)cell;
@optional
- (void)contextMenuCellDidSee:(LQDataMaintenanceTableCell *)cell;


@end

@interface LQDataMaintenanceTableCell : UITableViewCell

@property (strong, nonatomic) UIView *actualContentView;

@property (readonly, assign, nonatomic, getter = isContextMenuHidden) BOOL contextMenuHidden;
@property (assign, nonatomic) BOOL editable;
@property (assign, nonatomic) CGFloat menuOptionButtonTitlePadding;
@property (assign, nonatomic) CGFloat menuOptionsAnimationDuration;
@property (assign, nonatomic) CGFloat bounceValue;


@property (retain, nonatomic) UILabel *IDLable;
@property (retain, nonatomic) UILabel *nameLable;
@property (weak, nonatomic) UILabel *createdateLable;
@property (weak, nonatomic) UILabel *modifydateLable;
@property (nonatomic, retain) UIView *coverView;

@property (weak, nonatomic) id<LQDataMaintenanceTableCellDelegate> delegate;

- (CGFloat)contextMenuWidth;
- (void)setMenuOptionsViewHidden:(BOOL)hidden animated:(BOOL)animated completionHandler:(void (^)(void))completionHandler;
+ (LQDataMaintenanceTableCell *)dataMaintenanceTableCellWithTableView:(UITableView *)tableView;

@end
