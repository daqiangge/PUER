//
//  LogQueryViewController.m
//  GOBO
//
//  Created by admin on 14/11/14.
//  Copyright (c) 2014年 蝶尚软件. All rights reserved.
//

#import "LogQueryViewController.h"
#import "LogTableViewCell.h"
#import "LogArrayNilTableViewCell.h"

#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define LogTableHeadView_height 40


@interface LogQueryViewController ()

@end

@implementation LogQueryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    _logAllArray       = [[NSMutableArray alloc] initWithArray:[ud objectForKey:@"logAllArray"]];
    _logInfoArray      = [[NSMutableArray alloc] initWithArray:[ud objectForKey:@"logInfoArray"]];
    _logErrorArray     = [[NSMutableArray alloc] initWithArray:[ud objectForKey:@"logErrorArray"]];
    _logWarnArray      = [[NSMutableArray alloc] initWithArray:[ud objectForKey:@"logWarnArray"]];
    _logSearchArray    = [[NSMutableArray alloc] init];
    _judgeBack         = NO;
    _logAllPageEnd     = NO;
    _logInfoPageEnd    = NO;
    _logErrorPageEnd   = NO;
    _logWarnPageEnd    = NO;
    _logSearchPageEnd  = NO;
    _endSearch         = YES;
    _touchCategory     = @"all";
    
    
    [super menuButton:@"日志查询"];
    [self doLoading];
    [self LogTableHeadView];
    [self initSearchBar];
    [self firstRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (self.view.window == nil) {
        self.view = nil;
    }
}

- (void)doLoading
{
    _backgroundView = [[UIView alloc] init];
    _backgroundView.frame = CGRectMake(0, NavgationBarAndStareBar_height+44, SCREEN_WIDTH, SCREEN_HEIGHT-NavgationBarAndStareBar_height-44);
    _backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backgroundView];
    
    //日志--------全部（列表）
    _logAllTableView = [[UITableView alloc] init];
    self.logAllTableView.frame = CGRectMake(0, LogTableHeadView_height, SCREEN_WIDTH, _backgroundView.frame.size.height-LogTableHeadView_height);
    self.logAllTableView.delegate = self;
    self.logAllTableView.dataSource = self;
    self.logAllTableView.tag = 52;
    self.logAllTableView.hidden = NO;
    [self.logAllTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [_backgroundView addSubview:self.logAllTableView];
    
    [self.logAllTableView addHeaderWithTarget:self action:@selector(logAllHeaderRefreshingRequset)];
    [self.logAllTableView addFooterWithTarget:self action:@selector(logAllFooterRefreshingRequest)];
    
    
    //日志--------信息（列表）
    _logInfoTableView = [[UITableView alloc] init];
    self.logInfoTableView.frame = self.logAllTableView.frame;
    self.logInfoTableView.delegate = self;
    self.logInfoTableView.dataSource = self;
    self.logInfoTableView.tag = 52+1;
    self.logInfoTableView.hidden = YES;
    [self.logInfoTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [_backgroundView addSubview:self.logInfoTableView];
    
    [self.logInfoTableView addHeaderWithTarget:self action:@selector(logInfoHeaderRefreshingRequset)];
    [self.logInfoTableView addFooterWithTarget:self action:@selector(logInfoFooterRefreshingRequest)];
    
    
    //日志--------错误（列表）
    _logErrorTableView = [[UITableView alloc] init];
    self.logErrorTableView.frame = self.logAllTableView.frame;
    self.logErrorTableView.delegate = self;
    self.logErrorTableView.dataSource = self;
    self.logErrorTableView.tag = 52+2;
    self.logErrorTableView.hidden = YES;
    [self.logErrorTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [_backgroundView addSubview:self.logErrorTableView];
    
    [self.logErrorTableView addHeaderWithTarget:self action:@selector(logErrorHeaderRefreshingRequset)];
    [self.logErrorTableView addFooterWithTarget:self action:@selector(logErrorFooterRefreshingRequest)];
    
    
    //日志--------警告（列表）
    _logWarnTableView = [[UITableView alloc] init];
    self.logWarnTableView.frame = self.logAllTableView.frame;
    self.logWarnTableView.delegate = self;
    self.logWarnTableView.dataSource = self;
    self.logWarnTableView.tag = 52+3;
    self.logWarnTableView.hidden = YES;
    [self.logWarnTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [_backgroundView addSubview:self.logWarnTableView];
    
    [self.logWarnTableView addHeaderWithTarget:self action:@selector(logWarnHeaderRefreshingRequset)];
    [self.logWarnTableView addFooterWithTarget:self action:@selector(logWarnFooterRefreshingRequest)];
    
    _coverView = [[UIView alloc] init];
    self.coverView.backgroundColor = [UIColor blackColor];
    self.coverView.alpha           = 0.0;
    self.coverView.frame           = self.logAllTableView.frame;
    [_backgroundView addSubview:self.coverView];
    
    [self dropDownMeun];
    
    //设置点击空白处释放键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideDropDownMenu)];
    tapGestureRecognizer.numberOfTapsRequired = 1; // * 点击空白处几下
    tapGestureRecognizer.delegate = self;
    [self.coverView addGestureRecognizer:tapGestureRecognizer];
    
    
    
    //给tableview注册一个cell模板
    NSString *identifer=@"LogTableViewCell";
    UINib *nib=[UINib nibWithNibName:@"LogTableViewCell" bundle:nil];
    [_logAllTableView registerNib:nib forCellReuseIdentifier:identifer];
    [_logInfoTableView registerNib:nib forCellReuseIdentifier:identifer];
    [_logErrorTableView registerNib:nib forCellReuseIdentifier:identifer];
    [_logWarnTableView registerNib:nib forCellReuseIdentifier:identifer];
    
    //给tableview注册一个cell模板
    NSString *identifer2=@"LogArrayNilTableViewCell";
    UINib *nib2=[UINib nibWithNibName:@"LogArrayNilTableViewCell" bundle:nil];
    [_logAllTableView registerNib:nib2 forCellReuseIdentifier:identifer2];
    [_logInfoTableView registerNib:nib2 forCellReuseIdentifier:identifer2];
    [_logErrorTableView registerNib:nib2 forCellReuseIdentifier:identifer2];
    [_logWarnTableView registerNib:nib2 forCellReuseIdentifier:identifer2];
}

//下拉菜单的tableview列表
- (void)dropDownMeun
{
    //弹出的菜单列表
    //第一个按钮下拉出的菜单背景view
    _btnViewOne                     = [[UIView alloc] initWithFrame:CGRectMake(1, _logAllTableView.frame.origin.y-120, SCREEN_WIDTH/3-4, 120)];
    [_backgroundView addSubview:self.btnViewOne];
    
    //第三个按钮下拉出的菜单背景view
    _btnViewThr                     = [[VRGCalendarView alloc] init];
    _btnViewThr.frame = CGRectMake(SCREEN_WIDTH-260,  _logAllTableView.frame.origin.y-350, 260, 0);
    _btnViewThr.delegate=self;
    [_backgroundView addSubview:self.btnViewThr];
    
    //    //遮盖在导航栏下的View
    //    UIView *coverView         = [[UIView alloc] init];
    //    coverView.frame           = CGRectMake(0, 0, SCREEN_WIDTH, NavgationBarAndStareBar_height);
    //    coverView.backgroundColor = [UIColor whiteColor];
    //    [_backgroundView addSubview:coverView];
    
    //第一个按钮下拉出的菜单列表
    _tableViewOne = [[UITableView alloc] init];
    self.tableViewOne.frame         = CGRectMake(0, 0, self.btnViewOne.frame.size.width, self.btnViewOne.frame.size.height);
    self.tableViewOne.delegate      = self;
    self.tableViewOne.dataSource    = self;
    self.tableViewOne.tag           = 50;
    self.tableViewOne.scrollEnabled = NO;
    self.tableViewOne.layer.borderColor = [UIColor grayColor].CGColor;
    self.tableViewOne.layer.borderWidth = 0.5;
    [self.tableViewOne setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.tableViewOne selectRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                               inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self.btnViewOne addSubview:self.tableViewOne];
    
    [self dropDownCalendar];
}

//下拉菜单的日历
- (void)dropDownCalendar
{
    //获取当前时间
    NSDate *  senddate = [NSDate date];
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [dateformatter stringFromDate:senddate];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:dateTime forKey:@"currentDate"];
    [ud synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"VVVV" object:nil];
}

//列表的头
- (void)LogTableHeadView
{
    
    UIView *attributeNameView = [[UIView alloc] init];
    attributeNameView.frame   = CGRectMake(0, 0, SCREEN_WIDTH, LogTableHeadView_height);
    attributeNameView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    [_backgroundView addSubview:attributeNameView];
    
    //设置所有按钮菜单的状态为NO，表示关闭状态
    _buttonOneOpen = NO;
    _buttonTwoOpen = NO;
    _buttonThrOpen = NO;
    
    //选项菜单按钮一（用来选择类别（全部，警告，错误，信息））
    _buttonOne = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH/3)-20*Proportion_width, LogTableHeadView_height)];
    [self.buttonOne setBackgroundImage:[UIImage imageNamed:@"highlightedbg.png"] forState:UIControlStateHighlighted];
    [self.buttonOne setTitle:@"全部" forState:UIControlStateNormal];
    [self.buttonOne setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.buttonOne.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.buttonOne addTarget:self action:@selector(touchButtonOne) forControlEvents:UIControlEventTouchUpInside];
    [attributeNameView addSubview:self.buttonOne];
    
    //选项菜单按钮二（用来选择哪天（前一天，后一天，今天））
    _buttonTwo = [[UIButton alloc] initWithFrame:CGRectMake(self.buttonOne.frame.origin.x+self.buttonOne.frame.size.width+20*Proportion_width, 0, (SCREEN_WIDTH/3)/2, LogTableHeadView_height)];
    [self.buttonTwo setBackgroundImage:[UIImage imageNamed:@"highlightedbg.png"] forState:UIControlStateHighlighted];
    [self.buttonTwo setTitle:@"前一天" forState:UIControlStateNormal];
    [self.buttonTwo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.buttonTwo.titleLabel.font = self.buttonOne.titleLabel.font;
    [self.buttonTwo addTarget:self action:@selector(touchButtonTwo) forControlEvents:UIControlEventTouchUpInside];
    [attributeNameView addSubview:self.buttonTwo];
    
    //选项菜单按钮三（打开日历）
    _buttonThr = [[UIButton alloc] initWithFrame:CGRectMake(self.buttonTwo.frame.origin.x+self.buttonTwo.frame.size.width,0, SCREEN_WIDTH/3, LogTableHeadView_height)];
    [self.buttonThr setBackgroundImage:[UIImage imageNamed:@"highlightedbg.png"] forState:UIControlStateHighlighted];
    [self.buttonThr setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentDate"] forState:UIControlStateNormal];
    [self.buttonThr setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.buttonThr.titleLabel.font = self.buttonOne.titleLabel.font;
    [self.buttonThr addTarget:self action:@selector(touchButtonThr) forControlEvents:UIControlEventTouchUpInside];
    [attributeNameView addSubview:self.buttonThr];
    
    //选项菜单按钮二（用来选择哪天（前一天，后一天，今天））
    _buttonFou = [[UIButton alloc] initWithFrame:CGRectMake(self.buttonThr.frame.origin.x+self.buttonThr.frame.size.width, 0, (SCREEN_WIDTH/3)/2, LogTableHeadView_height)];
    [self.buttonFou setBackgroundImage:[UIImage imageNamed:@"highlightedbg.png"] forState:UIControlStateHighlighted];
    [self.buttonFou setTitle:@"后一天" forState:UIControlStateNormal];
    [self.buttonFou setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.buttonFou.titleLabel.font = self.buttonOne.titleLabel.font;
    [self.buttonFou addTarget:self action:@selector(touchButtonFou) forControlEvents:UIControlEventTouchUpInside];
    [attributeNameView addSubview:self.buttonFou];
    
    //按钮上的箭头
    _btnIvOne = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3-LogTableHeadView_height , LogTableHeadView_height-15, 8, 8)];
    [self.btnIvOne setImage:[UIImage imageNamed:@"sj.png"]];
    [self.btnIvOne setContentMode:UIViewContentModeScaleToFill];
    [self.buttonOne addSubview:self.btnIvOne];
    
    _btnIvThr = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3-15 , LogTableHeadView_height-15, 8, 8)];
    [self.btnIvThr setImage:[UIImage imageNamed:@"sj.png"]];
    [self.btnIvThr setContentMode:UIViewContentModeScaleToFill];
    [self.buttonThr addSubview:self.btnIvThr];
    
    //装饰的分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, LogTableHeadView_height-0.5, SCREEN_WIDTH, 0.5);
    lineView.backgroundColor = [UIColor lightGrayColor];
    [attributeNameView addSubview:lineView];
    
}

//初始化搜索控件
- (void)initSearchBar
{
    _searchBar = [[LQSearchBar alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 64)];
    _searchBar.searchBar.delegate = self;
    [self.view addSubview:_searchBar];
}

#pragma mark - 下啦菜单的按钮的操作
- (void)touchButtonOne
{
    //如果按钮一的状态为NO，点击按钮一是打开按钮一的菜单，并将安妮一的状态改为Yes，以及其他按钮菜单的庄涛为NO
    //如果按钮一的状态为Yes，则点击按钮一时，关闭按钮一的菜单，并将状态改为No
    if (!self.buttonOneOpen) {
        
        self.btnViewThr.frame = CGRectMake(self.btnViewThr.frame.origin.x, _logAllTableView.frame.origin.y-350, self.btnViewThr.frame.size.width, self.btnViewThr.frame.size.height);
        self.buttonTwoOpen = NO;
        self.buttonThrOpen = NO;
        
        self.buttonOneOpen = YES;
        [UIView animateWithDuration:0.3 animations:^{
            
            //将遮盖view的透明度设置为0.5，防止用户滑动列表
            self.coverView.alpha           = 0.5;
            
            self.btnViewOne.frame = CGRectMake(0, _logAllTableView.frame.origin.y,   self.btnViewOne.frame.size.height, self.btnViewOne.frame.size.height);
        }];
    }else {
        
        self.buttonOneOpen = NO;
        [UIView animateWithDuration:0.3 animations:^{
            
            //将遮盖view的透明度设置为0.0
            self.coverView.alpha           = 0.0;
            
            self.btnViewOne.frame = CGRectMake(0, _logAllTableView.frame.origin.y-self.btnViewOne.frame.size.height,  self.btnViewOne.frame.size.height,  self.btnViewOne.frame.size.height);
        }];
    }
}

- (void)touchButtonTwo
{
    [self hideDropDownMenu];
    
    //获取前一天日期
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1         = [dateformatter dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentDate"]];
    NSDate *date2         = [[NSDate alloc] initWithTimeInterval:-86400 sinceDate:date1];
    NSString *date2String = [dateformatter stringFromDate:date2];
    [[NSUserDefaults standardUserDefaults] setObject:date2String forKey:@"currentDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"theDayBeforeOrAfter" object:nil];
    
    [self.buttonThr setTitle:date2String forState:UIControlStateNormal];
}

- (void)touchButtonThr
{
    //如果按钮三的状态为NO，点击按钮三打开按钮一的菜单，并将安妮三的状态改为Yes，以及其他按钮菜单的庄涛为NO
    //如果按钮三的状态为Yes，则点击按钮三时，关闭按钮三的菜单，并将状态改为No
    if (!self.buttonThrOpen) {
        
        self.btnViewOne.frame = CGRectMake(0, _logAllTableView.frame.origin.y-self.btnViewOne.frame.size.height,  self.btnViewOne.frame.size.height,  self.btnViewOne.frame.size.height);
        self.buttonOneOpen = NO;
        self.buttonTwoOpen = NO;
        
        self.buttonThrOpen = YES;
        [UIView animateWithDuration:0.3 animations:^{
            
            //将遮盖view的透明度设置为0.5，防止用户滑动列表
            self.coverView.alpha           = 0.5;
            
            self.btnViewThr.frame = CGRectMake(self.btnViewThr.frame.origin.x, _logAllTableView.frame.origin.y+1, self.btnViewThr.frame.size.width, self.btnViewThr.frame.size.height);
        }];
    }else {
        
        self.buttonThrOpen = NO;
        [UIView animateWithDuration:0.3 animations:^{
            
            //将遮盖view的透明度设置为0
            self.coverView.alpha           = 0.0;
            
            self.btnViewThr.frame = CGRectMake(self.btnViewThr.frame.origin.x, _logAllTableView.frame.origin.y-350, self.btnViewThr.frame.size.width, self.btnViewThr.frame.size.height);
        }];
    }
    
}

- (void)touchButtonFou
{
    [self hideDropDownMenu];
    
    //获取后一天日期
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1         = [dateformatter dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentDate"]];
    NSDate *date2         = [[NSDate alloc] initWithTimeInterval:86400 sinceDate:date1];
    NSString *date2String = [dateformatter stringFromDate:date2];
    [[NSUserDefaults standardUserDefaults] setObject:date2String forKey:@"currentDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"theDayBeforeOrAfter" object:nil];
    
    [self.buttonThr setTitle:date2String forState:UIControlStateNormal];
}

#pragma mark - 隐藏下啦的菜单
- (void)hideDropDownMenu
{
    //关闭所有按钮菜单，并将状态都改为NO
    self.buttonOneOpen = NO;
    self.buttonTwoOpen = NO;
    self.buttonThrOpen = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.coverView.alpha = 0.0;
        
        self.btnViewOne.frame = CGRectMake(self.btnViewOne.frame.origin.x, _logAllTableView.frame.origin.y-120, self.btnViewOne.frame.size.width, self.btnViewOne.frame.size.height);
        self.btnViewThr.frame = CGRectMake(self.btnViewThr.frame.origin.x, _logAllTableView.frame.origin.y-350, self.btnViewThr.frame.size.width, self.btnViewThr.frame.size.height);
    }];
}

#pragma mark - TableView Delegte
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _searchBar.searchBarTableView) {
        //如果已经是最后一页了，则多添加一行，用于显示“已显示所有内容”或“无内容”
        if (_logSearchPageEnd) {
            return _logSearchArray.count+1;
        }else {
            return _logSearchArray.count;
        }
    }else if (tableView == _tableViewOne) {
        return 4;
    }else if (tableView == _logAllTableView) {
        //如果已经是最后一页了，则多添加一行，用于显示“已显示所有内容”或“无内容”
        if (self.logAllPageEnd) {
            return self.logAllArray.count+1;
        }else {
            return self.logAllArray.count;
        }
    }else if (tableView == _logInfoTableView) {
        //如果已经是最后一页了，则多添加一行，用于显示“已显示所有内容”或“无内容”
        if (self.logInfoPageEnd ) {
            return self.logInfoArray.count+1;
        }else {
            return self.logInfoArray.count;
        }
        
    }else if (tableView == _logErrorTableView) {
        //如果已经是最后一页了，则多添加一行，用于显示“已显示所有内容”或“无内容”
        if (self.logErrorPageEnd ) {
            return self.logErrorArray.count+1;
        }else {
            return self.logErrorArray.count;
        }
        
    }else {
        //如果已经是最后一页了，则多添加一行，用于显示“已显示所有内容”或“无内容”
        if (self.logWarnPageEnd ) {
            return self.logWarnArray.count+1;
        }else {
            return self.logWarnArray.count;
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _searchBar.searchBarTableView) {
        
        //各个日志列表
        static NSString *idenifier = @"LogSearchTableViewCell";
        LogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (_logSearchArray.count == 0) {
            
            static NSString *idenifier2 = @"LogSearchArrayNilTableViewCell";
            LogArrayNilTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.lable.text = @"无内容";
            
            return cell;
            
        }else if (indexPath.row < _logSearchArray.count) {
            
            [cell setContentTextViewHeight:[_logSearchArray[indexPath.row] objectForKey:@"note"]];
            [cell setViewAttribute:[_logSearchArray[indexPath.row] objectForKey:@"type"]];
            
            cell.IDLable.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
            cell.timeLable.text = [_logSearchArray[indexPath.row] objectForKey:@"time"];
            cell.contentLable.text = [_logSearchArray[indexPath.row] objectForKey:@"note"];
            
            return cell;
            
        }else {
            
            if (_logSearchPageEnd && _logSearchArray.count != 0) {
                
                static NSString *idenifier2 = @"LogSearchArrayNilTableViewCell";
                LogArrayNilTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier2];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.lable.text = @"已显示所有内容";
                return cell;
            }
        }
        return cell;
        
    }else if (tableView == _tableViewOne) {
        
        static NSString *idenifierOne = @"oneCell";
        UITableViewCell *oneCell = [tableView dequeueReusableCellWithIdentifier:idenifierOne];
        if (oneCell == nil) {
            oneCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenifierOne];
        }
        NSArray *array = @[@"全部",@"信息",@"错误",@"警告"];
        
        UILabel *lable = [[UILabel alloc] init];
        lable.frame = CGRectMake(0, 0, self.btnViewOne.frame.size.width, 30);
        lable.font  = [UIFont systemFontOfSize:15];
        lable.textAlignment = NSTextAlignmentCenter;
        [oneCell addSubview:lable];
        
        lable.text = array[indexPath.row];
        
        return oneCell;
    }
    
    //各个日志列表
    static NSString *idenifier = @"LogTableViewCell";
    LogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (tableView == _logAllTableView) {
        
        if (self.logAllArray.count == 0) {
            
            static NSString *idenifier2 = @"LogArrayNilTableViewCell";
            LogArrayNilTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.lable.text = @"无内容";
            
            return cell;
            
        }else if (indexPath.row < self.logAllArray.count) {
            
            [cell setContentTextViewHeight:[_logAllArray[indexPath.row] objectForKey:@"note"]];
            [cell setViewAttribute:[_logAllArray[indexPath.row] objectForKey:@"type"]];
            
            cell.IDLable.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
            cell.timeLable.text = [_logAllArray[indexPath.row] objectForKey:@"time"];
            cell.contentLable.text = [_logAllArray[indexPath.row] objectForKey:@"note"];
            
            return cell;
            
        }else {
            
            if (self.logAllPageEnd && self.logAllArray.count != 0) {
                
                static NSString *idenifier2 = @"LogArrayNilTableViewCell";
                LogArrayNilTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier2];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.lable.text = @"已显示所有内容";
                return cell;
            }
        }
        return cell;
        
    }else if (tableView == _logInfoTableView) {
        
        if (self.logInfoArray.count == 0) {
            
            static NSString *idenifier2 = @"LogArrayNilTableViewCell";
            LogArrayNilTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.lable.text = @"无内容";
            
            return cell;
            
        }else if (indexPath.row < self.logInfoArray.count) {
            
            [cell setContentTextViewHeight:[_logInfoArray[indexPath.row] objectForKey:@"note"]];
            [cell setViewAttribute:[_logInfoArray[indexPath.row] objectForKey:@"type"]];
            
            cell.IDLable.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
            cell.timeLable.text = [_logInfoArray[indexPath.row] objectForKey:@"time"];
            cell.contentLable.text = [_logInfoArray[indexPath.row] objectForKey:@"note"];
            
            return cell;
            
        }else {
            
            if (self.logInfoPageEnd && self.logInfoArray.count != 0) {
                
                static NSString *idenifier2 = @"LogArrayNilTableViewCell";
                LogArrayNilTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier2];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.lable.text = @"已显示所有内容";
                
                return cell;
            }
            return cell;
        }
        
    }else if (tableView == _logErrorTableView) {
        
        if (self.logErrorArray.count == 0) {
            
            static NSString *idenifier2 = @"LogArrayNilTableViewCell";
            LogArrayNilTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.lable.text = @"无内容";
            
            return cell;
            
        }else if (indexPath.row < self.logErrorArray.count) {
            
            [cell setContentTextViewHeight:[_logErrorArray[indexPath.row] objectForKey:@"note"]];
            [cell setViewAttribute:[_logErrorArray[indexPath.row] objectForKey:@"type"]];
            
            cell.IDLable.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
            cell.timeLable.text = [_logErrorArray[indexPath.row] objectForKey:@"time"];
            cell.contentLable.text = [_logErrorArray[indexPath.row] objectForKey:@"note"];
            
            return cell;
            
        }else {
            
            if (self.logErrorPageEnd && self.logErrorArray.count != 0) {
                
                static NSString *idenifier2 = @"LogArrayNilTableViewCell";
                LogArrayNilTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier2];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.lable.text = @"已显示所有内容";
                
                return cell;
            }
            return cell;
        }
        
    }else {
        
        if (self.logWarnArray.count == 0) {
            
            static NSString *idenifier2 = @"LogArrayNilTableViewCell";
            LogArrayNilTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.lable.text = @"无内容";
            
            return cell;
            
        }else if (indexPath.row < self.logWarnArray.count) {
            
            [cell setContentTextViewHeight:[_logWarnArray[indexPath.row] objectForKey:@"note"]];
            [cell setViewAttribute:[_logWarnArray[indexPath.row] objectForKey:@"type"]];
            
            cell.IDLable.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
            cell.timeLable.text = [_logWarnArray[indexPath.row] objectForKey:@"time"];
            cell.contentLable.text = [_logWarnArray[indexPath.row] objectForKey:@"note"];
            
            return cell;
            
        }else {
            
            if (self.logWarnPageEnd && self.logWarnArray.count != 0) {
                
                static NSString *idenifier2 = @"LogArrayNilTableViewCell";
                LogArrayNilTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier2];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.lable.text = @"已显示所有内容";
                
                return cell;
            }
            return cell;
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _searchBar.searchBarTableView) {
        
        if (indexPath.row < _logSearchArray.count) {
            return [LogTableViewCell calculateHeight:[_logSearchArray[indexPath.row] objectForKey:@"note"]];
        }else {
            if (_logSearchPageEnd && _logSearchArray.count != 0) {
                return 50;
            }
            return 50;
        }
    }else if (tableView == _tableViewOne) {
        
        return 30;
        
    }else if (tableView == _logAllTableView) {
        
        if (indexPath.row < self.logAllArray.count) {
            return [LogTableViewCell calculateHeight:[self.logAllArray[indexPath.row] objectForKey:@"note"]];
        }else {
            if (self.logAllPageEnd && self.logAllArray.count != 0) {
                return 50;
            }
            return 50;
        }
    }else if (tableView == _logInfoTableView) {
        
        if (indexPath.row < self.logInfoArray.count) {
            return [LogTableViewCell calculateHeight:[self.logInfoArray[indexPath.row] objectForKey:@"note"]];
        }else {
            if (self.logInfoPageEnd && self.logInfoArray.count != 0) {
                return 50;
            }
            return 50;
        }
    }else if (tableView == _logErrorTableView) {
        
        if (indexPath.row < self.logErrorArray.count) {
            return [LogTableViewCell calculateHeight:[self.logErrorArray[indexPath.row] objectForKey:@"note"]];
        }else {
            if (self.logErrorPageEnd && self.logErrorArray.count != 0) {
                return 50;
            }
            return 50;
        }
    }else{
        
        if (indexPath.row < self.logWarnArray.count) {
            return [LogTableViewCell calculateHeight:[self.logWarnArray[indexPath.row] objectForKey:@"note"]];
        }else {
            if (self.logWarnPageEnd && self.logWarnArray.count != 0) {
                return 50;
            }
            return 50;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击了所对应的行，就讲所对应的列表显示出来，其他列表则隐藏，并且改变他们的按钮菜单的状态
    if (tableView == _tableViewOne) {
        switch (indexPath.row) {
            case 0:
            {
                [self.buttonOne setTitle:@"全部" forState:UIControlStateNormal];
                
                if (![self.touchCategory isEqualToString:@"all"]) {
                    
                    self.logAllTableView.hidden   = NO;
                    self.logInfoTableView.hidden  = YES;
                    self.logErrorTableView.hidden = YES;
                    self.logWarnTableView.hidden  = YES;
                    self.touchCategory = @"all";
                    [self firstRefresh];
                }
                [self hideDropDownMenu];
            }
                break;
                
            case 1:
            {
                [self.buttonOne setTitle:@"信息" forState:UIControlStateNormal];
                
                if (![self.touchCategory isEqualToString:@"info"]) {
                    
                    self.logAllTableView.hidden   = YES;
                    self.logInfoTableView.hidden  = NO;
                    self.logErrorTableView.hidden = YES;
                    self.logWarnTableView.hidden  = YES;
                    self.touchCategory = @"info";
                    [self firstRefresh];
                }
                [self hideDropDownMenu];
            }
                break;
                
            case 2:
            {
                [self.buttonOne setTitle:@"错误" forState:UIControlStateNormal];
                
                if (![self.touchCategory isEqualToString:@"error"]) {
                    
                    self.logAllTableView.hidden   = YES;
                    self.logInfoTableView.hidden  = YES;
                    self.logErrorTableView.hidden = NO;
                    self.logWarnTableView.hidden  = YES;
                    self.touchCategory = @"error";
                    [self firstRefresh];
                }
                [self hideDropDownMenu];
            }
                break;
                
            case 3:
            {
                [self.buttonOne setTitle:@"警告" forState:UIControlStateNormal];
                
                if (![self.touchCategory isEqualToString:@"warn"]) {
                    
                    self.logAllTableView.hidden   = YES;
                    self.logInfoTableView.hidden  = YES;
                    self.logErrorTableView.hidden = YES;
                    self.logWarnTableView.hidden  = NO;
                    self.touchCategory = @"warn";
                    [self firstRefresh];
                }
                [self hideDropDownMenu];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - 设置了tableview的分割线
-(void)viewDidLayoutSubviews
{
    if ([self.logAllTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.logAllTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([self.logAllTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.logAllTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.logInfoTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.logInfoTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([self.logInfoTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.logInfoTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    
    if ([self.logErrorTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.logErrorTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([self.logErrorTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.logErrorTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    
    if ([self.logWarnTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.logWarnTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([self.logWarnTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.logWarnTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableViewOne respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableViewOne setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([self.tableViewOne respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableViewOne setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_searchBar.searchBarTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_searchBar.searchBarTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([_searchBar.searchBarTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_searchBar.searchBarTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark - SearchBar Delegate
//取消搜索
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    _endSearch = YES;
    
    [_searchBar cancleSearchBar];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [_logSearchArray removeAllObjects];
    [_searchBar.searchBarTableView reloadData];
    
    //下面的列表回复原始位置
    [UIView animateWithDuration:0.2 animations:^{
        _backgroundView.frame = CGRectMake(0, NavgationBarAndStareBar_height+44, _backgroundView.frame.size.width, _backgroundView.frame.size.height-44);
    }];
}

//开始搜索
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    _endSearch = NO;
    
    [_searchBar openSearchBar];
    
    //隐藏navigationbar
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //下面的列表跟着searchbar移动
    [UIView animateWithDuration:0.2 animations:^{
        _backgroundView.frame = CGRectMake(0, NavgationBarAndStareBar_height, _backgroundView.frame.size.width, _backgroundView.frame.size.height+44);
    }];
    
    [_searchBar.tapGR addTarget:self action:@selector(searchBarCancelButtonClicked:)];
    _searchBar.searchBarTableView.delegate = self;
    _searchBar.searchBarTableView.dataSource = self;
    
    //注册一个cell模板
    NSString *identifer=@"LogSearchTableViewCell";
    UINib *nib=[UINib nibWithNibName:@"LogTableViewCell" bundle:nil];
    [_searchBar.searchBarTableView registerNib:nib forCellReuseIdentifier:identifer];
    
    //注册一个cell模板
    NSString *identifer2=@"LogSearchArrayNilTableViewCell";
    UINib *nib2=[UINib nibWithNibName:@"LogArrayNilTableViewCell" bundle:nil];
    [_searchBar.searchBarTableView registerNib:nib2 forCellReuseIdentifier:identifer2];
    
    [_searchBar.searchBarTableView addFooterWithTarget:self action:@selector(searchBarFooterRequest)];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""]) {
        [_searchBar hideSearchBarTableView];
    }else {
        [_searchBar showSearchBarTableView];
    }
    
    _endSearch = YES;
    [_logSearchArray removeAllObjects];
    [_searchBar.searchBarTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchBarHeaderRequest];
    
    [_searchBar.searchBar resignFirstResponder];
    
    //强制取消按钮可使用
    //ios7.0之后的searchBar遍历只有一个UINavigationButton的按钮
    for(id cc in [searchBar subviews])
    {
        for (UIView *view in [cc subviews]) {
            if ([NSStringFromClass(view.class)   isEqualToString:@"UINavigationButton"]) {
                UIButton *btn = (UIButton *)view;
                btn.enabled = YES;
            }
        }
    }
}

#pragma mark - calendar Delegate 日历
-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated
{
    
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'"];
    NSString *s = [dateFormatter stringFromDate:date];
    
    [[NSUserDefaults standardUserDefaults] setObject:s forKey:@"currentDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.buttonThr setTitle:s forState:UIControlStateNormal];
    [self hideDropDownMenu];
    [self firstRefresh];
    
}

#pragma mark - 网络刷新请求
- (void)firstRefresh
{
    if ([self.touchCategory isEqualToString:@"all"]) {
        // 自动刷新(一进入程序就下拉刷新)
        [self.logAllTableView headerBeginRefreshing];
    }else if ([self.touchCategory isEqualToString:@"info"]) {
        // 自动刷新(一进入程序就下拉刷新)
        [self.logInfoTableView headerBeginRefreshing];
    }else if ([self.touchCategory isEqualToString:@"error"]) {
        // 自动刷新(一进入程序就下拉刷新)
        [self.logErrorTableView headerBeginRefreshing];
    }else if ([self.touchCategory isEqualToString:@"warn"]) {
        // 自动刷新(一进入程序就下拉刷新)
        [self.logWarnTableView headerBeginRefreshing];
    }
    
}

- (void)headerRefreshingRequset:(NSString *)category
{
    self.buttonOne.enabled = NO;
    self.buttonTwo.enabled = NO;
    self.buttonThr.enabled = NO;
    self.buttonFou.enabled = NO;
    
    if ([category isEqualToString:@"all"]) {
        _logAllPageEnd     = NO;
    }else if ([category isEqualToString:@"info"]) {
        _logInfoPageEnd    = NO;
    }else if ([category isEqualToString:@"error"]) {
        _logErrorPageEnd   = NO;
    }else if ([category isEqualToString:@"warn"])  {
        _logWarnPageEnd    = NO;
    }
    
    NSString *logDay   = self.buttonThr.titleLabel.text;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/adminmanager/do/log/getlogmore.do?LogDay=%@&LogType=%@&fromid=0&PageSize=50;sessionid=%@",[[IpAndOther shareInstance] getIP],[[IpAndOther shareInstance] getPort],logDay,category,[[IpAndOther shareInstance] getSid]]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:20];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            
            if ([category isEqualToString:@"all"]) {
                //如果返回的数据中pagenumber与pagecount相同，则说明，这组数据为所用数据的最后一页
                if ([[[resultDic objectForKey:@"data"]objectForKey:@"loglist"] count] < 50) {
                    self.logAllPageEnd = YES;
                }
                [self.logAllArray removeAllObjects];
            }else if ([category isEqualToString:@"info"]) {
                //如果返回的数据中pagenumber与pagecount相同，则说明，这组数据为所用数据的最后一页
                if ([[[resultDic objectForKey:@"data"]objectForKey:@"loglist"] count] < 50) {
                    self.logInfoPageEnd = YES;
                }
                [self.logInfoArray removeAllObjects];
            }else if ([category isEqualToString:@"error"]) {
                //如果返回的数据中pagenumber与pagecount相同，则说明，这组数据为所用数据的最后一页
                if ([[[resultDic objectForKey:@"data"]objectForKey:@"loglist"] count] < 50) {
                    self.logErrorPageEnd = YES;
                }
                [self.logErrorArray removeAllObjects];
            }else if ([category isEqualToString:@"warn"])  {
                //如果返回的数据中pagenumber与pagecount相同，则说明，这组数据为所用数据的最后一页
                if ([[[resultDic objectForKey:@"data"]objectForKey:@"loglist"] count] < 50) {
                    self.logWarnPageEnd = YES;
                }
                [self.logWarnArray removeAllObjects];
            }
            
            if ([[[resultDic objectForKey:@"data"]objectForKey:@"loglist"] count] != 0)
            {
                for (int i = 0; i<[[[resultDic objectForKey:@"data"]objectForKey:@"loglist"] count]; i ++) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:[[[resultDic objectForKey:@"data"] objectForKey:@"loglist"][i] objectForKey:@"type"] forKey:@"type"];
                    [dic setObject:[[[resultDic objectForKey:@"data"] objectForKey:@"loglist"][i] objectForKey:@"time"] forKey:@"time"];
                    [dic setObject:[super ASCIIString:[[[resultDic objectForKey:@"data"] objectForKey:@"loglist"][i] objectForKey:@"note"]] forKey:@"note"];
                    
                    if ([category isEqualToString:@"all"]) {
                        [self.logAllArray addObject:dic];
                    }else if ([category isEqualToString:@"info"]) {
                        [self.logInfoArray addObject:dic];
                    }else if ([category isEqualToString:@"error"]) {
                        [self.logErrorArray addObject:dic];
                    }else  if ([category isEqualToString:@"warn"]) {
                        [self.logWarnArray addObject:dic];
                    }
                }
                
            }
            
            //停止0.5s后执行刷新列表，并停止刷新的动画
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([category isEqualToString:@"all"]) {
                    //保存返回的pagenumber，用于下一次获取数据url的pagenumber参数
                    [self.logAllTableView reloadData];
                    [[NSUserDefaults standardUserDefaults] setObject:self.logAllArray forKey:@"logAllArray"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }else if ([category isEqualToString:@"info"]) {
                    //保存返回的pagenumber，用于下一次获取数据url的pagenumber参数
                    [self.logInfoTableView reloadData];
                    [[NSUserDefaults standardUserDefaults] setObject:self.logInfoArray forKey:@"logInfoArray"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }else if ([category isEqualToString:@"error"]) {
                    //保存返回的pagenumber，用于下一次获取数据url的pagenumber参数
                    [self.logErrorTableView reloadData];
                    [[NSUserDefaults standardUserDefaults] setObject:self.logErrorArray forKey:@"logErrorArray"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }else  if ([category isEqualToString:@"warn"]) {
                    //保存返回的pagenumber，用于下一次获取数据url的pagenumber参数
                    [self.logWarnTableView reloadData];
                    [[NSUserDefaults standardUserDefaults] setObject:self.logWarnArray forKey:@"logWarnArray"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                [self tableHeadViewEndRefreshing];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.buttonOne.enabled = YES;
                    self.buttonTwo.enabled = YES;
                    self.buttonThr.enabled = YES;
                    self.buttonFou.enabled = YES;
                });
            });
            
        }else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"]) {
            [self tableHeadViewEndRefreshing];
            
            if (!self.judgeBack) {
                if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"]) {
                    [self.loginAgain_AlterView show];
                }else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.buttonOne.enabled = YES;
                self.buttonTwo.enabled = YES;
                self.buttonThr.enabled = YES;
                self.buttonFou.enabled = YES;
            });
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self tableHeadViewEndRefreshing];
        
        if (!self.judgeBack) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前无法连接到服务器，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.buttonOne.enabled = YES;
            self.buttonTwo.enabled = YES;
            self.buttonThr.enabled = YES;
            self.buttonFou.enabled = YES;
        });
    }];
    
    [operation start];
}

- (void)footerRefreshingRequest:(NSString *)category
{
    long int pagenumber;
    
    if ([category isEqualToString:@"all"]) {
        pagenumber = self.logAllArray.count;
    }else if ([category isEqualToString:@"info"]) {
        pagenumber = self.logInfoArray.count;
    }else if ([category isEqualToString:@"error"]) {
        pagenumber = self.logErrorArray.count;
    }else  if ([category isEqualToString:@"warn"]) {
        pagenumber = self.logWarnArray.count;
    }
    
    
    //发送保存请求
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    NSString *logDay   = self.buttonThr.titleLabel.text;
    
    NSURL *url         = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/adminmanager/do/log/getlogmore.do?LogDay=%@&LogType=%@&fromid=%ld&PageSize=50;sessionid=%@",IP,port,logDay,category,pagenumber,sid]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TimeoutInterval];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            
            if ([[[resultDic objectForKey:@"data"]objectForKey:@"loglist"] count] != 0)
            {
                
                if ([category isEqualToString:@"all"]) {//--------------------- 全部---------------------------
                    
                    //如果返回的数据中pagenumber与pagecount相同，则说明，这组数据为所用数据的最后一页
                    if ([[[resultDic objectForKey:@"data"]objectForKey:@"loglist"] count] < 50) {
                        self.logAllPageEnd = YES;
                    }else {
                        self.logAllPageEnd = NO;
                    }
                    
                    for (int i = 0; i<[[[resultDic objectForKey:@"data"]objectForKey:@"loglist"] count]; i ++) {
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                        [dic setObject:[[[resultDic objectForKey:@"data"] objectForKey:@"loglist"][i] objectForKey:@"type"] forKey:@"type"];
                        [dic setObject:[[[resultDic objectForKey:@"data"] objectForKey:@"loglist"][i] objectForKey:@"time"] forKey:@"time"];
                        [dic setObject:[super ASCIIString:[[[resultDic objectForKey:@"data"] objectForKey:@"loglist"][i] objectForKey:@"note"]] forKey:@"note"];
                        
                        [self.logAllArray addObject:dic];
                    }
                    
                    //停止0.5s后执行刷新列表，并停止刷新的动画
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.logAllTableView reloadData];
                        [self tableFooterViewEndRefreshing];
                    });
                }else if ([category isEqualToString:@"info"]) {//--------------------- 信息---------------------------
                    
                    //如果返回的数据中pagenumber与pagecount相同，则说明，这组数据为所用数据的最后一页
                    if ([[[resultDic objectForKey:@"data"]objectForKey:@"loglist"] count] < 50) {
                        self.logInfoPageEnd = YES;
                    }else {
                        self.logInfoPageEnd = NO;
                    }
                    
                    for (int i = 0; i<[[[resultDic objectForKey:@"data"]objectForKey:@"loglist"] count]; i ++) {
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                        [dic setObject:[[[resultDic objectForKey:@"data"] objectForKey:@"loglist"][i] objectForKey:@"type"] forKey:@"type"];
                        [dic setObject:[[[resultDic objectForKey:@"data"] objectForKey:@"loglist"][i] objectForKey:@"time"] forKey:@"time"];
                        [dic setObject:[super ASCIIString:[[[resultDic objectForKey:@"data"] objectForKey:@"loglist"][i] objectForKey:@"note"]] forKey:@"note"];
                        
                        [self.logInfoArray addObject:dic];
                    }
                    
                    [ud setObject:self.logInfoArray forKey:@"logInfoArray"];
                    [ud synchronize];
                    
                    //停止0.5s后执行刷新列表，并停止刷新的动画
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.logInfoTableView reloadData];
                        [self tableFooterViewEndRefreshing];
                    });
                    
                }else if ([category isEqualToString:@"error"]) {//--------------------- 错误---------------------------
                    
                    //如果返回的数据中pagenumber与pagecount相同，则说明，这组数据为所用数据的最后一页
                    if ([[[resultDic objectForKey:@"data"]objectForKey:@"loglist"] count] < 50) {
                        self.logErrorPageEnd = YES;
                    }else {
                        self.logErrorPageEnd = NO;
                    }
                    
                    for (int i = 0; i<[[[resultDic objectForKey:@"data"]objectForKey:@"loglist"] count]; i ++) {
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                        [dic setObject:[[[resultDic objectForKey:@"data"] objectForKey:@"loglist"][i] objectForKey:@"type"] forKey:@"type"];
                        [dic setObject:[[[resultDic objectForKey:@"data"] objectForKey:@"loglist"][i] objectForKey:@"time"] forKey:@"time"];
                        [dic setObject:[super ASCIIString:[[[resultDic objectForKey:@"data"] objectForKey:@"loglist"][i] objectForKey:@"note"]] forKey:@"note"];
                        
                        [self.logErrorArray addObject:dic];
                    }
                    
                    [ud setObject:self.logErrorArray forKey:@"logErrorArray"];
                    [ud synchronize];
                    
                    //停止0.5s后执行刷新列表，并停止刷新的动画
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.logErrorTableView reloadData];
                        [self tableFooterViewEndRefreshing];
                    });
                }else  if ([category isEqualToString:@"warn"]) {//--------------------- 警告---------------------------
                    
                    //如果返回的数据中pagenumber与pagecount相同，则说明，这组数据为所用数据的最后一页
                    if ([[[resultDic objectForKey:@"data"]objectForKey:@"loglist"] count] < 50) {
                        self.logWarnPageEnd = YES;
                    }else {
                        self.logWarnPageEnd = NO;
                    }
                    
                    for (int i = 0; i<[[[resultDic objectForKey:@"data"]objectForKey:@"loglist"] count]; i ++) {
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                        [dic setObject:[[[resultDic objectForKey:@"data"] objectForKey:@"loglist"][i] objectForKey:@"type"] forKey:@"type"];
                        [dic setObject:[[[resultDic objectForKey:@"data"] objectForKey:@"loglist"][i] objectForKey:@"time"] forKey:@"time"];
                        [dic setObject:[super ASCIIString:[[[resultDic objectForKey:@"data"] objectForKey:@"loglist"][i] objectForKey:@"note"]] forKey:@"note"];
                        
                        [self.logWarnArray addObject:dic];
                    }
                    
                    [ud setObject:self.logWarnArray forKey:@"logWarnArray"];
                    [ud synchronize];
                    
                    //停止0.5s后执行刷新列表，并停止刷新的动画
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.logWarnTableView reloadData];
                        [self tableFooterViewEndRefreshing];
                    });
                }
            }else {
                if ([category isEqualToString:@"all"]) {
                    
                    self.logAllPageEnd = YES;
                    
                }else if ([category isEqualToString:@"info"]) {
                    
                    self.logInfoPageEnd = YES;
                    
                }else if ([category isEqualToString:@"error"]) {
                    
                    self.logErrorPageEnd = YES;
                }else  if ([category isEqualToString:@"warn"]) {
                    
                    self.logWarnPageEnd = YES;
                }
                
                [self tableFooterViewEndRefreshing];
            }
        }
        else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"]) {
            [self tableFooterViewEndRefreshing];
            
            if (!self.judgeBack) {
                if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"]) {
                    [self.loginAgain_AlterView show];
                }else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self tableFooterViewEndRefreshing];
        
        if (!self.judgeBack) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前无法连接到服务器，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }];
    
    [operation start];
}

- (void)logAllHeaderRefreshingRequset
{
    [self headerRefreshingRequset:@"all"];
}

- (void)logInfoHeaderRefreshingRequset
{
    [self headerRefreshingRequset:@"info"];
}

- (void)logErrorHeaderRefreshingRequset
{
    [self headerRefreshingRequset:@"error"];
}

- (void)logWarnHeaderRefreshingRequset
{
    [self headerRefreshingRequset:@"warn"];
}

- (void)logAllFooterRefreshingRequest
{
    [self footerRefreshingRequest:@"all"];
}

- (void)logInfoFooterRefreshingRequest
{
    [self footerRefreshingRequest:@"info"];
}

- (void)logErrorFooterRefreshingRequest
{
    [self footerRefreshingRequest:@"error"];
}

- (void)logWarnFooterRefreshingRequest
{
    [self footerRefreshingRequest:@"warn"];
}

- (void)tableHeadViewEndRefreshing
{
    [self.logAllTableView headerEndRefreshing];
    [self.logInfoTableView headerEndRefreshing];
    [self.logErrorTableView headerEndRefreshing];
    [self.logWarnTableView headerEndRefreshing];
}

- (void)tableFooterViewEndRefreshing
{
    [self.logAllTableView footerEndRefreshing];
    [self.logInfoTableView footerEndRefreshing];
    [self.logErrorTableView footerEndRefreshing];
    [self.logWarnTableView footerEndRefreshing];
}

- (void)searchBarHeaderRequest
{
    NSString *logType;
    if ([_buttonOne.titleLabel.text isEqual:@"全部"]) {
        logType = @"all";
    }else if ([_buttonOne.titleLabel.text isEqual:@"信息"]) {
        logType = @"info";
    }else if ([_buttonOne.titleLabel.text isEqual:@"错误"]) {
        logType = @"error";
    }else if ([_buttonOne.titleLabel.text isEqual:@"警告"]) {
        logType = @"warn";
    }
    
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在搜索...";
    
    NSString *logDay   = self.buttonThr.titleLabel.text;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = TimeoutInterval;
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/log/getlogmore.do;sessionid=%@",[[IpAndOther shareInstance] getIP],[[IpAndOther shareInstance] getPort],[[IpAndOther shareInstance] getSid]];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys: logDay,@"LogDay",  logType,@"LogType", [NSNumber numberWithInt:0],@"fromid", [NSNumber numberWithInt:50],@"PageSize", _searchBar.searchBar.text,@"SearchTxt",nil];
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            
            //如果返回的数据中pagenumber与pagecount相同，则说明，这组数据为所用数据的最后一页
            if ([[[resultDic objectForKey:@"data"]objectForKey:@"loglist"] count] < 50) {
                _logSearchPageEnd = YES;
            }
            [_logSearchArray removeAllObjects];
            
            if ([[[resultDic objectForKey:@"data"]objectForKey:@"loglist"] count] != 0)
            {
                for (int i = 0; i<[[[resultDic objectForKey:@"data"]objectForKey:@"loglist"] count]; i ++) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:[[[resultDic objectForKey:@"data"] objectForKey:@"loglist"][i] objectForKey:@"type"] forKey:@"type"];
                    [dic setObject:[[[resultDic objectForKey:@"data"] objectForKey:@"loglist"][i] objectForKey:@"time"] forKey:@"time"];
                    [dic setObject:[super ASCIIString:[[[resultDic objectForKey:@"data"] objectForKey:@"loglist"][i] objectForKey:@"note"]] forKey:@"note"];
                    
                    [_logSearchArray addObject:dic];
                }
                
            }
            
            [_searchBar.searchBarTableView reloadData];
            
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            
        }else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"]) {
            
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            
            if (!_endSearch) {
                if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"]) {
                    [self.loginAgain_AlterView show];
                }else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        
        if (!_endSearch) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前无法连接到服务器，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }];
    
}

- (void)searchBarFooterRequest
{
    long int pagenumber;
    
    NSString *logType;
    if ([_buttonOne.titleLabel.text isEqual:@"全部"]) {
        logType = @"all";
    }else if ([_buttonOne.titleLabel.text isEqual:@"信息"]) {
        logType = @"info";
    }else if ([_buttonOne.titleLabel.text isEqual:@"错误"]) {
        logType = @"error";
    }else if ([_buttonOne.titleLabel.text isEqual:@"警告"]) {
        logType = @"warn";
    }
    
    pagenumber         = _logSearchArray.count;
    NSString *logDay   = self.buttonThr.titleLabel.text;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = TimeoutInterval;
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/log/getlogmore.do;sessionid=%@",[[IpAndOther shareInstance] getIP],[[IpAndOther shareInstance] getPort],[[IpAndOther shareInstance] getSid]];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       logDay,@"LogDay",
                                       logType,@"LogType",
                                       [NSNumber numberWithLong:pagenumber],@"fromid",
                                       [NSNumber numberWithInt:50],@"PageSize",
                                       _searchBar.searchBar.text,@"SearchTxt",nil];
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            
            if ([[[resultDic objectForKey:@"data"]objectForKey:@"loglist"] count] != 0)
            {
                //如果返回的数据中pagenumber与pagecount相同，则说明，这组数据为所用数据的最后一页
                if ([[[resultDic objectForKey:@"data"]objectForKey:@"loglist"] count] < 50) {
                    _logSearchPageEnd = YES;
                }else {
                    _logSearchPageEnd = NO;
                }
                
                for (int i = 0; i<[[[resultDic objectForKey:@"data"]objectForKey:@"loglist"] count]; i ++) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:[[[resultDic objectForKey:@"data"] objectForKey:@"loglist"][i] objectForKey:@"type"] forKey:@"type"];
                    [dic setObject:[[[resultDic objectForKey:@"data"] objectForKey:@"loglist"][i] objectForKey:@"time"] forKey:@"time"];
                    [dic setObject:[super ASCIIString:[[[resultDic objectForKey:@"data"] objectForKey:@"loglist"][i] objectForKey:@"note"]] forKey:@"note"];
                    
                    [_logSearchArray addObject:dic];
                }
                
                //停止0.5s后执行刷新列表，并停止刷新的动画
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_searchBar.searchBarTableView reloadData];
                    [_searchBar.searchBarTableView footerEndRefreshing];
                });
            }else {
                
                _logSearchPageEnd = YES;
                [_searchBar.searchBarTableView footerEndRefreshing];
            }
        }
        else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"]) {
            [_searchBar.searchBarTableView footerEndRefreshing];
            
            if (!_endSearch) {
                if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"]) {
                    [self.loginAgain_AlterView show];
                }else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self tableFooterViewEndRefreshing];
        
        if (!_endSearch) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前无法连接到服务器，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }];
    
    
}

#pragma mark - 离开界面
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.judgeBack = YES;
}
@end
