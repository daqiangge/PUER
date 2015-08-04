//
//  LogQueryViewController.h
//  GOBO
//
//  Created by admin on 14/11/14.
//  Copyright (c) 2014年 蝶尚软件. All rights reserved.
//

#import "BaseViewController.h"
#import "VRGCalendarView.h"

@interface LogQueryViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,VRGCalendarViewDelegate,UIAlertViewDelegate,UISearchBarDelegate>

@property (nonatomic,retain) LQSearchBar    *searchBar;
@property (nonatomic,retain) UIView         *backgroundView;
@property (nonatomic,retain) UITableView    *logAllTableView;
@property (nonatomic,retain) UITableView    *logInfoTableView;
@property (nonatomic,retain) UITableView    *logErrorTableView;
@property (nonatomic,retain) UITableView    *logWarnTableView;

@property (nonatomic,retain) NSMutableArray *logAllArray;
@property (nonatomic,retain) NSMutableArray *logInfoArray;
@property (nonatomic,retain) NSMutableArray *logErrorArray;
@property (nonatomic,retain) NSMutableArray *logWarnArray;
@property (nonatomic,retain) NSMutableArray *logSearchArray;
@property BOOL judgeBack;//判断是否以执行反悔按钮操作
@property BOOL endSearch;//判断是否结束搜索了,YES:已结束搜索，NO:仍在搜索

@property (nonatomic,retain) NSString *touchCategory;//记录点击了哪一类（全部，警告，错误，信息）

@property BOOL logAllPageEnd;//记录全部上拉加载返回数据是否为最后一夜
@property BOOL logInfoPageEnd;//记录信息上拉加载返回数据是否为最后一夜
@property BOOL logErrorPageEnd;//记录错误上拉加载返回数据是否为最后一夜
@property BOOL logWarnPageEnd;//记录警告上拉加载返回数据是否为最后一夜
@property BOOL logSearchPageEnd;//记录搜索上拉加载返回数据是否为最后一夜

@property long int logAllFromID;//记录全部下一次加载数据时传入的Pagenumber
@property long int logInfoFromID;//记录信息下一次加载数据时传入的Pagenumber
@property long int logErrorFromID;//记录错误下一次加载数据时传入的Pagenumber
@property long int logWarnFromID;//记录警告下一次加载数据时传入的Pagenumber

@property (nonatomic,retain) UIButton    *buttonOne;//用来选择类别（全部，警告，错误，信息）
@property (nonatomic,retain) UIButton    *buttonTwo;//用来选择哪天（前一天）
@property (nonatomic,retain) UIButton    *buttonThr;//打开日历
@property (nonatomic,retain) UIButton    *buttonFou;//用来选择哪天（后一天）

@property (nonatomic,retain) UIImageView *btnIvOne;//第一个按钮上的箭头
@property (nonatomic,retain) UIImageView *btnIvTwo;//第二个按钮上的箭头
@property (nonatomic,retain) UIImageView *btnIvThr;//第三个按钮上的箭头

@property (nonatomic,retain) UIView *btnViewOne;//第一个按钮下拉出的菜单背景view
@property (nonatomic,retain) UIView *btnViewTwo;//第二个按钮下拉出的菜单背景view
@property (nonatomic,retain) VRGCalendarView *btnViewThr;//第三个按钮下拉出的菜单背景view

@property BOOL buttonOneOpen;
@property BOOL buttonTwoOpen;
@property BOOL buttonThrOpen;

@property (nonatomic,retain) UITableView *tableViewOne;//第一个按钮下拉出的菜单列表

@property (nonatomic,retain) UIView *coverView;


@end
