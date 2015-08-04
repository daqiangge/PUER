//
//  DataLinkViewController.m
//  PUER
//
//  Created by admin on 14-8-14.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "DataLinkViewController.h"
#import "DataLinkTableViewCell.h"
#import "AlterDataLinkViewController.h"

@interface DataLinkViewController ()

@end

@implementation DataLinkViewController

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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showMeun" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideMeun" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMeun) name:@"showMeun" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMeun) name:@"hideMeun" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DataLinkDidSave" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLinkDidSave) name:@"DataLinkDidSave" object:nil];

    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"newadd"] style:UIBarButtonItemStylePlain target:self action:@selector(doAddDataLink)];
    rightButton.tintColor = [UIColor whiteColor];
    rightButton.imageInsets          = UIEdgeInsetsMake(30,54,30,10);
    self.navigationItem.rightBarButtonItem = rightButton;
    
    NSUserDefaults *ud   = [NSUserDefaults standardUserDefaults];
    _dataLinkArray       = [[NSMutableArray alloc] initWithArray:[ud objectForKey:@"dataLinkArray"]];
    _cellID              = 1;
    
    [self menuButton:@"数据连接"];
    [self doLoading];
    [self firstRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (self.view.window == nil)
    {
        self.view = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _judgeBack           = NO;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)doLoading
{
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    //给列表添加耍想的头
    [self.tableView addHeaderWithTarget:self action:@selector(doRequest)];
    
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataLinkArray.count == 0)
    {
        return 2;
    }
    
    return self.dataLinkArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier      = @"Cell";
    DataLinkTableViewCell *dataLinkCell  = [[DataLinkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if (indexPath.row == 0)
    {
        UITableViewCell *cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle    = UITableViewCellSelectionStyleNone;
        
        [cell addSubview:[self dataLinkTableHeadView]];
        
        return cell;
    }
    else
    {
        if (self.dataLinkArray.count == 0)
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *lable = [[UILabel alloc] init];
            lable.frame    = CGRectMake(0, 0, SCREEN_WIDTH, 55);
            lable.text     = @"无内容";
            lable.textAlignment = NSTextAlignmentCenter;
            lable.font    = [UIFont systemFontOfSize:15];
            lable.alpha   = 0.6;
            
            [cell addSubview:lable];
            
            return cell;
        }
        else
        {
            dataLinkCell.IDLable.text            = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            dataLinkCell.delegate                = self;
            dataLinkCell.nameLable.text          = [self.dataLinkArray[indexPath.row-1] objectForKey:@"connname"];
            dataLinkCell.IPLable.text            = [self.dataLinkArray[indexPath.row-1] objectForKey:@"datasource"];
            dataLinkCell.poolcount.text          = [NSString stringWithFormat:@"%@/%@",[self.dataLinkArray[indexPath.row-1] objectForKey:@"poolcount"],[self.dataLinkArray[indexPath.row-1] objectForKey:@"poolmaxcount"]];
            
            //判断provider是否为SQL数据库，如果不是则显示用户名
            if ([[self.dataLinkArray[indexPath.row-1] objectForKey:@"provider"] isEqualToString:@"SQLOLEDB.1"] || [[self.dataLinkArray[indexPath.row-1] objectForKey:@"provider"] isEqualToString:@"SQLNCLI11.1"])
            {
                dataLinkCell.databaseLable.text      = [self.dataLinkArray[indexPath.row-1] objectForKey:@"initialcatalog"];
            }
            else
            {
                dataLinkCell.databaseLable.text      = [self.dataLinkArray[indexPath.row-1] objectForKey:@"username"];
            }
        }
    }
    return dataLinkCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.row != 0) {
    //        [self.tableView headerEndRefreshing];
    //
    //        //将数据库所点击那行的名称存入内存列表中
    //        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    //        [ud setObject:[self.dataLinkArray[indexPath.row-1] objectForKey:@"connname"] forKey:@"connname"];
    //        [ud synchronize];
    //
    //        AlterDataLinkViewController *alterDLV = [[AlterDataLinkViewController alloc] init];
    //        [self.navigationController pushViewController:alterDLV animated:YES];
    //    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 40.0;
    }
    
    if (iPhone5)
    {
        return 56;
    }
    
    return 53.5;
}

//列表的头
- (UIView *)dataLinkTableHeadView
{
    UIView *attributeNameView = [[UIView alloc] init];
    attributeNameView.frame   = CGRectMake(0, 0, SCREEN_WIDTH, 40);
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
    
    //属性名称lable--名称
    UILabel *lableTwo      = [[UILabel alloc] init];
    lableTwo.frame         = CGRectMake(lableOne.frame.origin.x+lableOne.frame.size.width+5, 0, 50, 40);
    lableTwo.text          = @"名称";
    lableTwo.textAlignment = NSTextAlignmentLeft;
    lableTwo.font          = [UIFont systemFontOfSize:14];
    lableTwo.textColor     = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    [attributeNameView addSubview:lableTwo];
    
    //属性名称lable--数据库
    UILabel *lableThr      = [[UILabel alloc] init];
    lableThr.frame         = CGRectMake(lableTwo.frame.origin.x+lableTwo.frame.size.width+70, 0, 55, 40);
    lableThr.text          = @"数据库";
    lableThr.textAlignment = NSTextAlignmentLeft;
    lableThr.font          = [UIFont systemFontOfSize:14];
    lableThr.textColor     = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    [attributeNameView addSubview:lableThr];
    
    
    return attributeNameView;
}

#pragma mark - 网络请求
- (void)doRequest
{
    //判断当前网络状况
    if (![GetNetworkStates getNetWorkStates])
    {
        [self.tableView headerEndRefreshing];
        return;
    }
    
    //发送保存请求
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    NSURL *url         = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/adminmanager/do/connpool/getdbconnlistall.do;sessionid=%@",IP,port,sid]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TimeoutInterval];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        resultStr                = [resultStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        resultStr                = [resultStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"])
        {
            if (self.dataLinkArray != 0)
            {
                [self.dataLinkArray removeAllObjects];
            }
            
            if ([[resultDic objectForKey:@"data"] count] != 0)
            {
                for (int i = 0; i<[[resultDic objectForKey:@"data"] count]; i ++)
                {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"connname"] forKey:@"connname"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"datasource"] forKey:@"datasource"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"initialcatalog"] forKey:@"initialcatalog"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"poolcount"] forKey:@"poolcount"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"poolmaxcount"] forKey:@"poolmaxcount"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"provider"] forKey:@"provider"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"username"] forKey:@"username"];
                    [self.dataLinkArray addObject:dic];
                }
            }
            
            [ud setObject:self.dataLinkArray forKey:@"dataLinkArray"];
            [ud synchronize];
            
            //停止0.5s后执行刷新列表，并停止刷新的动画
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
            {
                [self.tableView reloadData];
                [self.tableView headerEndRefreshing];
            });
            
        }
        else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"])
        {
            [self.tableView headerEndRefreshing];
            
            if (!self.judgeBack)
            {
                if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"]) {
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:[[resultDic objectForKey:@"state"] objectForKey:@"info"]
                                                                   delegate:self
                                                          cancelButtonTitle:@"重试"
                                                          otherButtonTitles:@"重新登录", nil];
                    [alter show];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:[[resultDic objectForKey:@"state"] objectForKey:@"info"]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles: nil];
                    [alert show];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
        [self.tableView headerEndRefreshing];
        if (!self.judgeBack)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"网络异常,请检查你的网络"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles: nil];
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
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/connpool/deletedbconn.do;sessionid=%@",[[IpAndOther shareInstance] getIP],[[IpAndOther shareInstance] getPort],[[IpAndOther shareInstance] getSid]];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self.dataLinkArray[_cellID-1] objectForKey:@"connname"],@"ConnName", nil];
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"])
        {
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"删除成功";
            
            [self.dataLinkArray removeObjectAtIndex:_cellID-1];
            [self.tableView reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
            {
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            });
            
        }
        else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"])
        {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window]animated:YES];
            
            if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"])
            {
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:[[resultDic objectForKey:@"state"] objectForKey:@"info"]
                                                               delegate:self
                                                      cancelButtonTitle:@"重试"
                                                      otherButtonTitles:@"重新登录", nil];
                [alter show];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:[[resultDic objectForKey:@"state"] objectForKey:@"info"]
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles: nil];
                [alert show];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        
        if (!_judgeBack)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"网络异常,请检查你的网络"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles: nil];
            [alert show];
        }
    }];
}

#pragma mark - 跳转到修改界面的操作
- (void)contextMenuCellModifyOption:(DataLinkTableViewCell *)cell
{
    //隐藏向左滑出的按钮
    [super hideMenuOptionsAnimated:YES];
    
    [self.tableView headerEndRefreshing];
    
    AlterDataLinkViewController *alterDLV = [[AlterDataLinkViewController alloc] init];
    [alterDLV setIsNewAdd:NO];
    [alterDLV setConnname:cell.nameLable.text];
    [self.navigationController pushViewController:alterDLV animated:YES];
}

#pragma mark - 删除操作操作
- (void)contextMenuCellDidSelectDeleteOption:(DataLinkTableViewCell *)cell
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"删除"
                                                    message:[NSString stringWithFormat:@"要删除 %@ 吗？",cell.nameLable.text]
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alter.tag = 500;
    [alter show];
    
    _cellID = [cell.IDLable.text intValue];
}

#pragma mark - 测试连接的操作
- (void)contextMenuCelltestConnectionOption:(DataLinkTableViewCell *)cell
{
    //影藏侧滑出的按钮
    [super hideMenuOptionsAnimated:YES];
    [self.tableView headerEndRefreshing];
    
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在测试...";
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = TimeoutInterval+20;
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/connpool/testdbconn.do;sessionid=%@",IP,port,sid];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:cell.nameLable.text,@"ConnName",nil];
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        resultStr                = [resultStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        resultStr                = [resultStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"])
        {
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"连接成功";
            
            //2s后移除等待指示器和覆盖在window上的view
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
            {
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            });
            
        }
        else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"])
        {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            
            if (!self.judgeBack) {
                if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"])
                {
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:[[resultDic objectForKey:@"state"] objectForKey:@"info"]
                                                                   delegate:self
                                                          cancelButtonTitle:@"重试"
                                                          otherButtonTitles:@"重新登录", nil];
                    [alter show];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:[[resultDic objectForKey:@"state"] objectForKey:@"info"]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles: nil];
                    [alert show];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        
        if (!self.judgeBack)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"网络异常,请检查你的网络"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles: nil];
            [alert show];
        }
    }];
}

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 500)
    {
        if (buttonIndex == 1)
        {
            [self doDeleteRequest];
        }
    }
    else
    {
        if (buttonIndex == 1)
        {
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }
}

#pragma mark - 进入界面首次刷新
//下啦刷新操作
- (void)firstRefresh
{
    // 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
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
    titleLable.font            = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.text            = navigationTitle;
    [view addSubview:titleLable];
    
    self.navigationItem.titleView =view;
}

- (void)showMeun
{
    [UIView animateWithDuration:0.35f animations:^
    {
        self.menuButton.alpha = 0;
    }];
}

- (void)hideMeun
{
    [UIView animateWithDuration:0.35f animations:^
    {
        self.menuButton.alpha = 1;
    }];
}

//新增数据连接
- (void)doAddDataLink
{
    AlterDataLinkViewController *alterDLV = [[AlterDataLinkViewController alloc] init];
    [alterDLV setIsNewAdd:YES];
    [self.navigationController pushViewController:alterDLV animated:YES];
}

#pragma mark - 执行数据连接被保存后的刷新列表操作
- (void)dataLinkDidSave
{
    [self doRequest];
}

#pragma mark - view即将移除时
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.judgeBack = YES;
}

@end
