//
//  LQPreviewVC.m
//  PUER
//
//  Created by admin on 15/3/25.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "LQPreviewVC.h"

@interface LQPreviewVC ()
@property (weak, nonatomic) IBOutlet UITextView *previewTextView;
@property BOOL judgeBack;//判断是否以执行反悔按钮操作

@end

@implementation LQPreviewVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [super setNavTitle:self.fileNameStr];
    [self requestData];
    
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

- (void)backRootDirectory
{
    [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
}

#pragma mark - 网络请求
- (void)requestData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载…";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *ip = [LQIPSetting sharedLQIPSetting].IP;
    NSString *port = [LQIPSetting sharedLQIPSetting].port;
    NSString *sid = [LQIPSetting sharedLQIPSetting].sid;
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/update/getfile.do;sessionid=%@",ip,port,sid];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"FilePath"] = self.filePathStr;
    parameters[@"FileName"] = self.fileNameStr;
    parameters[@"Tag"] = self.tagStr;
    
    [manager POST:urlStr parameters:parameters timeoutInterval:TimeoutInterval success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        NSError *error;
        NSMutableDictionary *resultDic = [[CJSONDeserializer deserializer] deserialize:operation.responseData error:&error];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([resultDic[@"state"][@"return"] isEqualToString:@"true"])
        {
            self.previewTextView.text = [super ASCIIString:resultDic[@"file"][@"data"]];
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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
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

#pragma mark -
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.judgeBack = YES;
}

@end
