//
//  LQDataMaintenanceDbDetailVC.m
//  PUER
//
//  Created by admin on 15/6/4.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "LQDataMaintenanceDbDetailVC.h"

@interface LQDataMaintenanceDbDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *createdateLable;
@property (weak, nonatomic) IBOutlet UILabel *sizeLable;
@property (weak, nonatomic) IBOutlet UITextView *pathTextView;

@end

@implementation LQDataMaintenanceDbDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [super setNavTitle:@"文件详情"];
    
    self.nameLable.text = self.dbItem.name;
    self.createdateLable.text = self.dbItem.createdate;
    self.sizeLable.text = [NSString stringWithFormat:@"%.2f(MB)",self.dbItem.size];
    self.pathTextView.text = self.dbItem.path;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDbItem:(LQDataMaintenanceDbItems *)dbItem
{
    _dbItem = dbItem;
}


@end
