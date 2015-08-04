//
//  LQSearchBar.m
//  啊啊啊啊啊啊
//
//  Created by admin on 14/12/20.
//  Copyright (c) 2014年 蝶尚软件. All rights reserved.
//

#import "LQSearchBar.h"

@implementation LQSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSearchBar];
    }
    return self;
}

- (void)initSearchBar
{
    _searchBackgroundView = [[UIView alloc] init];
    _searchBackgroundView.frame = CGRectMake(0, 0, self.frame.size.width, 64);
    _searchBackgroundView.backgroundColor = [UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:1];
    [self addSubview:_searchBackgroundView];
    
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.frame = CGRectMake(0, _searchBackgroundView.frame.size.height-44, self.frame.size.width, 44);
    [_searchBar setBackgroundImage:[UIImage new]];
    [_searchBar setTranslucent:YES];
    _searchBar.placeholder = @"搜索";
    [_searchBackgroundView addSubview:_searchBar];
    
    _coverView = [[UIView alloc] init];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0;
    [self addSubview: _coverView];
    
    //当未搜索时，点击取消搜索
    _tapGR = [[UITapGestureRecognizer alloc] init];
    _tapGR.numberOfTapsRequired = 1; // * 点击空白处几下
    [_coverView addGestureRecognizer:_tapGR];
    
    _searchBarTableView = [[UITableView alloc] init];
    [self addSubview:_searchBarTableView];
}

- (void)showCoverView
{
    _coverView.frame = CGRectMake(0, _searchBackgroundView.frame.size.height, self.frame.size.width, self.frame.size.height-_searchBackgroundView.frame.size.height);
    
    [UIView animateWithDuration:0.2 animations:^{
        _coverView.alpha = 0.5;
    }];
}

- (void)hideCoverView
{
    _coverView.alpha = 0;
}

- (void)showSearchBarTableView
{
    _searchBarTableView.frame = CGRectMake(0, _searchBackgroundView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-NavgationBarAndStareBar_height);
    _searchBarTableView.hidden  =  NO;
}

- (void)hideSearchBarTableView
{
    _searchBarTableView.hidden = YES;
}

- (void)cancleSearchBar
{
    _searchBar.text = @"";
    [_searchBar resignFirstResponder];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, 44, self.frame.size.width, 64);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideCoverView];
        [self hideSearchBarTableView];
        
    });
    [_searchBar setShowsCancelButton:NO animated:YES];
}

- (void)openSearchBar
{
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, 0, _searchBar.frame.size.width, 1000);
    }];
    
    //显示遮盖的view
    [self showCoverView];
    
    [_searchBar setShowsCancelButton:YES animated:YES];
}

@end
