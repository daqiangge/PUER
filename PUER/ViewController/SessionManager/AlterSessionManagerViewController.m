//
//  AlterSessionManagerViewController.m
//  PUER
//
//  Created by admin on 14-9-11.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "AlterSessionManagerViewController.h"

@interface AlterSessionManagerViewController ()

@end

@implementation AlterSessionManagerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.judgeBack = NO;
    
    [super setNavTitle:@"Session"];
    [self doLoading];
    [self doRequset];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (self.view.window == nil) {
        self.view = nil;
    }
}

- (void)doLoading
{
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载...";
    
    NSUserDefaults *ud            = [NSUserDefaults standardUserDefaults];
    int i = [[ud objectForKey:@"sessionManagerRow"] intValue];
    if ([[ud objectForKey:@"sessionManager"] isEqualToString:@"searchSessionManager"]) {
        _alterSessionManagerDic       = [[NSMutableDictionary alloc] initWithDictionary:[ud objectForKey:@"searchSessionManagerArray"][i]];
    }else if ([[ud objectForKey:@"sessionManager"] isEqualToString:@"sessionManager"]) {
        _alterSessionManagerDic       = [[NSMutableDictionary alloc] initWithDictionary:[ud objectForKey:@"sessionManagerArray"][i]];
    }
    
    _alterSessionManagerTableView                   = [[UITableView alloc] init];
    self.alterSessionManagerTableView.frame         = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.alterSessionManagerTableView.delegate      = self;
    self.alterSessionManagerTableView.dataSource    = self;
    self.alterSessionManagerTableView.scrollEnabled = NO;
    [self.alterSessionManagerTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.alterSessionManagerTableView];
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell   = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *array          = @[@"工程名称：",@"用户名：",@"IP地址：",@"最近活动时间：",@"会话ID："];
    
    UILabel *nameLable      = [[UILabel alloc] init];
    nameLable.frame         = CGRectMake(10,  0, 110, 40);
    nameLable.font          = [UIFont systemFontOfSize:15];
    nameLable.textAlignment = NSTextAlignmentLeft;
    
    UITextView *contentLable   = [[UITextView alloc] init];
    contentLable.frame         = CGRectMake(120, nameLable.frame.origin.y+3, 200, nameLable.frame.size.height);
    contentLable.font          = nameLable.font;
    contentLable.editable      = NO;
    contentLable.textAlignment = NSTextAlignmentLeft;
    
    [cell addSubview:nameLable];
    [cell addSubview:contentLable];
    
    switch (indexPath.row) {
        case 0:
            nameLable.text    = array[indexPath.row];
            contentLable.text = [self.alterSessionManagerDic objectForKey:@"project"];
            
            break;
            
        case 1:
            nameLable.text    = array[indexPath.row];
            contentLable.text = [self.alterSessionManagerDic objectForKey:@"username"];
            
            break;
            
        case 2:
            nameLable.text    = array[indexPath.row];
            contentLable.text = [self.alterSessionManagerDic objectForKey:@"ip"];
            
            break;
            
        case 3:
            nameLable.text    = array[indexPath.row];
            contentLable.text = [self.alterSessionManagerDic objectForKey:@"dotime"];
            
            break;
            
        case 4:
        {
            nameLable.text    = array[indexPath.row];
            
            contentLable.frame       = CGRectMake(120,2, SCREEN_WIDTH-contentLable.frame.origin.x-10,60);
            contentLable.text        = [self.alterSessionManagerDic objectForKey:@"sid"];
        }
            break;
            
        case 5:
        {
            UITextView *textView = [[UITextView alloc] init];
            textView.frame       = CGRectMake(nameLable.frame.origin.x, nameLable.frame.origin.y+25, SCREEN_WIDTH-20, SCREEN_HEIGHT-40*5-94);
            textView.layer.cornerRadius  = 2;//画圆角2度
            textView.layer.borderColor   = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1].CGColor;
            textView.layer.borderWidth   = 0.5;
            textView.editable            = NO;
            textView.font                = contentLable.font;
            textView.text                = [self.alterSessionManagerDic objectForKey:@"data"];
            textView.backgroundColor     = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
            [cell addSubview:textView];
        }
            
            break;
            
        default:
            break;
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        return SCREEN_HEIGHT-40*5-64;
    }
    
    return 40;
}

#pragma mark - 网络请求
- (void)doRequset
{
    //判断当前网络状况
    if (![super isConnectionAvailable]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常,请检查你的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    //发送保存请求
    NSUserDefaults *ud    = [NSUserDefaults standardUserDefaults];
    NSString *IP          = [ud objectForKey:@"IP"];
    NSString *port        = [ud objectForKey:@"port"];
    NSString *sid         = [ud objectForKey:@"sid"];
    
    NSString *projectname = [self.alterSessionManagerDic objectForKey:@"project"];
    NSString *sessionid   = [self.alterSessionManagerDic objectForKey:@"sid"];
    
    
    NSURL *url            = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/adminmanager/do/session/getsessioninfo.do?projectname=%@&sessionid=%@;sessionid=%@",IP,port,projectname,sessionid,sid]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TimeoutInterval];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"sid"] forKey:@"sid"];
            [dic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"username"] forKey:@"username"];
            [dic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"dotime"] forKey:@"dotime"];
            [dic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"project"] forKey:@"project"];
            [dic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"ip"] forKey:@"ip"];
            [dic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"from"] forKey:@"from"];
            [dic setObject:[[super ASCIIString:[[resultDic objectForKey:@"data"] objectForKey:@"data"]]  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"data"];
            
            self.alterSessionManagerDic = dic;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.alterSessionManagerTableView reloadData];
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
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
        if (!self.judgeBack) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"网络连接超时"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles: nil];
            [alert show];
        }
    }];
    
    [operation start];
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
