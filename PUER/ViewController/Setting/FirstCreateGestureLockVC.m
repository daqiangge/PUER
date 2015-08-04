//
//  FirstCreateGestureLockVC.m
//  PUER
//
//  Created by admin on 15/3/13.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "FirstCreateGestureLockVC.h"
#import "LLLockViewController.h"
#import "LockSettingVC.h"

@interface FirstCreateGestureLockVC ()
@property (weak, nonatomic) IBOutlet UIButton *createLock;

@end

@implementation FirstCreateGestureLockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [super setNavTitle:@"设置手势密码"];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.createLock.backgroundColor = [UIColor colorWithRed:39/255.0 green:169/255.0 blue:227/255.0 alpha:1];
    self.createLock.layer.borderColor = layer_borderColor;
    self.createLock.layer.borderWidth = layer_borderWidth;
    self.createLock.layer.cornerRadius = layer_cornerRadius;
    self.createLock.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  创建手势密码
 */
- (IBAction)createLock:(UIButton *)sender
{
    LLLockViewController *lockVc = [[LLLockViewController alloc] init];
    lockVc.nLockViewType = LLLockViewTypeCreate;
    lockVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:lockVc animated:YES];
}

@end
