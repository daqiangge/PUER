//
//  NetworkTableViewCell.h
//  PUER
//
//  Created by admin on 14-9-3.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NetworkTableViewCell;

@protocol NetworkTableViewCellDelegate <NSObject>

- (void)contextMenuCellModifyOption:(NetworkTableViewCell *)cell;
- (void)contextMenuDidHideInCell:(NetworkTableViewCell *)cell;
- (void)contextMenuDidShowInCell:(NetworkTableViewCell *)cell;
- (void)contextMenuWillHideInCell:(NetworkTableViewCell *)cell;
- (void)contextMenuWillShowInCell:(NetworkTableViewCell *)cell;
- (BOOL)shouldShowMenuOptionsViewInCell:(NetworkTableViewCell *)cell;
@optional
- (void)contextMenuCellDidSelectDeleteOption:(NetworkTableViewCell *)cell;


@end


@interface NetworkTableViewCell : UITableViewCell

@property (strong, nonatomic) UIView *actualContentView;

@property (readonly, assign, nonatomic, getter = isContextMenuHidden) BOOL contextMenuHidden;
@property (strong, nonatomic) NSString *modifyButtonTitle;
@property (strong, nonatomic) NSString *moreOptionsButtonTitle;
@property (assign, nonatomic) BOOL editable;
@property (assign, nonatomic) CGFloat menuOptionButtonTitlePadding;
@property (assign, nonatomic) CGFloat menuOptionsAnimationDuration;
@property (assign, nonatomic) CGFloat bounceValue;


@property (retain, nonatomic) UILabel *IDLable;
@property (retain, nonatomic) UILabel *fromUrlLable;
@property (retain, nonatomic) UILabel *toUrlLable;
@property (nonatomic, retain) UIView *coverView;

@property (weak, nonatomic) id<NetworkTableViewCellDelegate> delegate;

- (CGFloat)contextMenuWidth;
- (void)setMenuOptionsViewHidden:(BOOL)hidden animated:(BOOL)animated completionHandler:(void (^)(void))completionHandler;



@end
