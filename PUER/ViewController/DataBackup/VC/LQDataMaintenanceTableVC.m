//
//  LQDataMaintenanceVC.m
//  PUER
//
//  Created by admin on 15/6/2.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "LQDataMaintenanceTableVC.h"
#import "LQDataBackupHeaderStyleOne.h"
#import "LQDataBackupJson.h"
#import "LQDataMaintenanceTableCell.h"
#import "LQDataMaintenanceOverlayView.h"
#import "LQDataBackupTableItems.h"
#import "NoContentTableViewCell.h"
#import "LQDataMaintenanceDbCell.h"
#import "LQDataMaintenanceDbItems.h"
#import "LQDataMaintenanceDetailsVC.h"
#import "LQDataMaintenanceDbDetailVC.h"

@interface LQDataMaintenanceTableVC ()<UITableViewDataSource,UITableViewDelegate,LQDataMaintenanceOverlayViewDelegate,LQDataMaintenanceTableCellDelegate,UIAlertViewDelegate,LQDataMaintenanceDbCellDelegate>

@property (strong, nonatomic) LQDataMaintenanceTableCell *cellDisplayingMenuOptions;
@property (strong, nonatomic) LQDataMaintenanceOverlayView *overlayView;
@property (assign, nonatomic) BOOL customEditing;
@property (assign, nonatomic) BOOL customEditingAnimationInProgress;
@property (strong, nonatomic) UIBarButtonItem *editBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *doneBarButtonItem;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation LQDataMaintenanceTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super setDataBackVCTitile:self.viewTitle viceTitle:self.connName];
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
        if ([self.delegate respondsToSelector:@selector(dataMaintenanceVCDidPop:)]) {
            [self.delegate dataMaintenanceVCDidPop:self];
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

- (void)setTitleNames:(NSArray *)titleNames
{
    _titleNames = titleNames;
}

- (void)setViewTitle:(NSString *)viewTitle
{
    _viewTitle = viewTitle;
}

- (void)setMainURLStr:(NSString *)mainURLStr
{
    _mainURLStr = mainURLStr;
}

- (void)setFunctionName:(NSString *)functionName
{
    _functionName = functionName;
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

- (void)request
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/db/%@.do;sessionid=%@",IP,port,self.mainURLStr,sid];
    NSLog(@"%@",urlStr);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"ConnName": self.connName};
    
    [manager POST:urlStr parameters:parameter timeoutInterval:20 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.dataArray removeAllObjects];
        
        LQDataBackupJson *data = [LQDataBackupJson objectWithKeyValues:operation.responseString];
        
        if ([data.state.returnn isEqualToString:@"true"]) {
            
            if ([self.functionName isEqualToString:DataMaintenanceFunctionNames[0]]) {
                for (LQDataBackupTableItems *items in data.data.tableitems) {
                    [self.dataArray addObject:items];
                }
            }else if ([self.functionName isEqualToString:DataMaintenanceFunctionNames[1]]) {
                for (LQDataBackupTableItems *items in data.data.viewitems) {
                    
                    [self.dataArray addObject:items];
                }
            }else if ([self.functionName isEqualToString:DataMaintenanceFunctionNames[2]]) {
                for (LQDataBackupTableItems *items in data.data.funitems) {
                    
                    [self.dataArray addObject:items];
                }
            }else if ([self.functionName isEqualToString:DataMaintenanceFunctionNames[3]]) {
                for (LQDataBackupTableItems *items in data.data.procitems) {
                    
                    [self.dataArray addObject:items];
                }
            }else if ([self.functionName isEqualToString:DataMaintenanceFunctionNames[4]]) {
                for (LQDataBackupTableItems *items in data.data.triggeritems) {
                    
                    [self.dataArray addObject:items];
                }
            }else {
                for (LQDataBackupTableItems *items in data.data.dbitems) {
                    
                    [self.dataArray addObject:items];
                }
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
 *  初次进入刷新
 */
- (void)firstRefresh
{
    // 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
}

//下啦刷新列表
- (void)refershTableView
{
    [self request];
}

/**
 *  查看详情
 */
- (void)doSeeDetailsWithCell:(LQDataMaintenanceTableCell *)cell
{
    //查看文件详情
    if ([self.functionName isEqualToString:DataMaintenanceFunctionNames[5]]) {
        
        int row = [cell.IDLable.text intValue]-1;
        LQDataMaintenanceDbItems *item = self.dataArray[row];
        
        LQDataMaintenanceDbDetailVC *dbDetailVC = [[LQDataMaintenanceDbDetailVC alloc] init];
        dbDetailVC.dbItem = item;
        [self.navigationController pushViewController:dbDetailVC animated:YES];
        
        return;
    }
    
    //查看表、视图、函数、、、
    LQDataMaintenanceDetailsVC *detailsVC = [[LQDataMaintenanceDetailsVC alloc] init];
    detailsVC.ConnName = self.connName;
    detailsVC.infoName = cell.nameLable.text;
    detailsVC.navTitle = [NSString stringWithFormat:@"SQL-%@",cell.nameLable.text];
    if ([self.functionName isEqualToString:DataMaintenanceFunctionNames[0]]) {
        detailsVC.infoParameterName = @"TableName";
        detailsVC.mainUrlStr = @"gettableinfo";
    }else if ([self.functionName isEqualToString:DataMaintenanceFunctionNames[1]]){
        detailsVC.infoParameterName = @"ViewName";
        detailsVC.mainUrlStr = @"getviewinfo";
    }else if ([self.functionName isEqualToString:DataMaintenanceFunctionNames[2]]){
        detailsVC.infoParameterName = @"FunName";
        detailsVC.mainUrlStr = @"getfuninfo";
    }else if ([self.functionName isEqualToString:DataMaintenanceFunctionNames[3]]){
        detailsVC.infoParameterName = @"ProcName";
        detailsVC.mainUrlStr = @"getprocinfo";
    }else if ([self.functionName isEqualToString:DataMaintenanceFunctionNames[4]]){
        detailsVC.infoParameterName = @"TriggerName";
        detailsVC.mainUrlStr = @"gettriggerinfo";
    }
    
    [self.navigationController pushViewController:detailsVC animated:YES];
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
        
        LQDataBackupHeaderStyleOne *style = [LQDataBackupHeaderStyleOne dataBackupHeaderStyleOne];
        
        style.titleNames = self.titleNames;
        
        [cell addSubview:style];
        
        return cell;
    }else {
        //判断是否为无内容
        if (self.dataArray.count == 0) {
            NoContentTableViewCell *cell = [NoContentTableViewCell noContentTableViewCellWithTableView:tableView];
            return cell;
        }
        
        //判断是否是“文件”界面
        if ([self.mainURLStr isEqualToString:@"getdbinfo"]) {
            LQDataMaintenanceDbCell *cell = [LQDataMaintenanceDbCell dataMaintenanceDbCellWithTableView:tableView];
            
            cell.IDLable.text = [NSString stringWithFormat:@"%ld",indexPath.row];
            cell.delegate = self;
            LQDataMaintenanceDbItems *item = self.dataArray[indexPath.row-1];
            cell.nameLable.text = item.name;
            cell.sizeLable.text = [NSString stringWithFormat:@"%.2f(MB)",item.size];
            
            return cell;
        }
        
        LQDataMaintenanceTableCell *cell = [LQDataMaintenanceTableCell dataMaintenanceTableCellWithTableView:tableView];
        
        cell.IDLable.text = [NSString stringWithFormat:@"%ld",indexPath.row];
        cell.delegate = self;
        LQDataBackupTableItems *item = self.dataArray[indexPath.row-1];
        cell.nameLable.text = item.name;
        cell.createdateLable.text = item.createdate;
        cell.modifydateLable.text = item.modifydate;
        
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

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self dismissViewControllerAnimated:NO completion:nil];
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
    __block LQDataMaintenanceTableVC *weakSelf = self;
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

- (void)contextMenuCellDidSee:(LQDataMaintenanceTableCell *)cell
{
    [cell.superview sendSubviewToBack:cell];
    [self hideMenuOptionsAnimated:YES];
    
    [self doSeeDetailsWithCell:cell];
}

- (void)contextMenuDidHideInCell:(LQDataMaintenanceTableCell *)cell
{
    self.customEditing = NO;
    self.customEditingAnimationInProgress = NO;
}

- (void)contextMenuDidShowInCell:(LQDataMaintenanceTableCell *)cell
{
    self.cellDisplayingMenuOptions = cell;
    self.customEditingAnimationInProgress = NO;
    self.customEditing = YES;
}

- (void)contextMenuWillHideInCell:(LQDataMaintenanceTableCell *)cell
{
    self.customEditingAnimationInProgress = YES;
}

- (void)contextMenuWillShowInCell:(LQDataMaintenanceTableCell *)cell
{
    self.customEditingAnimationInProgress = YES;
}

- (BOOL)shouldShowMenuOptionsViewInCell:(LQDataMaintenanceTableCell *)cell
{
    return self.customEditing && !self.customEditingAnimationInProgress;
}

@end
