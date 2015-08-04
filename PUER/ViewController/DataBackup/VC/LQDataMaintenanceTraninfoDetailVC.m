//
//  LQDataMaintenanceTraninfoDetailVC.m
//  PUER
//
//  Created by admin on 15/6/4.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "LQDataMaintenanceTraninfoDetailVC.h"

@interface LQDataMaintenanceTraninfoDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *processidLable;
@property (weak, nonatomic) IBOutlet UILabel *statusLable;
@property (weak, nonatomic) IBOutlet UILabel *opentransactionsLable;
@property (weak, nonatomic) IBOutlet UILabel *CPULable;
@property (weak, nonatomic) IBOutlet UILabel *physicalioLable;
@property (weak, nonatomic) IBOutlet UILabel *logintimeLable;
@property (weak, nonatomic) IBOutlet UILabel *waittimeLable;

@end

@implementation LQDataMaintenanceTraninfoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [super setNavTitle:@"事务线程详情"];
    
    [self loading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setItem:(LQDataMaintenanceTraninfoItems *)item
{
    _item = item;
}

- (void)loading
{
    self.processidLable.text = self.item.processid;
    self.statusLable.text = self.item.status;
    self.opentransactionsLable.text = self.item.opentransactions;
    self.CPULable.text = self.item.cpu;
    self.physicalioLable.text = self.item.physicalio;
    self.logintimeLable.text = self.item.logintime;
    self.waittimeLable.text = self.item.waittime;
}

@end
