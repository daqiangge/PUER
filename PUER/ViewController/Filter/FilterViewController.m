//
//  FilterViewController.m
//  PUER
//
//  Created by admin on 14/12/23.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "FilterViewController.h"
#import "AlterFilterViewController.h"
#import "ShowAllFilterOrCustomFilter.h"

@interface FilterViewController ()

@end

@implementation FilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self menuButton:@"动作过滤"];
    [self initData];
    [self initView];
    [self firstRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _judgeBack           = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showMeun" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideMeun" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FromAlterFilterView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMeun) name:@"showMeun" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMeun) name:@"hideMeun" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fromAlterFilterViewSave) name:@"FromAlterFilterView" object:nil];
    
    _filterArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"filterArray"]];
    [self initcustomFilterArray];
    _judgeBack = NO;
    _selectedRowNum = 0;
}

- (void)initView
{
    //给列表添加耍想的头
    [self.tableView addHeaderWithTarget:self action:@selector(doRequest)];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(showKxMenu)];
    rightButton.tintColor = [UIColor whiteColor];
    rightButton.imageInsets          = UIEdgeInsetsMake(30,55,30,10);
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

- (void)initcustomFilterArray
{
    _customFilterArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _filterArray.count; i++) {
        if ([[_filterArray[i] objectForKey:@"issys"] isEqualToString:@"否"] ) {
            
            [_customFilterArray addObject:_filterArray[i]];
        }
    }
}

#pragma mark - 网络请求
- (void)doRequest
{
    
    NSURL *url         = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/adminmanager/do/filter/getfilterlist.do;sessionid=%@",[[IpAndOther shareInstance] getIP],[[IpAndOther shareInstance] getPort],[[IpAndOther shareInstance] getSid]]];
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
            
            if (_filterArray != 0) {
                [_filterArray removeAllObjects];
            }
            if (_customFilterArray.count != 0) {
                [_customFilterArray removeAllObjects];
            }
            
            if ([[resultDic objectForKey:@"data"] count] != 0) {
                for (int i = 0; i<[[resultDic objectForKey:@"data"] count]; i ++) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"name"] forKey:@"name"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"dotype"] forKey:@"dotype"];
                    
                    if ([[[resultDic objectForKey:@"data"][i] objectForKey:@"chksid"] intValue] == 0) {
                        [dic setObject:@"否" forKey:@"chksid"];
                    }else {
                        [dic setObject:@"是" forKey:@"chksid"];
                    }
                    
                    if ([[[resultDic objectForKey:@"data"][i] objectForKey:@"issys"] intValue] == 0) {
                        [dic setObject:@"否" forKey:@"issys"];
                    }else {
                        [dic setObject:@"是" forKey:@"issys"];
                    }
                    
                    [_filterArray addObject:dic];
                }
            }
            
            [self initcustomFilterArray];
            
            [[NSUserDefaults standardUserDefaults] setObject:_filterArray forKey:@"filterArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //停止0.5s后执行刷新列表，并停止刷新的动画
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.tableView headerEndRefreshing];
            });
            
        }else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"]) {
            [self.tableView headerEndRefreshing];
            
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
        if (!self.judgeBack) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前无法连接到服务器，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }];
    
    [operation start];
}

- (void)doDeleteRequest
{
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在删除...";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = TimeoutInterval;
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/filter/deletefilter.do;sessionid=%@",[[IpAndOther shareInstance] getIP],[[IpAndOther shareInstance] getPort],[[IpAndOther shareInstance] getSid]];
    
    NSMutableDictionary *parameters;
    if ([ShowAllFilterOrCustomFilter shareInstance].showAllFilter) {
        parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self.filterArray[_cellID-1] objectForKey:@"name"],@"Name", nil];
    }else {
        parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self.customFilterArray[_cellID-1] objectForKey:@"name"],@"Name", nil];
    }
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"删除成功";
            
            if ([ShowAllFilterOrCustomFilter shareInstance].showAllFilter) {
                
                [self.filterArray removeObjectAtIndex:_cellID-1];
                [self.tableView reloadData];
                
            }else {
                
                for (int i = 0; i<_filterArray.count; i++) {
                    if ([[_filterArray[i] objectForKey:@"name"] isEqualToString:[_customFilterArray[_cellID-1] objectForKey:@"name"]]) {
                        [self.filterArray removeObjectAtIndex:i];
                        break;
                    }
                }
                
                [self.customFilterArray removeObjectAtIndex:_cellID-1];
                [self.tableView reloadData];
                
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                
            });
            
        }else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"]) {
            
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window]animated:YES];
            
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
        
        if (!_judgeBack) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常,请检查你的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        
    }];
}

#pragma mark - 进入界面首次刷新
//下啦刷新操作
- (void)firstRefresh
{
    // 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_filterArray.count == 0) {
        return 2;
    }else {
        if ([ShowAllFilterOrCustomFilter shareInstance].showAllFilter) {
            return _filterArray.count+1;
        }else {
            return _customFilterArray.count+1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FilterTableViewCell *filterCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (filterCell == nil) {
        filterCell  = [[FilterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == 0) {
        UITableViewCell *cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell addSubview:[self networkTableViewHeadView]];
        
        return cell;
        
    }else {
        
        if (_filterArray.count == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *lable = [[UILabel alloc] init];
            lable.frame    = CGRectMake(0, 0, SCREEN_WIDTH, 45);
            lable.text     = @"无内容";
            lable.textAlignment = NSTextAlignmentCenter;
            lable.font    = [UIFont systemFontOfSize:15];
            lable.alpha   = 0.6;
            
            [cell addSubview:lable];
            
            return cell;
            
        }else {
            if ([ShowAllFilterOrCustomFilter shareInstance].showAllFilter) {
                
                filterCell.IDLable.text            = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
                filterCell.delegate                = self;
                filterCell.filterNameLable.text    = [_filterArray[indexPath.row-1] objectForKey:@"name"];
                filterCell.defaultLable.text       = [_filterArray[indexPath.row-1] objectForKey:@"issys"];
                filterCell.checkSessionLable.text  = [_filterArray[indexPath.row-1] objectForKey:@"chksid"];
                
                if ([[_filterArray[indexPath.row-1] objectForKey:@"dotype"] isEqualToString:@"left"]) {
                    filterCell.filterImagerView.image = [UIImage imageNamed:@"filter2"];
                }else {
                    filterCell.filterImagerView.image = [UIImage imageNamed:@"filter1"];
                }
                
                if ([[_filterArray[indexPath.row-1] objectForKey:@"issys"] isEqualToString:@"是"]) {
                    [filterCell.modifyButton setImage:[UIImage imageNamed:@"chaxun"] forState:UIControlStateNormal];
                }else {
                    [filterCell.modifyButton setImage:[UIImage imageNamed:@"datalink2"] forState:UIControlStateNormal];
                }
            }else {
                filterCell.IDLable.text            = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
                filterCell.delegate                = self;
                filterCell.filterNameLable.text    = [_customFilterArray[indexPath.row-1] objectForKey:@"name"];
                filterCell.defaultLable.text       = [_customFilterArray[indexPath.row-1] objectForKey:@"issys"];
                filterCell.checkSessionLable.text  = [_customFilterArray[indexPath.row-1] objectForKey:@"chksid"];
                
                if ([[_customFilterArray[indexPath.row-1] objectForKey:@"dotype"] isEqualToString:@"left"]) {
                    filterCell.filterImagerView.image = [UIImage imageNamed:@"filter2"];
                }else {
                    filterCell.filterImagerView.image = [UIImage imageNamed:@"filter1"];
                }
                
                if ([[_customFilterArray[indexPath.row-1] objectForKey:@"issys"] isEqualToString:@"是"]) {
                    [filterCell.modifyButton setImage:[UIImage imageNamed:@"chaxun"] forState:UIControlStateNormal];
                }else {
                    [filterCell.modifyButton setImage:[UIImage imageNamed:@"datalink2"] forState:UIControlStateNormal];
                }
            }
        }
    }
    
    return filterCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) {
        [self.tableView headerEndRefreshing];
        
//        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//        [ud setObject:[self.networkArray[indexPath.row-1] objectForKey:@"fromurl"] forKey:@"networkfromurl"];
//        [ud synchronize];
        
//        AlterNetworkViewController *alterNV = [[AlterNetworkViewController alloc] init];
//        [self.navigationController pushViewController:alterNV animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 40;
    }
    return 45;
}

//列表的头
- (UIView *)networkTableViewHeadView
{
    //背景view
    UIView *attributeNameView = [[UIView alloc] init];
    attributeNameView.frame   = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    attributeNameView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    
    //背景view下的细线
    UIView *lineView       = [[UIView alloc] init];
    lineView.frame         = CGRectMake(0, 39.5, SCREEN_WIDTH, 0.5);
    lineView.backgroundColor = [UIColor grayColor];
    lineView.alpha           = 0.6;
    [attributeNameView addSubview:lineView];
    
    //属性名称lable---ID
    UILabel *lableOne      = [[UILabel alloc] init];
    lableOne.frame         = CGRectMake(10, 0, 20, 40);
    lableOne.text          = @"ID";
    lableOne.textAlignment = NSTextAlignmentCenter;
    lableOne.font          = [UIFont systemFontOfSize:14];
    lableOne.textColor     = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    [attributeNameView addSubview:lableOne];
    
    //属性名称lable---过滤器名称
    UILabel *lableTwo      = [[UILabel alloc] init];
    lableTwo.frame         = CGRectMake(lableOne.frame.origin.x+lableOne.frame.size.width+5, 0, 200, 40);
    lableTwo.text          = @"过滤器名称";
    lableTwo.textAlignment = NSTextAlignmentLeft;
    lableTwo.font          = [UIFont systemFontOfSize:14];
    lableTwo.textColor     = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    [attributeNameView addSubview:lableTwo];
    
    //属性名称lable---默认
    UILabel *lableThr      = [[UILabel alloc] init];
    lableThr.frame         = CGRectMake(SCREEN_WIDTH-80-50, 0, 50, 40);
    lableThr.text          = @"默认";
    lableThr.textAlignment = NSTextAlignmentCenter;
    lableThr.font          = [UIFont systemFontOfSize:14];
    lableThr.textColor     = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    [attributeNameView addSubview:lableThr];
    
    //属性名称lable---检查会话
    UILabel *lableFou      = [[UILabel alloc] init];
    lableFou.frame         = CGRectMake(SCREEN_WIDTH-80, 0, 80, 40);
    lableFou.text          = @"检查会话";
    lableFou.textAlignment = NSTextAlignmentCenter;
    lableFou.font          = [UIFont systemFontOfSize:14];
    lableFou.textColor     = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    [attributeNameView addSubview:lableFou];
    
    
    return attributeNameView;
}

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 500) {
        if (buttonIndex == 1) {
            [self doDeleteRequest];
        }
    }else {
        if (buttonIndex == 1) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }
}

#pragma mark - 跳转到修改界面
- (void)contextMenuCellModifyOption:(FilterTableViewCell *)cell
{
    //隐藏向左滑出的按钮
    [super hideMenuOptionsAnimated:YES];
    
    [self.tableView headerEndRefreshing];
    
    int i = [cell.IDLable.text intValue];
    
    _selectedRowNum = i-1;
    
    AlterFilterViewController *alterFilterView = [[AlterFilterViewController alloc] init];
    
    if ([ShowAllFilterOrCustomFilter shareInstance].showAllFilter) {
        [alterFilterView setOldFilterName:[_filterArray[_selectedRowNum] objectForKey:@"name"]];
        
        if ([[_filterArray[_selectedRowNum] objectForKey:@"issys"] isEqualToString:@"是"]) {
            [alterFilterView setIssys:YES];
        }else {
            [alterFilterView setIssys:NO];
        }
    }else {
        [alterFilterView setOldFilterName:[_customFilterArray[_selectedRowNum] objectForKey:@"name"]];
        
        if ([[_customFilterArray[_selectedRowNum] objectForKey:@"issys"] isEqualToString:@"是"]) {
            [alterFilterView setIssys:YES];
        }else {
            [alterFilterView setIssys:NO];
        }
    }
    
    [alterFilterView setIsNewAdd:NO];
    [self.navigationController pushViewController:alterFilterView animated:YES];
}

#pragma mark - 删除网络代理
- (void)contextMenuCellDidSelectDeleteOption:(FilterTableViewCell *)cell
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"删除" message:[NSString stringWithFormat:@"要删除 %@ 吗？",cell.filterNameLable.text] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alter.tag = 500;
    [alter show];
    
    _cellID = [cell.IDLable.text intValue];
}

#pragma mark - 按钮操作
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
    titleLable.font            = [UIFont fontWithName:TextFont_name_Bold size:18];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.text            = navigationTitle;
    [view addSubview:titleLable];
    
    self.navigationItem.titleView =view;
}

- (void)showKxMenu
{
    NSArray *menuItems;
    if ([ShowAllFilterOrCustomFilter shareInstance].showAllFilter) {
        menuItems =
        @[
          [KxMenuItem menuItem:@"新增过滤器"
                         image:nil
                        target:self
                        action:@selector(addNewFilter)],
          
          [KxMenuItem menuItem:@"只显示自定义项"
                         image:[UIImage imageNamed:@"check_icon"]
                        target:self
                        action:@selector(showAllFilterOrCustomFilter)]
          ];
    }else {
        menuItems =
        @[
          [KxMenuItem menuItem:@"新增过滤器"
                         image:nil
                        target:self
                        action:@selector(addNewFilter)],
          
          [KxMenuItem menuItem:@"显示所有项"
                         image:[UIImage imageNamed:@"check_icon"]
                        target:self
                        action:@selector(showAllFilterOrCustomFilter)]
          ];
    }
    
//    KxMenuItem *first = menuItems[0];
//    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
//    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:[[UIApplication sharedApplication].delegate window]
                  fromRect:CGRectMake(SCREEN_WIDTH-50, 20, 50, 44)
                 menuItems:menuItems];

}

- (void)addNewFilter
{
    AlterFilterViewController *alterFilterView = [[AlterFilterViewController alloc] init];
    [alterFilterView setIssys:NO];
    [alterFilterView setIsNewAdd:YES];
    [self.navigationController pushViewController:alterFilterView animated:YES];
}

//改变是展示全部还是自定义过滤器的属性
- (void)showAllFilterOrCustomFilter
{
    if ([ShowAllFilterOrCustomFilter shareInstance].showAllFilter) {
        [[ShowAllFilterOrCustomFilter shareInstance] setShowAllFilter:NO];
    }else {
        [[ShowAllFilterOrCustomFilter shareInstance] setShowAllFilter:YES];
    }
    [self.tableView reloadData];
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

#pragma mark - 通知监听
- (void)fromAlterFilterViewSave
{
    [self doRequest];
}

#pragma mark - 设置了tableview的分割线
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

#pragma mark - view即将移除时
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.judgeBack = YES;
}


@end
