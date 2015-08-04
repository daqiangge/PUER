//
//  LQSearchBar.h
//  啊啊啊啊啊啊
//
//  Created by admin on 14/12/20.
//  Copyright (c) 2014年 蝶尚软件. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQSearchBar : UIView

@property (nonatomic,retain) UISearchBar *searchBar;
@property (nonatomic,retain) UIView *searchBackgroundView;
@property (nonatomic,retain) UIView *coverView;//半透明的遮盖view
@property (nonatomic,retain) UITableView *searchBarTableView;
@property (nonatomic,retain) UITapGestureRecognizer *tapGR;

- (void)showCoverView;
- (void)hideCoverView;
- (void)showSearchBarTableView;
- (void)hideSearchBarTableView;
- (void)openSearchBar;
- (void)cancleSearchBar;

@end
