//
//  DataBackupViewController.m
//  PUER
//
//  Created by admin on 14-8-14.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "DataBackupViewController.h"
#import "DataBackupTwoTableViewCell.h"
#import "LQDataBackupView.h"
#import "LQDataBackupHeaderStyleOne.h"
#import "LQDataMaintenanceTableVC.h"
#import "LQDataMaintenanceTraninfoVC.h"
#import "LQExecutiveSQLVC.h"

@interface DataBackupViewController ()<LQDataBackupViewDelegate,LQDataMaintenanceTableVCDelegate,LQDataMaintenanceTraninfoVCDelegate,LQExecutiveSQLVCDelegate>

@property (nonatomic, strong) LQDataBackupView *dataBackupView;
@property (nonatomic, strong) LQDataBackupView *dataMaintenanceView;
@property (nonatomic, strong) DataBackupTableViewCell *dataBackupCell;

@end

@implementation DataBackupViewController

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
    
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showMeun" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideMeun" object:nil];
    
    //监听滑动菜单的开启和关闭
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMeun) name:@"showMeun" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMeun) name:@"hideMeun" object:nil];
    
    _dataBackupArray = [[NSMutableArray alloc] init];
    
    [self menuButton:@"数据维护"];
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
    _judgeBack                = NO;
}

- (void)doLoading
{
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    //给列表添加耍想的头
    [self.tableView addHeaderWithTarget:self action:@selector(doRequest)];
    
}

- (LQDataBackupView *)dataBackupView
{
    if (_dataBackupView == nil) {
        
        LQDataBackupView *dataBackupView = [LQDataBackupView dataBackupView];
        dataBackupView.dataBackupViewDelegate = self;
        [self.navigationController.view addSubview:dataBackupView];
        dataBackupView.menuHeight = 70;
        dataBackupView.buttonNum = 3;
        _dataBackupView = dataBackupView;
    }
    
    return _dataBackupView;
}

- (LQDataBackupView *)dataMaintenanceView
{
    if (_dataMaintenanceView == nil) {
        
        LQDataBackupView *dataMaintenanceView = [LQDataBackupView dataBackupView];
        dataMaintenanceView.dataBackupViewDelegate = self;
        [self.navigationController.view addSubview:dataMaintenanceView];
        dataMaintenanceView.menuHeight = 140;
        dataMaintenanceView.buttonNum = 8;
        _dataMaintenanceView = dataMaintenanceView;
    }
    
    return _dataMaintenanceView;
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataBackupArray.count == 0) {
        return 2;
    }
    return self.dataBackupArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idenifier = @"cell";
    DataBackupTableViewCell *DataBackupCell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    if (DataBackupCell == nil) {
        DataBackupCell = [[DataBackupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenifier];
    }
    
    static NSString *idenifier2 = @"cell2";
    DataBackupTwoTableViewCell *DataBackupCell2 = [tableView dequeueReusableCellWithIdentifier:idenifier2];
    if (DataBackupCell2 == nil) {
        DataBackupCell2 = [[DataBackupTwoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenifier2];
    }
    
    
    if (indexPath.row == 0) {
        UITableViewCell *cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        LQDataBackupHeaderStyleOne *style = [LQDataBackupHeaderStyleOne dataBackupHeaderStyleOne];
        style.titleNames = @[@"ID",@"名称",@"备份路径"];
        
        [cell addSubview:style];
        
        return cell;
        
    }else {
        if (self.dataBackupArray.count == 0) {
            
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
            if ([[self.dataBackupArray[indexPath.row-1] objectForKey:@"recordWhichLineInTheExecution"] isEqualToString:@"1"]) {
                DataBackupCell2.IDLable.text            = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
                DataBackupCell2.nameLable.text          = [self.dataBackupArray[indexPath.row-1] objectForKey:@"connname"];
                DataBackupCell2.backupPathLable.text    = [self.dataBackupArray[indexPath.row-1] objectForKey:@"backupdisk"];
                DataBackupCell2.activity.hidden         = YES;
                if ([[self.dataBackupArray[indexPath.row-1] objectForKey:@"activity"] isEqualToString:@"0"]) {
                    DataBackupCell2.activity.hidden         = YES;
                }else if ([[self.dataBackupArray[indexPath.row-1] objectForKey:@"activity"] isEqualToString:@"1"]) {
                    DataBackupCell2.activity.hidden         = NO;
                    [DataBackupCell2.activity startAnimating];
                }
                
                return DataBackupCell2;
            }else {
                DataBackupCell.IDLable.text            = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
                DataBackupCell.delegate                = self;
                DataBackupCell.nameLable.text          = [self.dataBackupArray[indexPath.row-1] objectForKey:@"connname"];
                DataBackupCell.backupPathLable.text    = [self.dataBackupArray[indexPath.row-1] objectForKey:@"backupdisk"];
                DataBackupCell.activity.hidden         = YES;
                if ([[self.dataBackupArray[indexPath.row-1] objectForKey:@"activity"] isEqualToString:@"0"]) {
                    DataBackupCell.activity.hidden         = YES;
                }else if ([[self.dataBackupArray[indexPath.row-1] objectForKey:@"activity"] isEqualToString:@"1"]) {
                    DataBackupCell.activity.hidden         = NO;
                    [DataBackupCell.activity startAnimating];
                }
            }
        }
    }
    return DataBackupCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 40.0;
    }else {
        return 45.0;
    }
}

#pragma mark - 网络请求
- (void)firstRefresh
{
    // 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
}

- (void)doRequest
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
    
    NSURL *url         = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/adminmanager/do/db/getdbconnlist.do;sessionid=%@",IP,port,sid]];
    
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
            
            if (self.dataBackupArray != 0) {
                [self.dataBackupArray removeAllObjects];
            }
            
            if ([[resultDic objectForKey:@"data"] count] != 0) {
                for (int i = 0; i<[[resultDic objectForKey:@"data"] count]; i ++) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"connname"] forKey:@"connname"];
                    [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"backupdisk"] forKey:@"backupdisk"];
                    [dic setObject:@"0" forKey:@"recordWhichLineInTheExecution"];
                    [self.dataBackupArray addObject:dic];
                }
            }
            
            [self.tableView reloadData];
            
            [ud setObject:self.dataBackupArray forKey:@"dataBackupArray"];
            [ud synchronize];
            
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
            if (error.code == -1001) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接超时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常,请检查你的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    }];
    
    [operation start];
    
}

#pragma mark - DataBackupDelegate
- (void)dataBackupMenuDidClose:(LQDataBackupView *)dataBackupView
{
    //影藏侧滑出的按钮
    [super hideMenuOptionsAnimated:YES];
}

/**
 *  完全备份
 */
- (void)dataBackupButtonDidCompleteBackup:(LQDataBackupView *)dataBackupView
{
    DataBackupTableViewCell *cell = self.dataBackupCell;
    self.dataBackupCell = nil;
    
    cell.activity.hidden         = NO;
    [cell.activity startAnimating];
    
    //防止数据重用导致圈圈消失
    int i = [cell.IDLable.text intValue];
    [self.dataBackupArray[i-1] setObject:@"1" forKey:@"activity"];
    
    //记录下哪一行执行了操作，将禁止它在具有左滑出现按钮的操作，记录后并刷新列表
    [_dataBackupArray[i-1] setObject:@"1" forKey:@"recordWhichLineInTheExecution"];
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
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/db/backupdb.do;sessionid=%@",IP,port,sid];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:cell.nameLable.text,@"ConnName",@"com",@"BackupType", nil];
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        //删除记录下哪一行执行了操作，记录后并刷新列表
        [_dataBackupArray[i-1] setObject:@"0" forKey:@"recordWhichLineInTheExecution"];
        cell.activity.hidden         = YES;
        [cell.activity stopAnimating];
        [self.dataBackupArray[i-1] setObject:@"0" forKey:@"activity"];
        [self.tableView reloadData];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            
            if (!_judgeBack) {
                //等待指示器
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"完全备份成功";
                
                //返回成功后2s后提示连接成功
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                });
            }
            
        }else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"]) {
            
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
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //删除记录下哪一行执行了操作，记录后并刷新列表
        [_dataBackupArray[i-1] setObject:@"0" forKey:@"recordWhichLineInTheExecution"];
        cell.activity.hidden         = YES;
        [cell.activity stopAnimating];
        [self.dataBackupArray[i-1] setObject:@"0" forKey:@"activity"];
        [self.tableView reloadData];
        
        [self.tableView headerEndRefreshing];
        
        if (!self.judgeBack) {
            if (error.code == -1001) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接超时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常,请检查你的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    }];
    
    self.dataBackupView.open = NO;
}

/**
 *  差异备份
 */
- (void)dataBackupButtonDidDifferentialBackup:(LQDataBackupView *)dataBackupView
{
    DataBackupTableViewCell *cell = self.dataBackupCell;
    self.dataBackupCell = nil;
    
    cell.activity.hidden         = NO;
    [cell.activity startAnimating];
    
    //防止数据重用导致圈圈消失
    int i = [cell.IDLable.text intValue];
    [self.dataBackupArray[i-1] setObject:@"1" forKey:@"activity"];
    
    //记录下哪一行执行了操作，将禁止它在具有左滑出现按钮的操作，记录后并刷新列表
    [_dataBackupArray[i-1] setObject:@"1" forKey:@"recordWhichLineInTheExecution"];
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
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/db/backupdb.do;sessionid=%@",IP,port,sid];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:cell.nameLable.text,@"ConnName",@"dif",@"BackupType", nil];
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        //删除记录下哪一行执行了操作，记录后并刷新列表
        [_dataBackupArray[i-1] setObject:@"0" forKey:@"recordWhichLineInTheExecution"];
        cell.activity.hidden         = YES;
        [cell.activity stopAnimating];
        [self.dataBackupArray[i-1] setObject:@"0" forKey:@"activity"];
        [self.tableView reloadData];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            
            if (!_judgeBack) {
                //等待指示器
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"差异备份成功";
                
                //返回成功后2s后提示连接成功
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                });
            }
            
        }else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"]) {
            
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
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //删除记录下哪一行执行了操作，记录后并刷新列表
        [_dataBackupArray[i-1] setObject:@"0" forKey:@"recordWhichLineInTheExecution"];
        cell.activity.hidden         = YES;
        [cell.activity stopAnimating];
        [self.dataBackupArray[i-1] setObject:@"0" forKey:@"activity"];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        
        if (!self.judgeBack) {
            if (error.code == -1001) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接超时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常,请检查你的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    }];
    
    self.dataBackupView.open = NO;
}

/**
 *  数据收缩
 */
- (void)dataBackupButtonDidDataShrinkage:(LQDataBackupView *)dataBackupView
{
    DataBackupTableViewCell *cell = self.dataBackupCell;
    self.dataBackupCell = nil;
    
    cell.activity.hidden         = NO;
    [cell.activity startAnimating];
    
    //防止数据重用导致圈圈消失
    int i = [cell.IDLable.text intValue];
    [self.dataBackupArray[i-1] setObject:@"1" forKey:@"activity"];
    
    //记录下哪一行执行了操作，将禁止它在具有左滑出现按钮的操作，记录后并刷新列表
    [_dataBackupArray[i-1] setObject:@"1" forKey:@"recordWhichLineInTheExecution"];
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
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/db/shrinkdb.do;sessionid=%@",IP,port,sid];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:cell.nameLable.text,@"ConnName", nil];
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        //删除记录下哪一行执行了操作，记录后并刷新列表
        [_dataBackupArray[i-1] setObject:@"0" forKey:@"recordWhichLineInTheExecution"];
        cell.activity.hidden         = YES;
        [cell.activity stopAnimating];
        [self.dataBackupArray[i-1] setObject:@"0" forKey:@"activity"];
        [self.tableView reloadData];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openMenuOptions" object:cell.IDLable.text];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            
            if (!_judgeBack) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"收缩成功";
                
                //返回成功后1s后提示连接成功
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                });
            }
            
        }else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"]) {
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
        
        //删除记录下哪一行执行了操作，记录后并刷新列表
        [_dataBackupArray[i-1] setObject:@"0" forKey:@"recordWhichLineInTheExecution"];
        cell.activity.hidden         = YES;
        [cell.activity stopAnimating];
        [self.dataBackupArray[i-1] setObject:@"0" forKey:@"activity"];
        [self.tableView reloadData];
        
        [self.tableView headerEndRefreshing];
        
        if (!self.judgeBack) {
            if (error.code == -1001) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接超时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常,请检查你的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
        
    }];
    
    self.dataBackupView.open = NO;
}

/**
 *  查看表/查看视图/查看函数/存储过程/触发器的集合体
 *
 *  @param mainURLStr 区分功能的主要一段的URL
 *  @param viewTitle  界面标题
 *  @param fileName   文件名
 */
- (void)dataMaintenanceButtonWithMainURLStr:(NSString *)mainURLStr viewTitle:(NSString *)viewTitle titleNames:(NSArray *)titleNames functionName:(NSString *)functionName
{
    self.dataMaintenanceView.open = NO;
    
    LQDataMaintenanceTableVC *table = [[LQDataMaintenanceTableVC alloc] init];
    table.delegate = self;
    table.mainURLStr = mainURLStr;
    table.viewTitle = viewTitle;
    table.titleNames = titleNames;
    table.functionName = functionName;
    table.connName = self.dataBackupCell.nameLable.text;
    [self.navigationController pushViewController:table animated:YES];
}

/**
 *  查看表
 */
- (void)dataMaintenanceButtonWithTable:(LQDataBackupView *)dataBackupView
{
    NSArray *array = @[@"ID",@"表名",@"创建/修改时间"];
    [self dataMaintenanceButtonWithMainURLStr:@"gettablelist" viewTitle:@"查看表" titleNames:array functionName:DataMaintenanceFunctionNames[0]];
}

/**
 * 查看视图
 */
- (void)dataMaintenanceButtonWithView:(LQDataBackupView *)dataBackupView
{
    NSArray *array = @[@"ID",@"视图名",@"创建/修改时间"];
    [self dataMaintenanceButtonWithMainURLStr:@"getviewlist" viewTitle:@"查看视图" titleNames:array functionName:DataMaintenanceFunctionNames[1]];
}

/**
 *  查看函数
 */
- (void)dataMaintenanceButtonWithFunction:(LQDataBackupView *)dataBackupView
{
    NSArray *array = @[@"ID",@"函数名",@"创建/修改时间"];
    [self dataMaintenanceButtonWithMainURLStr:@"getfunlist" viewTitle:@"查看函数" titleNames:array functionName:DataMaintenanceFunctionNames[2]];
}

/**
 *  存储过程
 */
- (void)dataMaintenanceButtonWithStoredProcedure:(LQDataBackupView *)dataBackupView
{
    NSArray *array = @[@"ID",@"存储过程名",@"创建/修改时间"];
    [self dataMaintenanceButtonWithMainURLStr:@"getproclist" viewTitle:@"查看存储过程" titleNames:array functionName:DataMaintenanceFunctionNames[3]];
}

/**
 *  触发器
 */
- (void)dataMaintenanceButtonWithTrigger:(LQDataBackupView *)dataBackupView
{
    NSArray *array = @[@"ID",@"触发器名",@"创建/修改时间"];
    [self dataMaintenanceButtonWithMainURLStr:@"gettriggerlist" viewTitle:@"查看触发器" titleNames:array functionName:DataMaintenanceFunctionNames[4]];
}

- (void)dataMaintenanceButtonWithActivityMonitoring:(LQDataBackupView *)dataBackupView
{
    self.dataMaintenanceView.open = NO;
    
    LQDataMaintenanceTraninfoVC *traninfo = [[LQDataMaintenanceTraninfoVC alloc] init];
    traninfo.delegate = self;
    traninfo.connName = self.dataBackupCell.nameLable.text;
    [self.navigationController pushViewController:traninfo animated:YES];

}

- (void)dataMaintenanceButtonWithFile:(LQDataBackupView *)dataBackupView
{
    NSArray *array = @[@"ID",@"文件名称",@"文件大小"];
    [self dataMaintenanceButtonWithMainURLStr:@"getdbinfo" viewTitle:@"查看文件" titleNames:array functionName:DataMaintenanceFunctionNames[5]];
}

- (void)dataMaintenanceButtonWithSQL:(LQDataBackupView *)dataBackupView
{
    self.dataMaintenanceView.open = NO;
    
    LQExecutiveSQLVC *sql = [[LQExecutiveSQLVC alloc] init];
    sql.connName = self.dataBackupCell.nameLable.text;
    sql.delegate = self;
    [self.navigationController pushViewController:sql animated:YES];
}

#pragma mark - LQDataMaintenanceVCDelegate
- (void)dataMaintenanceVCDidPop:(LQDataMaintenanceTableVC *)dataMaintenanceTableVC
{
    self.dataMaintenanceView.open = YES;
}

#pragma mark - LQDataMaintenanceTraninfoVCDelegate
- (void)dataMaintenanceTraninfoVCDidPop:(LQDataMaintenanceTraninfoVC *)dataMaintenanceTraninfoVC
{
    self.dataMaintenanceView.open = YES;
}

#pragma mark - LQExecutiveSQLVCDelegate
- (void)LQExecutiveSQLVCDidPop:(LQExecutiveSQLVC *)executiveSQLVC
{
    self.dataMaintenanceView.open = YES;
}

#pragma mark - 数据维护
- (void)contextMenuCellDidSelectDeleteOption:(DataBackupTableViewCell *)cell
{
    self.dataBackupCell = cell;
    self.dataMaintenanceView.open = YES;
}

#pragma mark - 数据备份
- (void)contextMenuCellDidSelectMoreOption:(DataBackupTableViewCell *)cell
{
    self.dataBackupCell = cell;
    self.dataBackupView.open = YES;
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

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - view即将移除时
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.judgeBack = YES;
}

@end
