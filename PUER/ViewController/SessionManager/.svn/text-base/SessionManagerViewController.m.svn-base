//
//  SessionManagerViewController.m
//  PUER
//
//  Created by admin on 14-8-14.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "SessionManagerViewController.h"
#import "AlterSessionManagerViewController.h"

@interface SessionManagerViewController ()

@end

@implementation SessionManagerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showMeun" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideMeun" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMeun) name:@"showMeun" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMeun) name:@"hideMeun" object:nil];
    
    NSUserDefaults *ud         = [NSUserDefaults standardUserDefaults];
    _sessionManagerArray       = [[NSMutableArray alloc] initWithArray:[ud objectForKey:@"sessionManagerArray"]];
    _searchSessionManagerArray = [[NSMutableArray alloc] init];
    _judgeBack                 = NO;
    _headerRefreshing          = NO;
    _pageend                   = NO;
    _searchPageend             = NO;
    
    [self menuButton:@"会话管理"];
    [self doLoading];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)doLoading
{
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.searchController.searchResultsTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    
    //给列表添加耍想的头
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    
    
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //判断是否为搜索界面的tableview
    if (tableView == self.searchController.searchResultsTableView) {
        
        //如果获取的数据最后判断为最后一页，则添加最后一行，这一行用于现实“已显示所有内容”
        //如果判断的不是最后一夜，则不显示“已显示所有内容”这一行
        if (_searchPageend) {
            return self.searchSessionManagerArray.count+2;
        }
        return self.searchSessionManagerArray.count+1;
    }
    
    //判断是否为原始界面的tableview
    //如果获取的数据最后判断为最后一页，则添加最后一行，这一行用于现实“已显示所有内容”
    //如果判断的不是最后一夜，则不显示“已显示所有内容”这一行
    if (_pageend) {
        if (self.sessionManagerArray.count < 9) {
            return 10;
        }
        return self.sessionManagerArray.count+2;
    }
    
    if (self.sessionManagerArray.count < 9) {
        return 10;
    }
    return self.sessionManagerArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SessionManagerTableViewCell *sessionManagerCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (sessionManagerCell == nil) {
        sessionManagerCell  = [[SessionManagerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //判断是否为搜索界面的tableview
    if (tableView == self.searchController.searchResultsTableView) {
        
        //如果为第一行，则现实列表的标题头
        //如果判断为最后一页，并且是最后一行，则显示"已显示所有内容"，如果此时数组里没有数据，说明返回的为空，则显示"无结果"
        //如果以上条件均不满足，则正常现实数据内容
        if (indexPath.row == 0) {
            UITableViewCell *cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle    = UITableViewCellSelectionStyleNone;
            
            [cell addSubview:[self sessionManagerTableViewHeadView]];
            
            return cell;
            
        }else if (_searchPageend == YES && indexPath.row == self.searchSessionManagerArray.count+1) {
            UITableViewCell *cell   = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            
            UILabel *lable          = [[UILabel alloc] init];
            lable.frame             = CGRectMake(0, 0, SCREEN_WIDTH, sessionManagerCell.frame.size.height);
            if (self.searchSessionManagerArray.count == 0) {
                lable.text          = @"无结果";
            }else {
                lable.text          = @"已显示所有内容";
            }
            lable.alpha             = 0.5;
            lable.font              = [UIFont systemFontOfSize:17];
            lable.textAlignment     = NSTextAlignmentCenter;
            [cell addSubview:lable];
            return cell;
            
        } else if (self.searchSessionManagerArray.count != 0) {
            sessionManagerCell.IDLable.text            = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            sessionManagerCell.delegate                = self;
            sessionManagerCell.nameLable.text          = [self.searchSessionManagerArray[indexPath.row-1] objectForKey:@"project"];
            sessionManagerCell.IPLable.text            = [self.searchSessionManagerArray[indexPath.row-1] objectForKey:@"ip"];
            sessionManagerCell.userNameLable.text      = [self.searchSessionManagerArray[indexPath.row-1] objectForKey:@"username"];
            sessionManagerCell.timeLable.text          = [[self.searchSessionManagerArray[indexPath.row-1] objectForKey:@"dotime"] substringFromIndex:5];
            sessionManagerCell.sessionidLable.text     = [self.searchSessionManagerArray[indexPath.row-1] objectForKey:@"sid"];
            
            //判断返回的数据from所对应的数据为空，则现实PC.png这张图片，否则正常显示所对应的图片
            if ([[self.searchSessionManagerArray[indexPath.row-1] objectForKey:@"from"] isEqualToString:@""]) {
                sessionManagerCell.networkStateImageView.image = [UIImage imageNamed:@"PC"];
            }else {
                sessionManagerCell.networkStateImageView.image = [UIImage imageNamed:[self.searchSessionManagerArray[indexPath.row-1] objectForKey:@"from"]];
            }
        }
    }else {
        if (indexPath.row == 0) {
            UITableViewCell *cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell addSubview:[self sessionManagerTableViewHeadView]];
            
            return cell;
            
        }else if (indexPath.row <= self.sessionManagerArray.count) {
            sessionManagerCell.IDLable.text            = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            sessionManagerCell.delegate                = self;
            sessionManagerCell.nameLable.text          = [self.sessionManagerArray[indexPath.row-1] objectForKey:@"project"];
            sessionManagerCell.IPLable.text            = [self.sessionManagerArray[indexPath.row-1] objectForKey:@"ip"];
            sessionManagerCell.userNameLable.text      = [self.sessionManagerArray[indexPath.row-1] objectForKey:@"username"];
            sessionManagerCell.timeLable.text          = [[self.sessionManagerArray[indexPath.row-1] objectForKey:@"dotime"] substringFromIndex:5];
            sessionManagerCell.sessionidLable.text     = [self.sessionManagerArray[indexPath.row-1] objectForKey:@"sid"];
            
            //判断返回的数据from所对应的数据为空，则现实PC.png这张图片，否则正常显示所对应的图片
            if ([[self.sessionManagerArray[indexPath.row-1] objectForKey:@"from"] isEqualToString:@""]) {
                sessionManagerCell.networkStateImageView.image = [UIImage imageNamed:@"PC"];
            }else {
                sessionManagerCell.networkStateImageView.image = [UIImage imageNamed:[self.sessionManagerArray[indexPath.row-1] objectForKey:@"from"]];
            }

        }else {
            if (_pageend == YES && indexPath.row == self.sessionManagerArray.count+1) {
                UITableViewCell *pageendCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                
                pageendCell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *lable             = [[UILabel alloc] init];
                lable.frame                = CGRectMake(0, 0, SCREEN_WIDTH, 57);
                if (self.sessionManagerArray.count == 0) {
                    lable.text             = @"无内容";
                }else {
                    lable.text             = @"已显示所有内容";
                }
                lable.alpha                = 0.5;
                lable.font                 = [UIFont systemFontOfSize:17];
                lable.textAlignment        = NSTextAlignmentCenter;
                [pageendCell addSubview:lable];
                return pageendCell;
            }else if (indexPath.row > self.sessionManagerArray.count+1) {
                UITableViewCell *Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                Cell.selectionStyle = UITableViewCellSelectionStyleNone;

                return Cell;
            }
        }
    }
    
    return sessionManagerCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchController.searchResultsTableView) {
        if (indexPath.row != 0 && indexPath.row != self.searchSessionManagerArray.count+1) {
            
            //隐藏向左滑出的按钮
            [super hideMenuOptionsAnimated:YES];
            
            //结束上拉刷新的动画
            [self.searchController.searchResultsTableView footerEndRefreshing];
            
            //用于记录你所点击的是列表的第几行
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:[NSString stringWithFormat:@"%d",indexPath.row-1] forKey:@"sessionManagerRow"];
            
            //用于记录是从原始界面进入详情界面的还是从搜索界面进入详情界面的
            [ud setObject:@"searchSessionManager" forKey:@"sessionManager"];
            [ud synchronize];
            
            AlterSessionManagerViewController *alterSessionManager = [[AlterSessionManagerViewController alloc] init];
            [self.navigationController pushViewController:alterSessionManager animated:YES];
            
        }
        
    }else {
        if (indexPath.row != 0 && indexPath.row != self.sessionManagerArray.count+1 && indexPath.row <= self.sessionManagerArray.count) {
            
            //隐藏向左滑出的按钮
            [super hideMenuOptionsAnimated:YES];
            
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
            
            //用于记录你所点击的是列表的第几行
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:[NSString stringWithFormat:@"%ld",indexPath.row-1] forKey:@"sessionManagerRow"];
            
            //用于记录是从原始界面进入详情界面的还是从搜索界面进入详情界面的
            [ud setObject:@"sessionManager" forKey:@"sessionManager"];
            [ud synchronize];
            
            AlterSessionManagerViewController *alterSessionManager = [[AlterSessionManagerViewController alloc] init];
            [self.navigationController pushViewController:alterSessionManager animated:YES];
            
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 40.0;
    }
    if (iPhone5) {
        return 58;//为了防止列表刷新，底部出现闪烁现象，故在此加大了cell 的高度
    }else {
        return 55;
    }
}

//列表的头
- (UIView *)sessionManagerTableViewHeadView
{
    UIView *attributeNameView         = [[UIView alloc] init];
    attributeNameView.frame           = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    attributeNameView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    
    //背景view下的细线
    UIView *lineView         = [[UIView alloc] init];
    lineView.frame           = CGRectMake(0, 39.5, SCREEN_WIDTH, 0.5);
    lineView.backgroundColor = [UIColor grayColor];
    lineView.alpha           = 0.6;
    [attributeNameView addSubview:lineView];
    
    //属性名称lable--ID
    UILabel *lableOne      = [[UILabel alloc] init];
    lableOne.frame         = CGRectMake(10, 0, 20, 40);
    lableOne.text          = @"ID";
    lableOne.textAlignment = NSTextAlignmentCenter;
    lableOne.font          = [UIFont systemFontOfSize:14];
    lableOne.textColor     = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    [attributeNameView addSubview:lableOne];
    
    //属性名称lable--用户名
    UILabel *lableTwo      = [[UILabel alloc] init];
    lableTwo.frame         = CGRectMake(lableOne.frame.origin.x+lableOne.frame.size.width+5, 0, 100, 40);
    lableTwo.text          = @"用户名";
    lableTwo.textAlignment = NSTextAlignmentLeft;
    lableTwo.font          = [UIFont systemFontOfSize:14];
    lableTwo.textColor     = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    [attributeNameView addSubview:lableTwo];
    
    //属性名称lable--IP地址
    UILabel *lableThr      = [[UILabel alloc] init];
    lableThr.frame         = CGRectMake(lableTwo.frame.origin.x+lableTwo.frame.size.width+30, 0, 55, 40);
    lableThr.text          = @"IP地址";
    lableThr.textAlignment = NSTextAlignmentLeft;
    lableThr.font          = [UIFont systemFontOfSize:14];
    lableThr.textColor     = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    [attributeNameView addSubview:lableThr];
    
    
    return attributeNameView;
}

#pragma mark - 网络请求
- (void)headerRefresh
{
    //将滚动条禁掉，防止刷新是滚动条的闪屏
    self.tableView.showsVerticalScrollIndicator = NO;
    
    //设置刷新的状态为YES
    self.headerRefreshing = YES;
    
    //记录当前是否为最后一页，如果为最后一页，则添加“以显示所有数据”一行
    self.pageend = NO;
    
    //判断当前网络状况
    if (![self isConnectionAvailable]) {
        [self.tableView headerEndRefreshing];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常,请检查你的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    //发送保存请求
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = TimeoutInterval;
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/session/getsessionlistformore.do;sessionid=%@",IP,port,sid];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"fromid",@"50",@"PageSize", nil];
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            
            //如果返回的数据中pagenumber与pagecount相同，则说明，这组数据为所用数据的最后一页
            if ([[resultDic objectForKey:@"data"] count] < 10) {
                _pageend = YES;
            }
            
            //如果数组不为空，则删除所有数据从新存入，防止数据的更新出错
            if (self.sessionManagerArray != 0) {
                [self.sessionManagerArray removeAllObjects];
                [self.tableView reloadData];
            }
            
            if ([[resultDic objectForKey:@"data"] count] != 0) {
                for (int i = 0; i<[[resultDic objectForKey:@"data"] count]; i ++) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"project"] forKey:@"project"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"ip"] forKey:@"ip"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"dotime"] forKey:@"dotime"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"username"] forKey:@"username"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"from"] forKey:@"from"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"sid"] forKey:@"sid"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"id"] forKey:@"id"];
                    [self.sessionManagerArray addObject:dic];
                }
            }
            
            [ud setObject:self.sessionManagerArray forKey:@"sessionManagerArray"];
            [ud synchronize];
            
            //停止0.5s后执行刷新列表，并停止刷新的动画
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //启用滚动条
                self.tableView.showsVerticalScrollIndicator = YES;
                
                [self.tableView reloadData];
                [self.tableView headerEndRefreshing];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.headerRefreshing = NO;
                });
            });
            
        }else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"]) {
            [self.tableView headerEndRefreshing];
            self.headerRefreshing = NO;
            
            if (!self.judgeBack) {
                if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"]) {
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:self cancelButtonTitle:@"重试" otherButtonTitles:@"重新登录", nil];
                    [alter show];
                }else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }
            }

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView headerEndRefreshing];
        self.headerRefreshing = NO;
        
        //如果未离开此界面则显示错误提示，如果已离开则不显示
        if (!self.judgeBack) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常,请检查你的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            
            self.headerRefreshing = NO;
        }
    }];
}

- (void)footerRefresh
{
    //将滚动条禁掉，防止刷新是滚动条的闪屏
    self.tableView.showsVerticalScrollIndicator = NO;
    
    //记录当前数否在刷新
    self.headerRefreshing = YES;
    
    //比较ID大小，获取最大ID传入url获取下一页的内容
    if (self.sessionManagerArray.count <= 50) {
        self.fromID = [[self.sessionManagerArray[0] objectForKey:@"id"] intValue];
        for (int i = 0; i < self.sessionManagerArray.count-1; i ++ ) {
            if (self.fromID < [[self.sessionManagerArray[i+1] objectForKey:@"id"] intValue]) {
                self.fromID = [[self.sessionManagerArray[i+1] objectForKey:@"id"] intValue];
            }
        }
    }else {
        self.fromID = [[self.sessionManagerArray[self.sessionManagerArray.count-50] objectForKey:@"id"] intValue];
        for (long int i = self.sessionManagerArray.count-50; i < self.sessionManagerArray.count-1; i ++ ) {
            if (self.fromID < [[self.sessionManagerArray[i+1] objectForKey:@"id"] intValue]) {
                self.fromID = [[self.sessionManagerArray[i+1] objectForKey:@"id"] intValue];
            }
        }
    }
    
    //判断当前网络状况
    if (![self isConnectionAvailable]) {
        [self.tableView headerEndRefreshing];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常,请检查你的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    //发送保存请求
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = TimeoutInterval;
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/session/getsessionlistformore.do;sessionid=%@",IP,port,sid];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.fromID],@"fromid",@"50",@"PageSize", nil];
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            
            if ([[resultDic objectForKey:@"data"] count] != 0) {
                
                //如果返回的数据中pagenumber与pagecount相同，则说明，这组数据为所用数据的最后一页
                if ([[resultDic objectForKey:@"data"] count] < 10) {
                    _pageend = YES;
                }else {
                    _pageend = NO;
                }
                
                for (int i = 0; i<[[resultDic objectForKey:@"data"] count]; i ++) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"project"] forKey:@"project"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"ip"] forKey:@"ip"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"dotime"] forKey:@"dotime"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"username"] forKey:@"username"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"from"] forKey:@"from"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"sid"] forKey:@"sid"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"id"] forKey:@"id"];
                    [self.sessionManagerArray addObject:dic];
                }
                [ud setObject:self.sessionManagerArray forKey:@"sessionManagerArray"];
                [ud synchronize];
                
            }else {
                _pageend = YES;
            }
            
            //停止0.5s后执行刷新列表，并停止刷新的动画
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //启用滚动条
                self.tableView.showsVerticalScrollIndicator = YES;
                
                [self.tableView reloadData];
                [self.tableView footerEndRefreshing];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.headerRefreshing = NO;
                });
            });
            
        }else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"]) {
            [self.tableView footerEndRefreshing];
            self.headerRefreshing = NO;
            
            if (!self.judgeBack) {
                if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"]) {
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:self cancelButtonTitle:@"重试" otherButtonTitles:@"重新登录", nil];
                    [alter show];
                }else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView footerEndRefreshing];
        self.headerRefreshing = NO;
        
        if (!self.judgeBack) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常,请检查你的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [self.tableView footerEndRefreshing];
            self.headerRefreshing = NO;
        }
    }];
}

//searchBar中的上拉加载更多
- (void)searchSessionManagerFooterRefresh
{
    [self.searchController.searchResultsTableView headerEndRefreshing];
    
    //将滚动条禁掉，防止刷新是滚动条的闪屏
    self.tableView.showsVerticalScrollIndicator = NO;
    
    //比较ID大小，获取最大ID传入url获取下一页的内容
    if (self.searchSessionManagerArray.count <= 10) {
        self.fromID = [[self.searchSessionManagerArray[0] objectForKey:@"id"] intValue];
        for (int i = 0; i < self.searchSessionManagerArray.count-1; i ++ ) {
            if (self.fromID < [[self.searchSessionManagerArray[i+1] objectForKey:@"id"] intValue]) {
                self.fromID = [[self.searchSessionManagerArray[i+1] objectForKey:@"id"] intValue];
            }
        }
    }else {
        self.fromID = [[self.searchSessionManagerArray[self.searchSessionManagerArray.count-10] objectForKey:@"id"] intValue];
        for (long int i = self.searchSessionManagerArray.count-10; i < self.searchSessionManagerArray.count-1; i ++ ) {
            if (self.fromID < [[self.searchSessionManagerArray[i+1] objectForKey:@"id"] intValue]) {
                self.fromID = [[self.searchSessionManagerArray[i+1] objectForKey:@"id"] intValue];
            }
        }
    }
    
    //判断当前网络状况
    if (![self isConnectionAvailable]) {
        [self.tableView headerEndRefreshing];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常,请检查你的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    //发送保存请求
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = TimeoutInterval;
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/session/getsessionlistformore.do;sessionid=%@",IP,port,sid];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.fromID],@"fromid",@"10",@"PageSize", self.searchBar.text,@"search",nil];
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            
            if ([[resultDic objectForKey:@"data"] count] != 0) {
                
                //如果返回的数据中pagenumber与pagecount相同，则说明，这组数据为所用数据的最后一页
                if ([[resultDic objectForKey:@"data"] count] < 10) {
                    _searchPageend = YES;
                }else {
                    _searchPageend = NO;
                }
                
                for (int i = 0; i<[[resultDic objectForKey:@"data"] count]; i ++) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"project"] forKey:@"project"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"ip"] forKey:@"ip"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"dotime"] forKey:@"dotime"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"username"] forKey:@"username"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"from"] forKey:@"from"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"sid"] forKey:@"sid"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"id"] forKey:@"id"];
                    [self.searchSessionManagerArray addObject:dic];
                }
                [ud setObject:self.searchSessionManagerArray forKey:@"searchSessionManagerArray"];
                [ud synchronize];
            }else {
                _searchPageend = YES;
            }
            
            //停止0.5s后执行刷新列表，并停止刷新的动画
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //启用滚动条
                self.tableView.showsVerticalScrollIndicator = YES;
                
                [self.searchController.searchResultsTableView reloadData];
                [self.searchController.searchResultsTableView footerEndRefreshing];
            });
            
        }else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"]) {
            [self.searchController.searchResultsTableView footerEndRefreshing];
            [MBProgressHUD hideAllHUDsForView:self.view  animated:YES];
            
            if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"]) {
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:self cancelButtonTitle:@"重试" otherButtonTitles:@"重新登录", nil];
                [alter show];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.searchController.searchResultsTableView footerEndRefreshing];
        self.headerRefreshing = NO;
        
        if (_endSearch) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常,请检查你的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [self.tableView footerEndRefreshing];
            self.headerRefreshing = NO;
        }
    }];
}

#pragma mark - UiSearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //将上一次的搜索出的数据全部清空，移除上拉加载更多的方法
    [self.searchSessionManagerArray removeAllObjects];
    [self.searchDisplayController.searchResultsTableView removeFooter];
    self.searchPageend = NO;
    
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在搜索...";
    
    [self searchSessionManager:self.searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""]) {
        [self.searchSessionManagerArray removeAllObjects];
        [self.searchDisplayController.searchResultsTableView removeFooter];
        _searchPageend = NO;
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (self.headerRefreshing) {
        return NO;
    }
    return YES;
}

//发起搜索请求
- (void)searchSessionManager:(NSString *)searchText
{
    //判断当前网络状况
    if (![self isConnectionAvailable]) {
        [self.tableView headerEndRefreshing];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常,请检查你的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    //发送保存请求
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = TimeoutInterval;
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/session/getsessionlistformore.do;sessionid=%@",IP,port,sid];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"fromid",@"10",@"PageSize", searchText,@"search",nil];
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        resultStr                = [resultStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        resultStr                = [resultStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            
            if ([[resultDic objectForKey:@"data"] count] < 10) {
                _searchPageend = YES;
            }
            
            if (!self.searchPageend) {
                [self.searchController.searchResultsTableView addFooterWithTarget:self action:@selector(searchSessionManagerFooterRefresh)];
            }
            
            if ([[resultDic objectForKey:@"data"] count] != 0) {
                for (int i = 0; i<[[resultDic objectForKey:@"data"] count]; i ++) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"project"] forKey:@"project"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"ip"] forKey:@"ip"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"dotime"] forKey:@"dotime"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"username"] forKey:@"username"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"from"] forKey:@"from"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"sid"] forKey:@"sid"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"id"] forKey:@"id"];
                    [self.searchSessionManagerArray addObject:dic];
                }
            }
            
            [self.searchController.searchResultsTableView reloadData];
            
            [ud setObject:self.searchSessionManagerArray forKey:@"searchSessionManagerArray"];
            [ud synchronize];
            
            //停止0.5s后执行刷新列表，并停止刷新的动画
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            });
            
        }else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"]) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            
            if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"]) {
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:self cancelButtonTitle:@"重试" otherButtonTitles:@"重新登录", nil];
                [alter show];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.searchController.searchResultsTableView footerEndRefreshing];
        self.headerRefreshing = NO;
        
        if (_endSearch) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常,请检查你的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }];
    
}

#pragma mark - UISearchDisplayDelegate
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    _endSearch     = NO;
    
    //如果打开搜索界面了，将属性设置为yes
    self.judgeSelfTableViewOrSearchResultsTableView = YES;
}

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    //删除搜索出存储的数据
    [self.searchSessionManagerArray removeAllObjects];
    self.searchBar.placeholder = @"搜索";
    [self.searchDisplayController.searchResultsTableView removeFooter];
    _searchPageend = NO;
    _endSearch     = YES;
    
    //如果关闭搜索界面了，将属性设置为NO
    self.judgeSelfTableViewOrSearchResultsTableView = NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return YES;
}

#pragma mark - 删除的操作
- (void)contextMenuCellDidSelectDeleteOption:(SessionManagerTableViewCell *)cell
{
    
    _ID          = [cell.IDLable.text intValue];
    
    _projectName = cell.nameLable.text;
    
    _sessionid   = cell.sessionidLable.text;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除" message:[NSString stringWithFormat:@"确定要删除 %@ 吗？",self.sessionid] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 50;
    [alert show];
}

- (void)deleteSession:(NSString *)projectname andSid:(NSString *)sessionid andID:(int)ID
{
    //判断当前网络状况
    if (![self isConnectionAvailable]) {
        [self.tableView headerEndRefreshing];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常,请检查你的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在删除...";
    
    //发送保存请求
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    NSURL *url         = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/adminmanager/do/session/deletesession.do?projectname=%@&sessionid=%@;sessionid=%@",IP,port,projectname,sessionid,sid]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TimeoutInterval];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        resultStr                = [resultStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        resultStr                = [resultStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            
            if (self.judgeSelfTableViewOrSearchResultsTableView) {
                [self.searchSessionManagerArray removeObjectAtIndex:ID-1];
                
                [self.searchController.searchResultsTableView reloadData];
                
                [ud setObject:self.searchSessionManagerArray forKey:@"searchSessionManagerArray"];
                [ud synchronize];
            }else {
                [self.sessionManagerArray removeObjectAtIndex:ID-1];
                
                [self.tableView reloadData];
                
                [ud setObject:self.sessionManagerArray forKey:@"sessionManagerArray"];
                [ud synchronize];
            }
            
            //返回成功时，改变等待指示器的样式，变为保存成功
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"删除成功";
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            });
            
        }else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"]) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            
            if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"]) {
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:self cancelButtonTitle:@"重试" otherButtonTitles:@"重新登录", nil];
                [alter show];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        if (!self.judgeBack) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常,请检查你的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }];
    
    [operation start];
    
}

#pragma mark - 跳转到详情界面的操作
- (void)contextMenuCellDidSelectMoreOption:(SessionManagerTableViewCell *)cell
{
    //隐藏向左滑出的按钮
    [super hideMenuOptionsAnimated:YES];
    
    [self.tableView headerEndRefreshing];
    
    _ID = [cell.IDLable.text intValue];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSString stringWithFormat:@"%d",_ID-1] forKey:@"sessionManagerRow"];
    
    if (self.judgeSelfTableViewOrSearchResultsTableView) {
        //用于记录是从原始界面进入详情界面的还是从搜索界面进入详情界面的
        [ud setObject:@"searchSessionManager" forKey:@"sessionManager"];
    }else {
        [ud setObject:@"sessionManager" forKey:@"sessionManager"];
    }
    
    [ud synchronize];
    
    AlterSessionManagerViewController *alterSessionManager = [[AlterSessionManagerViewController alloc] init];
    [self.navigationController pushViewController:alterSessionManager animated:YES];
}

#pragma mark - alertview调用的方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 50) {
        if ( buttonIndex == 1) {
            [self deleteSession:self.projectName andSid:self.sessionid andID:self.ID];
        }
    }else {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - 进入界面首次刷新
//下啦刷新操作
- (void)firstRefresh
{
    // 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
}

#pragma mark - 菜单按钮
- (void)menuButton:(NSString *)navigationTitle
{
    //自定义navigationbar的背景view
    UIView *view          = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 44)];
    view.backgroundColor  = [UIColor clearColor];
    
    //菜单按钮
    _menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [self.menuButton setBackgroundImage:[UIImage imageNamed:@"home"] forState:UIControlStateNormal];
    [self.menuButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.menuButton];
    
    //标题lable
    UILabel *titleLable        = [[UILabel alloc] init];
    titleLable.frame           = CGRectMake((view.frame.size.width-200)/2, 0, 200, view.frame.size.height);
    titleLable.textAlignment   = NSTextAlignmentCenter;
    titleLable.textColor       = [UIColor whiteColor];
    titleLable.font            = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.text            = navigationTitle;
    [view addSubview:titleLable];
    
    self.navigationItem.titleView =view;
}

#pragma mark - 网络状况测试
-(BOOL)isConnectionAvailable
{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.qq.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    return isExistenceNetwork;
}

- (void)showMeun
{
    [UIView animateWithDuration:0.35f animations:^{
        self.menuButton.alpha = 0;
    }];
}

- (void)hideMeun
{
    [UIView animateWithDuration:0.35f animations:^{
        self.menuButton.alpha = 1;
    }];
}

#pragma mark - view即将移除时
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.judgeBack = YES;
}

@end
