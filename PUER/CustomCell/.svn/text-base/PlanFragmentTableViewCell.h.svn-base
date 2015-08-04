//
//  PlanFragmentTableViewCell.h
//  PUER
//
//  Created by admin on 14-9-12.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlanFragmentTableViewCell;

@protocol PlanFragmentTableViewCellDelegate <NSObject>

- (void)contextMenuCellDidSelectMoreOption:(PlanFragmentTableViewCell *)cell;
- (void)contextMenuDidHideInCell:(PlanFragmentTableViewCell *)cell;
- (void)contextMenuDidShowInCell:(PlanFragmentTableViewCell *)cell;
- (void)contextMenuWillHideInCell:(PlanFragmentTableViewCell *)cell;
- (void)contextMenuWillShowInCell:(PlanFragmentTableViewCell *)cell;
- (BOOL)shouldShowMenuOptionsViewInCell:(PlanFragmentTableViewCell *)cell;
@optional
- (void)contextMenuCellDidSelectDeleteOption:(PlanFragmentTableViewCell *)cell;


@end

@interface PlanFragmentTableViewCell : UITableViewCell

@property (strong, nonatomic) UIView *actualContentView;

@property (readonly, assign, nonatomic, getter = isContextMenuHidden) BOOL contextMenuHidden;
@property (strong, nonatomic) NSString *deleteButtonTitle;
@property (strong, nonatomic) NSString *moreOptionsButtonTitle;
@property (strong, nonatomic) UIButton *moreOptionsButton;
@property (strong, nonatomic) UIButton *deleteButton;
@property (assign, nonatomic) BOOL editable;
@property (assign, nonatomic) CGFloat menuOptionButtonTitlePadding;
@property (assign, nonatomic) CGFloat menuOptionsAnimationDuration;
@property (assign, nonatomic) CGFloat bounceValue;


@property (retain, nonatomic) UILabel *IDLable;
@property (retain, nonatomic) UILabel *nameLable;
@property (retain, nonatomic) UILabel *stateLable;
@property (nonatomic, retain) UIView *coverView;
@property (nonatomic,retain) UIActivityIndicatorView *activity;//等待指示器

@property (weak, nonatomic) id<PlanFragmentTableViewCellDelegate> delegate;

- (CGFloat)contextMenuWidth;
- (void)setMenuOptionsViewHidden:(BOOL)hidden animated:(BOOL)animated completionHandler:(void (^)(void))completionHandler;

@end
