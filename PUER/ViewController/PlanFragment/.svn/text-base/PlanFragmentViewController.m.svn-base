//
//  PlanFragmentViewController.m
//  PUER
//
//  Created by admin on 14-9-12.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "PlanFragmentViewController.h"

@interface PlanFragmentViewController ()

@end

@implementation PlanFragmentViewController

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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PlanFragmentDidShowContextMenu" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PlanFragmentDidHideContextMenu" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMeun) name:@"showMeun" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMeun) name:@"hideMeun" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(planFragmentDidShowContextMenu) name:@"PlanFragmentDidShowContextMenu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(planFragmentDidHideContextMenu) name:@"PlanFragmentDidHideContextMenu" object:nil];
    
    _planFragmentArray        = [[NSMutableArray alloc] init];
    _judgeBack                = NO;
    
    [self menuButton:@"计划作业"];
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
    
    //给列表添加耍想的头
    [self.tableView addHeaderWithTarget:self action:@selector(doRequest)];
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.planFragmentArray.count == 0) {
        return 2;
    }
    return self.planFragmentArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idenifier = @"cell";
    PlanFragmentTableViewCell *PlanFragmentCell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    if (PlanFragmentCell == nil) {
        PlanFragmentCell = [[PlanFragmentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenifier];
    }
    
    static NSString *idenifier2 = @"cell2";
    PlanFragmentTwoTableViewCell *PlanFragmentCell2 = [tableView dequeueReusableCellWithIdentifier:idenifier2];
    if (PlanFragmentCell2 == nil) {
        PlanFragmentCell2 = [[PlanFragmentTwoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenifier2];
    }
    
    if (indexPath.row == 0) {
        UITableViewCell *cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell addSubview:[self dataLinkTableHeadView]];
        
        return cell;
        
    }else {
        if (self.planFragmentArray.count == 0) {
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
            if ([[self.planFragmentArray[indexPath.row-1] objectForKey:@"recordWhichLineInTheExecution"] isEqualToString:@"1"]) {
                PlanFragmentCell2.IDLable.text            = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
                PlanFragmentCell2.nameLable.text          = [self.planFragmentArray[indexPath.row-1] objectForKey:@"name"];
                PlanFragmentCell2.stateLable.text         = [self.planFragmentArray[indexPath.row-1] objectForKey:@"state"];
                PlanFragmentCell2.activity.hidden         = YES;
                if ([[self.planFragmentArray[indexPath.row-1] objectForKey:@"activity"] isEqualToString:@"0"]) {
                    PlanFragmentCell2.activity.hidden         = YES;
                }else if ([[self.planFragmentArray[indexPath.row-1] objectForKey:@"activity"] isEqualToString:@"1"]) {
                    PlanFragmentCell2.activity.hidden         = NO;
                    [PlanFragmentCell2.activity startAnimating];
                }
                
                return PlanFragmentCell2;
            }else {
                PlanFragmentCell.IDLable.text            = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
                PlanFragmentCell.delegate                = self;
                PlanFragmentCell.nameLable.text          = [self.planFragmentArray[indexPath.row-1] objectForKey:@"name"];
                PlanFragmentCell.stateLable.text         = [self.planFragmentArray[indexPath.row-1] objectForKey:@"state"];
                PlanFragmentCell.activity.hidden         = YES;
                if ([[self.planFragmentArray[indexPath.row-1] objectForKey:@"activity"] isEqualToString:@"0"]) {
                    PlanFragmentCell.activity.hidden         = YES;
                }else if ([[self.planFragmentArray[indexPath.row-1] objectForKey:@"activity"] isEqualToString:@"1"]) {
                    PlanFragmentCell.activity.hidden         = NO;
                    [PlanFragmentCell.activity startAnimating];
                }
                
                if ([[self.planFragmentArray[indexPath.row-1] objectForKey:@"open"] boolValue]) {
                    [PlanFragmentCell.moreOptionsButton setBackgroundImage:[UIImage imageNamed:@"tingzhi"] forState:UIControlStateNormal];
                }else{
                    [PlanFragmentCell.moreOptionsButton setBackgroundImage:[UIImage imageNamed:@"qiyong"] forState:UIControlStateNormal];
                }
            }
        }
    }
    return PlanFragmentCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 40.0;
    }else {
        return 45.0;
    }
}

//列表的头
- (UIView *)dataLinkTableHeadView
{
    UIView *attributeNameView = [[UIView alloc] init];
    attributeNameView.frame   = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    attributeNameView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    
    //背景view下的细线
    UIView *lineView       = [[UIView alloc] init];
    lineView.frame         = CGRectMake(0, 39.5, SCREEN_WIDTH, 0.5);
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
    
    //属性名称lable--状态
    UILabel *lableThr      = [[UILabel alloc] init];
    lableThr.frame         = CGRectMake(lableTwo.frame.origin.x+lableTwo.frame.size.width+100, 0, 55, 40);
    lableThr.text          = @"状态";
    lableThr.textAlignment = NSTextAlignmentLeft;
    lableThr.font          = [UIFont systemFontOfSize:14];
    lableThr.textColor     = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    [attributeNameView addSubview:lableThr];
    
    
    return attributeNameView;
}

#pragma mark - 监听通知
- (void)planFragmentDidShowContextMenu
{
    //移除之前的延迟5s执行的请求
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(circulationRequest) object:nil];
}

- (void)planFragmentDidHideContextMenu
{
    //移除之前的延迟5s执行的请求
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(circulationRequest) object:nil];
    
    //5s后再次请求数据
    [self performSelector:@selector(circulationRequest) withObject:nil afterDelay:5.0];
}

#pragma mark - 网络请求
- (void)firstRefresh
{
    // 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
}

- (void)doRequest
{
    //移除之前的延迟5s执行的请求
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(circulationRequest) object:nil];
    
    NSURL *url         = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/adminmanager/do/plan/gettasklistinfo.do;sessionid=%@",[[IpAndOther shareInstance] getIP],[[IpAndOther shareInstance] getPort],[[IpAndOther shareInstance] getSid]]];
    
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
            
            if (self.planFragmentArray != 0) {
                [self.planFragmentArray removeAllObjects];
            }
            
            if ([[resultDic objectForKey:@"data"] count] != 0) {
                for (int i = 0; i<[[resultDic objectForKey:@"data"] count]; i ++) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"name"] forKey:@"name"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"state"] forKey:@"state"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"open"] forKey:@"open"];
                    [dic setObject:@"0" forKey:@"recordWhichLineInTheExecution"];
                    [self.planFragmentArray addObject:dic];
                }
            }
            
            [self.tableView reloadData];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.planFragmentArray forKey:@"planFragmentArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            //5s后再次请求数据
            [self performSelector:@selector(circulationRequest) withObject:nil afterDelay:5.0];
            
            //停止0.5s后执行刷新列表，并停止刷新的动画
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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

//循环请求
- (void)circulationRequest
{
    //移除之前的延迟5s执行的请求
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(circulationRequest) object:nil];
    
    NSURL *url         = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/adminmanager/do/plan/gettasklistinfo.do;sessionid=%@",[[IpAndOther shareInstance] getIP],[[IpAndOther shareInstance] getPort],[[IpAndOther shareInstance] getSid]]];
    
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
            
            if (self.planFragmentArray != 0) {
                [self.planFragmentArray removeAllObjects];
            }
            
            if ([[resultDic objectForKey:@"data"] count] != 0) {
                for (int i = 0; i<[[resultDic objectForKey:@"data"] count]; i ++) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"name"] forKey:@"name"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"state"] forKey:@"state"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"open"] forKey:@"open"];
                    [dic setObject:@"0" forKey:@"recordWhichLineInTheExecution"];
                    [self.planFragmentArray addObject:dic];
                }
            }
            
            [self.tableView reloadData];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.planFragmentArray forKey:@"planFragmentArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //5s后再次请求数据
            [self performSelector:@selector(circulationRequest) withObject:nil afterDelay:5.0];
            
        }else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"]) {
            
            if (!self.judgeBack) {
                if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"]) {
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:self cancelButtonTitle:@"重试" otherButtonTitles:@"重新登录", nil];
                    [alter show];
                }else {
                    //5s后再次请求数据
                    [self performSelector:@selector(circulationRequest) withObject:nil afterDelay:5.0];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //5s后再次请求数据
        [self performSelector:@selector(circulationRequest) withObject:nil afterDelay:5.0];
        
    }];
    
    [operation start];
}

#pragma mark - 执行的操作
- (void)contextMenuCellDidSelectDeleteOption:(PlanFragmentTableViewCell *)cell
{
    
    //显示改行的旋转等待指示器
    cell.activity.hidden         = NO;
    [cell.activity startAnimating];
    
    int i = [cell.IDLable.text intValue];
    [self.planFragmentArray[i-1] setObject:@"1" forKey:@"activity"];
    
    //记录下哪一行执行了操作，将禁止它在具有左滑出现按钮的操作，记录后并刷新列表
    [_planFragmentArray[i-1] setObject:@"1" forKey:@"recordWhichLineInTheExecution"];
    [self.tableView reloadData];
    
    //影藏侧滑出的按钮
    [super hideMenuOptionsAnimated:YES];
    
    //判断当前网络状况
    if (![self isConnectionAvailable]) {
        [self.tableView headerEndRefreshing];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常，请检查你的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = 10000;
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/plan/executetask.do;sessionid=%@",IP,port,sid];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:cell.nameLable.text,@"TaskName", nil];
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        //删除记录下哪一行执行了操作，记录后并刷新列表
        [_planFragmentArray[i-1] setObject:@"0" forKey:@"recordWhichLineInTheExecution"];
        cell.activity.hidden         = YES;
        [cell.activity stopAnimating];
        [self.planFragmentArray[i-1] setObject:@"0" forKey:@"activity"];
        [self.tableView reloadData];
        
        if (!_judgeBack) {
            
            if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
                
                //等待指示器
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"执行成功";
                
                //返回成功后1s后提示连接成功
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                });
            } else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"]) {
                
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                
                if (!_judgeBack) {
                    if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"]) {
                        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:self cancelButtonTitle:@"重试" otherButtonTitles:@"重新登录", nil];
                        [alter show];
                    }else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alert show];
                    }
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        
        //删除记录下哪一行执行了操作，记录后并刷新列表
        [_planFragmentArray[i-1] setObject:@"0" forKey:@"recordWhichLineInTheExecution"];
        cell.activity.hidden         = YES;
        [cell.activity stopAnimating];
        [self.planFragmentArray[i-1] setObject:@"0" forKey:@"activity"];
        [self.tableView reloadData];
        
        [self.tableView headerEndRefreshing];
        
        if (!_judgeBack) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前无法连接到服务器，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }];
    
    
}

#pragma mark - 启用与静止的操作
- (void)contextMenuCellDidSelectMoreOption:(PlanFragmentTableViewCell *)cell
{
    int ID     = [cell.IDLable.text intValue];
    
    //判断是准备执行禁用操作还是执行启用操作
    if ([[self.planFragmentArray[ID-1] objectForKey:@"open"] boolValue]) {
        [self openAndStop:cell.nameLable.text URL:@"/adminmanager/do/plan/stoptask.do" state:YES];
    }else {
        [self openAndStop:cell.nameLable.text URL:@"/adminmanager/do/plan/starttask.do" state:NO];
    }
}

- (void)openAndStop:(NSString *)string URL:(NSString*)URL state:(BOOL)state
{
    //影藏侧滑出的按钮
    [super hideMenuOptionsAnimated:YES];
    
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    if (state) {
        hud.labelText = @"正在禁用...";
    }else {
        hud.labelText = @"正在启用...";
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    NSURL *url         = [NSURL URLWithString:[[NSString stringWithFormat:@"http://%@:%@%@?TaskName=%@;sessionid=%@",IP,port,URL,string,sid] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TimeoutInterval+20];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            
            //返回成功后2s后提示连接成功
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                hud.mode = MBProgressHUDModeCustomView;
                if (state) {
                    hud.labelText = @"禁用成功";
                }else {
                    hud.labelText = @"启用成功";
                }
                
                //2s后移除等待指示器和覆盖在window上的view
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                    
                    //移除之前的延迟5s执行的请求
                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(circulationRequest) object:nil];
                    
                    [self doRequest];
                });
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
        [self.tableView headerEndRefreshing];
        
        if (!self.judgeBack) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前无法连接到服务器，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        
    }];
    
    [operation start];
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

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
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
    
    //移除之前的延迟5s执行的请求
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(circulationRequest) object:nil];
}


@end
