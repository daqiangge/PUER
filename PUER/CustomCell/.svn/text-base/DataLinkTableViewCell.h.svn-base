//
//  DataLinkTableViewCell.h
//  PUER
//
//  Created by admin on 14-8-29.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataLinkTableViewCell;

@protocol DataLinkTableViewCellDelegate <NSObject>

- (void)contextMenuCellModifyOption:(DataLinkTableViewCell *)cell;
- (void)contextMenuDidHideInCell:(DataLinkTableViewCell *)cell;
- (void)contextMenuDidShowInCell:(DataLinkTableViewCell *)cell;
- (void)contextMenuWillHideInCell:(DataLinkTableViewCell *)cell;
- (void)contextMenuWillShowInCell:(DataLinkTableViewCell *)cell;
- (BOOL)shouldShowMenuOptionsViewInCell:(DataLinkTableViewCell *)cell;
@optional
- (void)contextMenuCellDidSelectDeleteOption:(DataLinkTableViewCell *)cell;
- (void)contextMenuCelltestConnectionOption:(DataLinkTableViewCell *)cell;


@end



@interface DataLinkTableViewCell : UITableViewCell

@property (strong, nonatomic) UIView *actualContentView;

@property (readonly, assign, nonatomic, getter = isContextMenuHidden) BOOL contextMenuHidden;
@property (strong, nonatomic) NSString *deleteButtonTitle;//修改
@property (strong, nonatomic) NSString *moreOptionsButtonTitle;//测试连接的操作
@property (strong, nonatomic) NSString *testConnectionButtonTitle;//测试链接
@property (assign, nonatomic) BOOL editable;
@property (assign, nonatomic) CGFloat menuOptionButtonTitlePadding;
@property (assign, nonatomic) CGFloat menuOptionsAnimationDuration;
@property (assign, nonatomic) CGFloat bounceValue;


@property (retain, nonatomic) UILabel *IDLable;
@property (retain, nonatomic) UILabel *nameLable;
@property (retain, nonatomic) UILabel *databaseLable;
@property (retain, nonatomic) UILabel *IPLable;
@property (retain, nonatomic) UILabel *poolcount;
@property (nonatomic, retain) UIView *coverView;

@property (weak, nonatomic) id<DataLinkTableViewCellDelegate> delegate;

- (CGFloat)contextMenuWidth;
- (void)setMenuOptionsViewHidden:(BOOL)hidden animated:(BOOL)animated completionHandler:(void (^)(void))completionHandler;


@end
