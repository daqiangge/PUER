//
//  SessionManagerTableViewCell.h
//  PUER
//
//  Created by admin on 14-9-5.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SessionManagerTableViewCell;

@protocol SessionManagerTableViewCellDelegate <NSObject>

- (void)contextMenuCellDidSelectMoreOption:(SessionManagerTableViewCell *)cell;
- (void)contextMenuDidHideInCell:(SessionManagerTableViewCell *)cell;
- (void)contextMenuDidShowInCell:(SessionManagerTableViewCell *)cell;
- (void)contextMenuWillHideInCell:(SessionManagerTableViewCell *)cell;
- (void)contextMenuWillShowInCell:(SessionManagerTableViewCell *)cell;
- (BOOL)shouldShowMenuOptionsViewInCell:(SessionManagerTableViewCell *)cell;
@optional
- (void)contextMenuCellDidSelectDeleteOption:(SessionManagerTableViewCell *)cell;


@end

@interface SessionManagerTableViewCell : UITableViewCell

@property (strong, nonatomic) UIView *actualContentView;

@property (readonly, assign, nonatomic, getter = isContextMenuHidden) BOOL contextMenuHidden;
@property (strong, nonatomic) NSString *deleteButtonTitle;
@property (strong, nonatomic) NSString *moreOptionsButtonTitle;
@property (assign, nonatomic) BOOL editable;
@property (assign, nonatomic) CGFloat menuOptionButtonTitlePadding;
@property (assign, nonatomic) CGFloat menuOptionsAnimationDuration;
@property (assign, nonatomic) CGFloat bounceValue;


@property (retain, nonatomic) UILabel *IDLable;
@property (retain, nonatomic) UILabel *nameLable;
@property (retain, nonatomic) UILabel *IPLable;
@property (retain, nonatomic) UILabel *userNameLable;
@property (retain, nonatomic) UILabel *timeLable;
@property (retain, nonatomic) UILabel *sessionidLable;
@property (retain, nonatomic) UIImageView *networkStateImageView;
@property (nonatomic, retain) UIView *coverView;
@property (nonatomic,retain) UILabel *noContentLable;

@property (weak, nonatomic) id<SessionManagerTableViewCellDelegate> delegate;

- (CGFloat)contextMenuWidth;
- (void)setMenuOptionsViewHidden:(BOOL)hidden animated:(BOOL)animated completionHandler:(void (^)(void))completionHandler;



@end
