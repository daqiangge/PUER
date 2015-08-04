//
//  LQResourcesTableViewController.m
//  PUER
//
//  Created by admin on 15/3/24.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "LQResourcesTableViewController.h"
#import "LQResourcesTableViewCell.h"
#import "LQNullDataTableViewCell.h"
#import "LQResourcesFile.h"
#import "LQResourcesFolder.h"
#import "LQPreviewVC.h"

@interface LQResourcesTableViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *sourceArray;
@property (nonatomic, strong) NSMutableArray *fileArray;
@property (nonatomic, strong) NSMutableArray *folderArray;
@property BOOL judgeBack;//判断是否以执行反悔按钮操作

@end

@implementation LQResourcesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [super setNavTitle:self.titleStr];
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载…";
    
    [self requestData];
    
    [self.tableView addHeaderWithTarget:self action:@selector(requestData)];
    
    //返回根目录按钮设置
    if (self.navigationController.viewControllers.count > 3)
    {
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"rootDirectory"] style:UIBarButtonItemStyleBordered target:self action:@selector(backRootDirectory)];
        rightBtn.imageInsets = UIEdgeInsetsMake(20, 35, 20, 5);
        self.navigationItem.rightBarButtonItem = rightBtn;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.judgeBack  = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)fileArray
{
    if (_fileArray == nil)
    {
        _fileArray = [NSMutableArray array];
    }
    
    return _fileArray;
}

- (NSMutableArray *)folderArray
{
    if (_folderArray == nil)
    {
        _folderArray = [NSMutableArray array];
    }
    
    return _folderArray;
}

- (void)backRootDirectory
{
    [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
}

#pragma mark - Table view Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //如果为空则显示“无内容”
    if (self.fileArray.count == 0 && self.folderArray.count == 0)
    {
        return 1;
    }
    
    return self.fileArray.count + self.folderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果为空则显示“无内容”
    if (self.fileArray.count == 0 && self.folderArray.count == 0)
    {
        LQNullDataTableViewCell *cell = [LQNullDataTableViewCell cellWithTableView:tableView];
        return cell;
    }
    
    LQResourcesTableViewCell *cell = [LQResourcesTableViewCell cellWithTableView:tableView];
    
    if (indexPath.row < self.folderArray.count)
    {
        LQResourcesFolder *folder = self.folderArray[indexPath.row];
        cell.resourcesFolder = folder;
    }
    else
    {
        LQResourcesFile *file = self.fileArray[indexPath.row - self.folderArray.count];
        cell.resourcesFile = file;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果为空则显示“无内容”
    if (self.fileArray.count == 0 && self.folderArray.count == 0)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    if (indexPath.row < self.folderArray.count)
    {
        LQResourcesFolder *folder = self.folderArray[indexPath.row];
        
        NSString *filePath;
        if ([self.filePath isEqualToString:@""])
        {
            filePath = folder.name;
        }
        else
        {
            filePath = [NSString stringWithFormat:@"%@/%@",self.filePath,folder.name];
        }
        
        LQResourcesTableViewController *resourcesChildVC = [[LQResourcesTableViewController alloc] init];
        resourcesChildVC.filePath = filePath;
        resourcesChildVC.tagStr = self.tagStr;
        resourcesChildVC.titleStr = folder.name;
        [self.navigationController pushViewController:resourcesChildVC animated:YES];
    }
    else
    {
        LQResourcesFile *file = self.fileArray[indexPath.row - self.folderArray.count];
        
        //判断摸个字符串是否以某个字符串结尾
        if ([file.type isEqualToString:@".prs"] || [file.type isEqualToString:@".prss"])
        {
            LQPreviewVC *previewVC = [[LQPreviewVC alloc] init];
            previewVC.filePathStr = self.filePath;
            previewVC.fileNameStr = file.name;
            previewVC.tagStr = self.tagStr;
            [self.navigationController pushViewController:previewVC animated:YES];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 网络请求
- (void)requestData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *ip = [LQIPSetting sharedLQIPSetting].IP;
    NSString *port = [LQIPSetting sharedLQIPSetting].port;
    NSString *sid = [LQIPSetting sharedLQIPSetting].sid;
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/update/getfilesinfo.do;sessionid=%@",ip,port,sid];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"FilePath"] = self.filePath;
    parameters[@"Tag"] = self.tagStr;
    
    [manager POST:urlStr parameters:parameters timeoutInterval:TimeoutInterval success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSError *error;
        NSMutableDictionary *resultDic = [[CJSONDeserializer deserializer] deserialize:operation.responseData error:&error];
        
        [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        
        if ([resultDic[@"state"][@"return"] isEqualToString:@"true"])
        {
            [self.fileArray removeAllObjects];
            [self.folderArray removeAllObjects];
            
            for (NSDictionary *dic in resultDic[@"file"])
            {
                LQResourcesFile *file = [LQResourcesFile resourcesFileWithDic:dic];
                [self.fileArray addObject:file];
            }
            
            for (NSDictionary *dic in resultDic[@"filebox"])
            {
                LQResourcesFolder *folder = [LQResourcesFolder resourcesFolderWithDic:dic];
                [self.folderArray addObject:folder];
            }
            
            [self.tableView reloadData];
        }
        else
        {
            if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"]) {
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:[[resultDic objectForKey:@"state"] objectForKey:@"info"]
                                                               delegate:self
                                                      cancelButtonTitle:@"重试"
                                                      otherButtonTitles:@"重新登录", nil];
                [alter show];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:[[resultDic objectForKey:@"state"] objectForKey:@"info"]
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles: nil];
                [alert show];
            }
        }
        
        [self.tableView headerEndRefreshing];
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
    if (buttonIndex == 1) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark -
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.judgeBack = YES;
}

@end
