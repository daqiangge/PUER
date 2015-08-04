//
//  VersionViewController.m
//  PUER
//
//  Created by admin on 14-8-14.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "VersionViewController.h"

@interface VersionViewController ()

@end

@implementation VersionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor colorWithRed:246/255. green:246/255. blue:246/255. alpha:1];
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _versionUpdate = NO;
    
    [super setNavTitle:@"关于PUER"];
    [self doLoading];
    [self requestVersion];
    [self initData];
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
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame        = CGRectMake((SCREEN_WIDTH-70)/2, 30+64, 70, 70);
    imageView.image        = [UIImage imageNamed:@"logo"];
    [self.view addSubview:imageView];
    
    UILabel *nameLable         = [[UILabel alloc] init];
    nameLable.frame            = CGRectMake(imageView.frame.origin.x, imageView.frame.size.height+imageView.frame.origin.y+5, imageView.frame.size.width, 25);
    nameLable.text             = @"普洱平台";
    nameLable.textAlignment    = NSTextAlignmentCenter;
    nameLable.font             = [UIFont systemFontOfSize:17];
    [self.view addSubview:nameLable];
    
    _versionLable      = [[UILabel alloc] init];
    _versionLable.frame         = CGRectMake(nameLable.frame.origin.x, nameLable.frame.origin.y+nameLable.frame.size.height+5, nameLable.frame.size.width, 20);
    _versionLable.font          = [UIFont systemFontOfSize:13];
    _versionLable.textAlignment = NSTextAlignmentCenter;
    _versionLable.alpha         = 0.6;
    [self.view addSubview:_versionLable];
    
    //查询当前版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    _versionLable.text    = [NSString stringWithFormat:@"v %@",app_Version];
    
    _authorLable      = [[UILabel alloc] init];
    _authorLable.frame         = CGRectMake(10, _versionLable.frame.origin.y+_versionLable.frame.size.height+20, 300, 20);
    _authorLable.font          = [UIFont systemFontOfSize:15];
    _authorLable.text = @"Author: ";
    _authorLable.alpha         = 0.6;
    [self.view addSubview:_authorLable];
    
    _telLable      = [[UILabel alloc] init];
    _telLable.frame         = CGRectMake(_authorLable.frame.origin.x, _authorLable.frame.origin.y+_authorLable.frame.size.height+5, _authorLable.frame.size.width, _authorLable.frame.size.height);
    _telLable.font          = _authorLable.font;
    _telLable.text = @"Tel: ";
    _telLable.alpha         = 0.6;
    [self.view addSubview:_telLable];
    
    _emailLable      = [[UILabel alloc] init];
    _emailLable.frame         = CGRectMake(_authorLable.frame.origin.x, _telLable.frame.origin.y+_telLable.frame.size.height+5, _authorLable.frame.size.width, _authorLable.frame.size.height);
    _emailLable.font          = _authorLable.font;
    _emailLable.text = @"Email: ";
    _emailLable.alpha         = 0.6;
    [self.view addSubview:_emailLable];
    
    _bottomLable      = [[UILabel alloc] init];
    _bottomLable.frame         = CGRectMake(0, SCREEN_HEIGHT-20-5, SCREEN_WIDTH, 20);
    _bottomLable.font          = [UIFont systemFontOfSize:11];
    _bottomLable.textAlignment = NSTextAlignmentCenter;
    _bottomLable.alpha         = 0.6;
    [self.view addSubview:_bottomLable];
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, _emailLable.frame.origin.y+_emailLable.frame.size.height+20, SCREEN_WIDTH, 44) style:UITableViewStyleGrouped];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.scrollEnabled = NO;
    [self.view addSubview:_tableview];
}

- (void)initData
{
    NSString *Author = [[NSUserDefaults standardUserDefaults] objectForKey:@"Author"];
    NSString *Tel    = [[NSUserDefaults standardUserDefaults] objectForKey:@"Tel"];
    NSString *Email  = [[NSUserDefaults standardUserDefaults] objectForKey:@"Email"];
    NSString *Bottom = [[NSUserDefaults standardUserDefaults] objectForKey:@"Bottom"];
    
    if (Author == nil || Tel == nil || Email == nil || Bottom == nil) {
        [self doRequset];
    }else {
        _authorLable.text = [NSString stringWithFormat:@"Author: %@",Author];
        _telLable.text = [NSString stringWithFormat:@"Tel: %@",Tel];
        _emailLable.text = [NSString stringWithFormat:@"Email: %@",Email];
        _bottomLable.text = [NSString stringWithFormat:@"%@",Bottom];
    }
}

- (void)doRequset
{
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    //发送保存请求
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    
    for (int i = 0; i< 4; i++) {
        NSURL *url;
        switch (i) {
            case 0:
                url         = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/public/dosystem/getauthor.do",IP,port]];
                break;
                
            case 1:
                url         = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/public/dosystem/getauthortel.do",IP,port]];
                break;
                
            case 2:
                url         = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/public/dosystem/getauthoremail.do",IP,port]];
                break;
                
            case 3:
                url         = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/public/dosystem/getcopyright.do",IP,port]];
                break;
                
            default:
                break;
        }
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        [request setHTTPMethod:@"GET"];
        [request setTimeoutInterval:TimeoutInterval];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
            
            switch (i) {
                case 0:
                {
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",resultStr] forKey:@"Author"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                    break;
                    
                case 1:
                {
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",resultStr] forKey:@"Tel"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                    break;
                    
                case 2:
                {
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",resultStr] forKey:@"Email"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                    break;
                    
                case 3:
                {
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",resultStr] forKey:@"Bottom"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                    break;
                default:
                    break;
            }
            
            NSString *Author = [[NSUserDefaults standardUserDefaults] objectForKey:@"Author"];
            NSString *Tel    = [[NSUserDefaults standardUserDefaults] objectForKey:@"Tel"];
            NSString *Email  = [[NSUserDefaults standardUserDefaults] objectForKey:@"Email"];
            NSString *Bottom = [[NSUserDefaults standardUserDefaults] objectForKey:@"Bottom"];
            
            if (Author != nil && Tel != nil && Email != nil && Bottom != nil) {
                _authorLable.text = [NSString stringWithFormat:@"Author: %@",Author];
                _telLable.text = [NSString stringWithFormat:@"Tel: %@",Tel];
                _emailLable.text = [NSString stringWithFormat:@"Email: %@",Email];
                _bottomLable.text = [NSString stringWithFormat:@"%@",Bottom];
                
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常,请检查你的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }];
        
        [operation start];
    }
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = @"版本更新";
    
    UILabel *lable = [[UILabel alloc] init];
    lable.font     = [UIFont systemFontOfSize:14];
    lable.frame    = CGRectMake(SCREEN_WIDTH-105, 0, 100, 44);
    lable.alpha    = 0.6;
    [cell addSubview:lable];
    
    if (_versionUpdate) {
        lable.text     = @"有新版本需更新";
    }else {
        lable.text     = @"已是最新版本";
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

//获取app版本
- (void)requestVersion
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://itunes.apple.com/lookup?id=928342111"]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TimeoutInterval];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        _trackViewUrl = [NSURL URLWithString:[[resultDic objectForKey:@"results"][0] objectForKey:@"trackViewUrl"]];
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        
        if ([[[resultDic objectForKey:@"results"][0] objectForKey:@"version"] isEqualToString:app_Version]) {
            _versionUpdate = NO;
        }else {
            _versionUpdate = YES;
        }
        [self.tableview reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
    [operation start];
}

@end
