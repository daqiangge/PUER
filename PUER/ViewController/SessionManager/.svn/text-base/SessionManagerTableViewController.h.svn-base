//
//  SessionManagerTableViewController.h
//  PUER
//
//  Created by admin on 14-9-5.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//
//
//此处代码均需参照DAContextMenuTableViewController类中的代码进行查看

#import <UIKit/UIKit.h>
#import "SessionManagerTableViewCell.h"

@interface SessionManagerTableViewController : BaseTableViewController<UISearchDisplayDelegate,UISearchBarDelegate,SessionManagerTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate>

@property (assign, nonatomic) BOOL shouldDisableUserInteractionWhileEditing;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;

//用于判断即将操作的tableview是原始的tableview还是搜索界面的tableview，如果为YES则代表在搜索界面操作，如果为NO则代表在原始界面上操作
@property (assign, nonatomic) BOOL judgeSelfTableViewOrSearchResultsTableView;

- (void)hideMenuOptionsAnimated:(BOOL)animated;

@end
