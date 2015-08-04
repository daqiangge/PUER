//
//  LQDataMaintenanceDbCell.h
//  PUER
//
//  Created by admin on 15/6/3.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

#define cellHeight 60

@class LQDataMaintenanceDbCell;

@protocol LQDataMaintenanceDbCellDelegate <NSObject>

- (void)contextMenuDidHideInCell:(LQDataMaintenanceDbCell *)cell;
- (void)contextMenuDidShowInCell:(LQDataMaintenanceDbCell *)cell;
- (void)contextMenuWillHideInCell:(LQDataMaintenanceDbCell *)cell;
- (void)contextMenuWillShowInCell:(LQDataMaintenanceDbCell *)cell;
- (BOOL)shouldShowMenuOptionsViewInCell:(LQDataMaintenanceDbCell *)cell;
@optional
- (void)contextMenuCellDidSee:(LQDataMaintenanceDbCell *)cell;
@end

@interface LQDataMaintenanceDbCell : UITableViewCell

@property (strong, nonatomic) UIView *actualContentView;

@property (readonly, assign, nonatomic, getter = isContextMenuHidden) BOOL contextMenuHidden;
@property (assign, nonatomic) BOOL editable;
@property (assign, nonatomic) CGFloat menuOptionButtonTitlePadding;
@property (assign, nonatomic) CGFloat menuOptionsAnimationDuration;
@property (assign, nonatomic) CGFloat bounceValue;

@property (nonatomic, weak) id<LQDataMaintenanceDbCellDelegate> delegate;

@property (retain, nonatomic) UILabel *IDLable;
@property (retain, nonatomic) UILabel *nameLable;
@property (weak, nonatomic) UILabel *sizeLable;
@property (nonatomic, retain) UIView *coverView;

- (CGFloat)contextMenuWidth;
- (void)setMenuOptionsViewHidden:(BOOL)hidden animated:(BOOL)animated completionHandler:(void (^)(void))completionHandler;
+ (LQDataMaintenanceDbCell *)dataMaintenanceDbCellWithTableView:(UITableView *)tableView;

@end
