//
//  FilterTableViewCell.h
//  PUER
//
//  Created by admin on 14/12/23.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterTableViewCell;

@protocol FilterTableViewCellDelegate <NSObject>

- (void)contextMenuCellModifyOption:(FilterTableViewCell *)cell;
- (void)contextMenuDidHideInCell:(FilterTableViewCell *)cell;
- (void)contextMenuDidShowInCell:(FilterTableViewCell *)cell;
- (void)contextMenuWillHideInCell:(FilterTableViewCell *)cell;
- (void)contextMenuWillShowInCell:(FilterTableViewCell *)cell;
- (BOOL)shouldShowMenuOptionsViewInCell:(FilterTableViewCell *)cell;
@optional
- (void)contextMenuCellDidSelectDeleteOption:(FilterTableViewCell *)cell;
@end


@interface FilterTableViewCell : UITableViewCell

@property (strong, nonatomic) UIView *actualContentView;

@property (readonly, assign, nonatomic, getter = isContextMenuHidden) BOOL contextMenuHidden;
@property (strong, nonatomic) NSString *modifyButtonTitle;
@property (strong, nonatomic) NSString *moreOptionsButtonTitle;
@property (strong, nonatomic) UIButton *modifyButton;
@property (strong, nonatomic) UIButton *deleteButton;
@property (assign, nonatomic) BOOL editable;
@property (assign, nonatomic) CGFloat menuOptionButtonTitlePadding;
@property (assign, nonatomic) CGFloat menuOptionsAnimationDuration;
@property (assign, nonatomic) CGFloat bounceValue;


@property (retain, nonatomic) UILabel *IDLable;//ID
@property (retain, nonatomic) UIImageView *filterImagerView;
@property (retain, nonatomic) UILabel *filterNameLable;//过滤器名称
@property (retain, nonatomic) UILabel *defaultLable;//默认
@property (retain, nonatomic) UILabel *checkSessionLable;//检查会话
@property (nonatomic, retain) UIView *coverView;

@property (weak, nonatomic) id<FilterTableViewCellDelegate> delegate;

- (CGFloat)contextMenuWidth;
- (void)setMenuOptionsViewHidden:(BOOL)hidden animated:(BOOL)animated completionHandler:(void (^)(void))completionHandler;



@end
