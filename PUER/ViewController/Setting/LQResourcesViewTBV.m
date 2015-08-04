//
//  LQResourcesViewTBV.m
//  PUER
//
//  Created by admin on 15/3/24.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "LQResourcesViewTBV.h"
#import "LQResourcesTableViewController.h"

@interface LQResourcesViewTBV ()

@end

@implementation LQResourcesViewTBV

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [super setNavTitle:@"资源查看"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    NSArray *array = @[@"Web发布资源",@"客户端文件资源",@"报表模板资源",@"作业文件资源"];
    cell.textLabel.text = array[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    LQResourcesTableViewController *resourcesVC = [[LQResourcesTableViewController alloc] init];
    resourcesVC.filePath = @"";
    
    switch (indexPath.row)
    {
        case 0:
        {
            resourcesVC.tagStr = @"WebRoot";
        }
            break;
            
        case 1:
        {
            resourcesVC.tagStr = @"Client";
        }
            break;
            
        case 2:
        {
            resourcesVC.tagStr = @"Report";
        }
            break;
            
        case 3:
        {
            resourcesVC.tagStr = @"Plan";
        }
            break;
    }
    
    resourcesVC.titleStr = cell.textLabel.text;
    [self.navigationController pushViewController:resourcesVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
