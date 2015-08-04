//
//  LQSQLSettingVC.m
//  PUER
//
//  Created by admin on 15/6/5.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "LQSQLSettingVC.h"
#import "LQDataBackupJson.h"

@interface LQSQLSettingVC ()<UITextFieldDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet LQTextField *textField;

@end

@implementation LQSQLSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [super setNavTitle:@"SQL执行设置"];
    
    self.textField.layer.borderColor  = layer_borderColor;
    self.textField.layer.borderWidth  = layer_borderWidth;
    self.textField.layer.cornerRadius = layer_cornerRadius;
    self.textField.backgroundColor    = HearderViewBackgroundColor;
    
    [self getRequest];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.judgeBack                = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.judgeBack = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirm:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    if ([self.textField.text length] <= 0) {
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请填写最大返回条数"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        [alter show];
        
        return;
    }
    
    if ([self.textField.text intValue] < 10 || [self.textField.text intValue] > 100000) {
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"最大返回条数范围10～100000"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        [alter show];
        
        return;
    }
    
    [self saveRequest];
}

- (void)getRequest
{
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载…";
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/db/getmaxrecordcount.do;sessionid=%@",IP,port,sid];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:urlStr parameters:nil timeoutInterval:20 cachePolicy:NSURLRequestUseProtocolCachePolicy success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        LQDataBackupJson *data = [LQDataBackupJson objectWithKeyValues:operation.responseString];
        
        if ([data.state.returnn isEqualToString:@"true"]) {
            
            self.textField.text = [NSString stringWithFormat:@"%d",data.data.maxrecordcount];
            
        }else {
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

- (void)saveRequest
{
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在保存…";
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/db/setmaxrecordcount.do;sessionid=%@",IP,port,sid];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"MaxRecordCount":self.textField.text};
    
    [manager POST:urlStr parameters:parameter timeoutInterval:20 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        LQDataBackupJson *data = [LQDataBackupJson objectWithKeyValues:operation.responseString];
        
        if ([data.state.returnn isEqualToString:@"true"]) {
            
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"保存成功";
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - TextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
        for (int i = 0; i<[toBeString length]; i++)
        {
            //截取字符串中的每一个字符
            NSString *s = [toBeString substringWithRange:NSMakeRange(i, 1)];
            
            if (![[Regex shareInstance] judgeNumber:s])
            {
                return NO;
            }
        }
        
        if ([toBeString length] > 6)
        {
            textField.text = [toBeString substringToIndex:6];
            
            return NO;
        }
    
    return YES;
}

@end
