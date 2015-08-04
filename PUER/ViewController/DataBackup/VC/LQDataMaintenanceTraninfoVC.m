//
//  LQDataMaintenanceTraninfoVC.m
//  PUER
//
//  Created by admin on 15/6/3.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "LQDataMaintenanceTraninfoVC.h"
#import "LQDataBackupJson.h"
#import "LQDatamaintenanceTraninfoCell.h"
#import "NoContentTableViewCell.h"
#import "LQDataBackupHeaderStyleTwo.h"
#import "LQDataMaintenanceTraninfoItems.h"
#import "LQDataMaintenanceOverlayView.h"
#import "LQDataMaintenanceTraninfoDetailVC.h"
#import "LQDataMaintenanceDetailsVC.h"

@interface LQDataMaintenanceTraninfoVC ()<UITableViewDataSource,UITableViewDelegate,LQDatamaintenanceTraninfoCellDelegate,LQDataMaintenanceOverlayViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) LQDatamaintenanceTraninfoCell *cellDisplayingMenuOptions;
@property (strong, nonatomic) LQDataMaintenanceOverlayView *overlayView;
@property (assign, nonatomic) BOOL customEditing;
@property (assign, nonatomic) BOOL customEditingAnimationInProgress;
@property (strong, nonatomic) UIBarButtonItem *editBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *doneBarButtonItem;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) LQDatamaintenanceTraninfoCell *traninfoCell;

@end

@implementation LQDataMaintenanceTraninfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super setDataBackVCTitile:@"查看活动监视" viceTitle:self.connName];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    //设置左滑按钮的属性
    self.customEditing = self.customEditingAnimationInProgress = NO;
    
    [self loading];
    [self firstRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _judgeBack                = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.judgeBack = YES;
    
    if (![[self.navigationController viewControllers] containsObject:self])
    {
        if ([self.delegate respondsToSelector:@selector(dataMaintenanceTraninfoVCDidPop:)]) {
            [self.delegate dataMaintenanceTraninfoVCDidPop:self];
        }
    }
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    
    return  _dataArray;
}

- (void)setConnName:(NSString *)connName
{
    _connName = connName;
}

- (void)loading
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self.tableView addHeaderWithTarget:self action:@selector(refershTableView)];
}

- (void)refershTableView
{
    [self request];
}

- (void)firstRefresh
{
    // 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
}

- (void)request
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/db/gettraninfolist.do;sessionid=%@",IP,port,sid];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"ConnName": self.connName};
    
    [manager POST:urlStr parameters:parameter timeoutInterval:20 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.dataArray removeAllObjects];
        
        LQDataBackupJson *data = [LQDataBackupJson objectWithKeyValues:operation.responseString];
        
        if ([data.state.returnn isEqualToString:@"true"]) {
            for (LQDataBackupTableItems *items in data.data.traninfoitems) {
                
                [self.dataArray addObject:items];
            }
            [self.tableView reloadData];
            
            //停止0.5s后执行刷新列表，并停止刷新的动画
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView headerEndRefreshing];
            });
        }else {
            [self.tableView headerEndRefreshing];
            
            if (!self.judgeBack) {
                if ([data.state.code isEqualToString:@"1006"]) {
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:data.state.info
                                                                   delegate:self
                                                          cancelButtonTitle:@"重试"
                                                          otherButtonTitles:@"重新登录", nil];
                    alter.tag = 1000;
                    [alter show];
                }else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:data.state.info
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles: nil];
                    [alert show];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView headerEndRefreshing];
        
        if (!self.judgeBack) {
            if (error.code == -1001) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"网络连接超时"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles: nil];
                [alert show];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"网络异常,请检查你的网络"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles: nil];
                [alert show];
            }
        }
    }];
}

/**
 *  删除进程
 */
- (void)deleteprocessID
{
    LQDatamaintenanceTraninfoCell *cell = self.traninfoCell;
    self.traninfoCell = nil;
    
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在删除…";
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/db/deletettraninfo.do;sessionid=%@",IP,port,sid];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"ConnName": self.connName,@"ProcessId": cell.processid.text};
    
    [manager POST:urlStr parameters:parameter timeoutInterval:20 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        

        LQDataBackupJson *data = [LQDataBackupJson objectWithKeyValues:operation.responseString];
        
        if ([data.state.returnn isEqualToString:@"true"]) {
            
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"删除成功";
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                int row = [cell.IDLable.text intValue]-1;
                [self.dataArray removeObjectAtIndex:row];
                [self.tableView reloadData];
            });
            
        }else {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if (!self.judgeBack) {
                if ([data.state.code isEqualToString:@"1006"]) {
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:data.state.info
                                                                   delegate:self
                                                          cancelButtonTitle:@"重试"
                                                          otherButtonTitles:@"重新登录", nil];
                    alter.tag = 1001;
                    [alter show];
                }else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:data.state.info
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles: nil];
                    [alert show];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (!self.judgeBack) {
            if (error.code == -1001) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"网络连接超时"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles: nil];
                [alert show];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"网络异常,请检查你的网络"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles: nil];
                [alert show];
            }
        }
    }];
}

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000 || alertView.tag == 1001) {
        if (buttonIndex == 1) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }else {
        if (buttonIndex == 1) {
            [self deleteprocessID];
        }
    }
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count == 0) {
        return 2;
    }
    return self.dataArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *idenifier = @"headerCell";
        UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:idenifier];
        if (cell == nil) {
            cell =
            [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        LQDataBackupHeaderStyleTwo *style = [LQDataBackupHeaderStyleTwo DataBackupHeaderStyleTwo];
        style.titleNames = @[@"ID",@"进程ID",@"状态",@"开启的事务"];
        
        [cell addSubview:style];
        
        return cell;
        
    }else {
        if (self.dataArray.count == 0) {
            NoContentTableViewCell *cell = [NoContentTableViewCell noContentTableViewCellWithTableView:tableView];
            return cell;
        }
        
        LQDatamaintenanceTraninfoCell *cell = [LQDatamaintenanceTraninfoCell datamaintenanceTraninfoCellWithTableView:tableView];
        
        LQDataMaintenanceTraninfoItems *item = self.dataArray[indexPath.row-1];
        
        cell.delegate = self;
        cell.IDLable.text = [NSString stringWithFormat:@"%ld",indexPath.row];
        cell.processid.text = item.processid;
        cell.status.text = item.status;
        cell.opentransactions.text = item.opentransactions;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return TableViewHeaderHeight;
    }else {
        return cellHeight;
    }
}


//==========================================
#pragma mark - 设置左滑按钮
//==========================================
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView cellForRowAtIndexPath:indexPath] == self.cellDisplayingMenuOptions) {
        [self hideMenuOptionsAnimated:YES];
        return NO;
    }
    return YES;
}

- (UIView *)overlayView:(LQDataMaintenanceOverlayView *)view didHitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL shouldIterceptTouches = YES;
    CGPoint location = [self.tableView convertPoint:point fromView:view];
    CGRect rect = [self.tableView convertRect:self.cellDisplayingMenuOptions.frame toView:self.tableView];
    shouldIterceptTouches = CGRectContainsPoint(rect, location);
    if (!shouldIterceptTouches) {
        [self hideMenuOptionsAnimated:YES];
    }
    return (shouldIterceptTouches) ? [self.cellDisplayingMenuOptions hitTest:point withEvent:event] : view;
}

- (void)hideMenuOptionsAnimated:(BOOL)animated
{
    __block LQDataMaintenanceTraninfoVC *weakSelf = self;
    [self.cellDisplayingMenuOptions setMenuOptionsViewHidden:YES animated:animated completionHandler:^{
        weakSelf.customEditing = NO;
    }];
}

- (void)setCustomEditing:(BOOL)customEditing
{
    if (_customEditing != customEditing) {
        _customEditing = customEditing;
        self.tableView.scrollEnabled = !customEditing;
        if (customEditing) {
            if (!_overlayView) {
                _overlayView = [[LQDataMaintenanceOverlayView alloc] initWithFrame:self.view.bounds];
                _overlayView.backgroundColor = [UIColor clearColor];
                _overlayView.delegate = self;
            }
            self.overlayView.frame = self.view.bounds;
            [self.view addSubview:_overlayView];
            if (self.shouldDisableUserInteractionWhileEditing) {
                for (UIView *view in self.tableView.subviews) {
                    if ((view.gestureRecognizers.count == 0) && view != self.cellDisplayingMenuOptions && view != self.overlayView) {
                        view.userInteractionEnabled = NO;
                    }
                }
            }
        } else {
            self.cellDisplayingMenuOptions = nil;
            [self.overlayView removeFromSuperview];
            for (UIView *view in self.tableView.subviews) {
                if ((view.gestureRecognizers.count == 0) && view != self.cellDisplayingMenuOptions && view != self.overlayView) {
                    view.userInteractionEnabled = YES;
                }
            }
        }
    }
}

#pragma mark - 查看
- (void)contextMenuCellDidSee:(LQDatamaintenanceTraninfoCell *)cell
{
    [cell.superview sendSubviewToBack:cell];
    [self hideMenuOptionsAnimated:YES];
    
    int row = [cell.IDLable.text intValue]-1;
    
    LQDataMaintenanceTraninfoDetailVC *detail = [[LQDataMaintenanceTraninfoDetailVC alloc] init];
    detail.item = self.dataArray[row];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - 运行做后一次脚本
- (void)contextMenuCellDidLastRun:(LQDatamaintenanceTraninfoCell *)cell
{
    [self hideMenuOptionsAnimated:YES];
    
    LQDataMaintenanceDetailsVC *detail = [[LQDataMaintenanceDetailsVC alloc] init];
    detail.ConnName = self.connName;
    detail.infoParameterName = @"ProcessId";
    detail.infoName = cell.processid.text;
    detail.mainUrlStr = @"getttraninfolastsql";
    detail.navTitle = [NSString stringWithFormat:@"SQL-进程ID:%@-最后一次脚本",cell.processid.text];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - 删除
- (void)contextMenuCellDidDelete:(LQDatamaintenanceTraninfoCell *)cell
{
    [self hideMenuOptionsAnimated:YES];
    
    self.traninfoCell = cell;
    
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"删除进程"
                                                    message:[NSString stringWithFormat:@"确定要删除%@进程吗？",cell.processid.text]
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alter.tag = 2000;
    [alter show];
}

#pragma mark -
- (void)contextMenuDidHideInCell:(LQDatamaintenanceTraninfoCell *)cell
{
    self.customEditing = NO;
    self.customEditingAnimationInProgress = NO;
}

- (void)contextMenuDidShowInCell:(LQDatamaintenanceTraninfoCell *)cell
{
    self.cellDisplayingMenuOptions = cell;
    self.customEditingAnimationInProgress = NO;
    self.customEditing = YES;
}

- (void)contextMenuWillHideInCell:(LQDatamaintenanceTraninfoCell *)cell
{
    self.customEditingAnimationInProgress = YES;
}

- (void)contextMenuWillShowInCell:(LQDatamaintenanceTraninfoCell *)cell
{
    self.customEditingAnimationInProgress = YES;
}

- (BOOL)shouldShowMenuOptionsViewInCell:(LQDatamaintenanceTraninfoCell *)cell
{
    return self.customEditing && !self.customEditingAnimationInProgress;
}


@end
