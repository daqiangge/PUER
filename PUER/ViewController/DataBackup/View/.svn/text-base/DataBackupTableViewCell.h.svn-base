//
//  DataBackupTableViewCell.h
//  PUER
//
//  Created by admin on 14-9-12.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataBackupTableViewCell;

@protocol DataBackupTableViewCellDelegate <NSObject>

- (void)contextMenuCellDidSelectMoreOption:(DataBackupTableViewCell *)cell;
- (void)contextMenuCellDidFullBackup:(DataBackupTableViewCell *)cell;
- (void)contextMenuDidHideInCell:(DataBackupTableViewCell *)cell;
- (void)contextMenuDidShowInCell:(DataBackupTableViewCell *)cell;
- (void)contextMenuWillHideInCell:(DataBackupTableViewCell *)cell;
- (void)contextMenuWillShowInCell:(DataBackupTableViewCell *)cell;
- (BOOL)shouldShowMenuOptionsViewInCell:(DataBackupTableViewCell *)cell;
@optional
- (void)contextMenuCellDidSelectDeleteOption:(DataBackupTableViewCell *)cell;


@end


@interface DataBackupTableViewCell : UITableViewCell

@property (strong, nonatomic) UIView *actualContentView;

@property (readonly, assign, nonatomic, getter = isContextMenuHidden) BOOL contextMenuHidden;
@property (strong, nonatomic) NSString *deleteButtonTitle;
@property (strong, nonatomic) NSString *moreOptionsButtonTitle;
@property (strong, nonatomic) NSString *fullBackupButtonTitle;
@property (assign, nonatomic) BOOL editable;
@property (assign, nonatomic) CGFloat menuOptionButtonTitlePadding;
@property (assign, nonatomic) CGFloat menuOptionsAnimationDuration;
@property (assign, nonatomic) CGFloat bounceValue;


@property (retain, nonatomic) UILabel *IDLable;
@property (retain, nonatomic) UILabel *nameLable;
@property (retain, nonatomic) UILabel *backupPathLable;
@property (nonatomic, retain) UIView *coverView;
@property (nonatomic,retain) UIActivityIndicatorView *activity;//等待指示器

@property (weak, nonatomic) id<DataBackupTableViewCellDelegate> delegate;

- (CGFloat)contextMenuWidth;
- (void)setMenuOptionsViewHidden:(BOOL)hidden animated:(BOOL)animated completionHandler:(void (^)(void))completionHandler;


@end
