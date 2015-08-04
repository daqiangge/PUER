//
//  MainViewController.m
//  PUER
//
//  Created by admin on 14-8-14.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "MainViewController.h"
#import "DataBackupViewController.h"
#import "TBXML.h"
#import "MainStateTableViewCell.h"
#import "MainLogTableViewCell.h"
#import "LoginViewController.h"
#import "LLLockViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
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
    
    [super menuButton:@"平台监控"];
    [self initData];
    [self initView];
    [self judgeSid];
    [self setLock];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (self.view.window == nil)
    {
        self.view = nil;
    }
}

- (void)initData
{
    //初始化字典和数组
    _stateDic            = [[NSMutableDictionary alloc] init];
    _logArray            = [[NSMutableArray alloc] init];
    _judgeBack           = NO;
}

/** 初始化界面 */
- (void)initView
{
    //统计图背景控件，用于左右滑动展现两张统计图
    _scrollView                           = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor       = [UIColor colorWithRed:39/255.0 green:169/255.0 blue:227/255.0 alpha:1];
    
    //此处用于判断是否为iphone4s来调整网页的高度，避免布局不协调
    self.scrollView.frame                 = CGRectMake(0, NAVIGATIONBARANDSTAREBAR_HEIGHT+1, SCREEN_WIDTH, SCREEN_WIDTH*0.6);
    self.scrollView.contentSize           = CGSizeMake(SCREEN_WIDTH*2, self.scrollView.frame.size.height);
    self.scrollView.scrollEnabled         = YES;
    self.scrollView.pagingEnabled         = YES;
    self.scrollView.bounces               = NO;
    self.scrollView.delegate              = self;
    [self.scrollView setShowsHorizontalScrollIndicator:NO];//UIScrollView去掉底下的滚动条
    [self.view addSubview:self.scrollView];
    
    
    //CPU统计图
    _memoryWebview                       = [[UIWebView alloc] init];
    _memoryWebview.frame                 = CGRectMake(0, 0, SCREEN_WIDTH, self.scrollView.frame.size.height-20);
    _memoryWebview.scalesPageToFit       = YES;
    _memoryWebview.scrollView.bounces    = NO;
    _memoryWebview.delegate              = self;
    _memoryWebview.backgroundColor       = [UIColor clearColor];
    _memoryWebview.tag = 300;
    [_memoryWebview setOpaque:NO];
    [self.scrollView addSubview:_memoryWebview];
    
    //CPU统计图
    _CPUWebVIew                       = [[UIWebView alloc] init];
    _CPUWebVIew.frame                 = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, _memoryWebview.frame.size.height);
    _CPUWebVIew.scalesPageToFit       = NO;
    _CPUWebVIew.scrollView.bounces    = NO;
    _CPUWebVIew.delegate              = self;
    _CPUWebVIew.backgroundColor       = [UIColor clearColor];
    _CPUWebVIew.tag = 301;
    [_CPUWebVIew setOpaque:NO];
    [self.scrollView addSubview:_CPUWebVIew];
    
    //        [self checkSid];
    
    
    //等待webview加载
    _webActivityOne = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.webActivityOne setCenter:CGPointMake(SCREEN_WIDTH/2, _scrollView.frame.size.height/2)];//指定进度轮中心点
    [self.webActivityOne setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置进度轮显示类型
    //            self.webActivity.backgroundColor = [UIColor grayColor];
    [self.webActivityOne startAnimating];
    [self.scrollView addSubview:self.webActivityOne];
    
    _webActivityTwo = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.webActivityTwo setCenter:CGPointMake(SCREEN_WIDTH+SCREEN_WIDTH/2, _webActivityOne.center.y)];//指定进度轮中心点
    [self.webActivityTwo setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置进度轮显示类型
    //        self.webActivity.backgroundColor = [UIColor grayColor];
    [self.webActivityTwo startAnimating];
    [self.scrollView addSubview:self.webActivityTwo];
    
    _lineViewOne         = [[UIView alloc] init];
    self.lineViewOne.frame           = CGRectMake((SCREEN_WIDTH-4.5-32)/2,self.scrollView.frame.origin.y+self.scrollView.frame.size.height-10*Proportion_height, 32*Proportion_width/2, 2);
    self.lineViewOne.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.lineViewOne];
    
    _lineViewTwo         = [[UIView alloc] init];
    self.lineViewTwo.frame           = CGRectMake(self.lineViewOne.frame.origin.x+self.lineViewOne.frame.size.width+4.5, self.lineViewOne.frame.origin.y, self.lineViewOne.frame.size.width, self.lineViewOne.frame.size.height);
    self.lineViewTwo.backgroundColor = [UIColor whiteColor];
    self.lineViewTwo.alpha           = 0.5;
    [self.view addSubview:self.lineViewTwo];
    
    
    //--------------------------------------下半部分----------------------------------------------
    
    //选项卡背景
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    bgView.frame           = CGRectMake(0, self.scrollView.frame.origin.y+self.scrollView.frame.size.height, SCREEN_WIDTH, 35);
    [self.view addSubview:bgView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame        = CGRectMake(0, 0, SCREEN_WIDTH, bgView.frame.size.height);
    imageView.image        = [UIImage imageNamed:@"alterbg"];
    [bgView addSubview:imageView];
    
    //选项卡中“运行状态”按钮
    _stateButton                     = [[UIButton alloc] init];
    self.stateButton.frame           = CGRectMake(0, 0, SCREEN_WIDTH/2, bgView.frame.size.height);
    self.stateButton.tag             = 20;
    self.stateButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.stateButton setBackgroundImage:[UIImage imageNamed:@"bgline"] forState:UIControlStateNormal];
    [self.stateButton addTarget:self action:@selector(doChoose:) forControlEvents:UIControlEventTouchUpInside];
    [self.stateButton setTitle:@"运行状态" forState:UIControlStateNormal];
    [self.stateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bgView addSubview:self.stateButton];
    
    //选项卡中“日志”按钮
    _logButton                     = [[UIButton alloc] init];
    self.logButton.frame           = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, bgView.frame.size.height);
    self.logButton.tag             = 21;
    self.logButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.logButton setBackgroundImage:[UIImage imageNamed:@"bgnull"] forState:UIControlStateNormal];
    [self.logButton addTarget:self action:@selector(doChoose:) forControlEvents:UIControlEventTouchUpInside];
    [self.logButton setTitle:@"异常日志" forState:UIControlStateNormal];
    [self.logButton setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:UIControlStateNormal];
    [bgView addSubview:self.logButton];
    
    _stateTableView = [[UITableView alloc] init];
    self.stateTableView.frame           = CGRectMake(0, bgView.frame.origin.y+bgView.frame.size.height+5, SCREEN_WIDTH, SCREEN_HEIGHT-(bgView.frame.origin.y+bgView.frame.size.height+5));
    self.stateTableView.delegate        = self;
    self.stateTableView.dataSource      = self;
    self.stateTableView.scrollEnabled   = YES;
    self.stateTableView.hidden          = NO;
    self.stateTableView.tag             = 10;
    self.stateTableView.backgroundColor = [UIColor whiteColor];
    [self.stateTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.view addSubview:self.stateTableView];
    
    _logTableView = [[UITableView alloc] initWithFrame:self.stateTableView.frame style:UITableViewStyleGrouped];
    self.logTableView.frame           = CGRectMake(10, self.stateTableView.frame.origin.y+5, self.stateTableView.frame.size.width-20, self.stateTableView.frame.size.height);
    self.logTableView.delegate        = self;
    self.logTableView.dataSource      = self;
    self.logTableView.hidden          = YES;
    self.logTableView.tag             = 11;
    self.logTableView.backgroundColor = [UIColor whiteColor];
    [self.logTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.logTableView hideSeparatorLeftInset];
    [self.view addSubview:self.logTableView];
    
    //给tableview注册一个cell模板
    NSString *identifer1 = @"MainStateTableViewCell";
    UINib *nib1 = [UINib nibWithNibName:@"MainStateTableViewCell" bundle:nil];
    [self.stateTableView registerNib:nib1 forCellReuseIdentifier:identifer1];
    
    //给tableview注册一个cell模板
    NSString *identifer2=@"MainLogTableViewCell";
    UINib *nib2 = [UINib nibWithNibName:@"MainLogTableViewCell" bundle:nil];
    [self.logTableView registerNib:nib2 forCellReuseIdentifier:identifer2];
    
    
    [self.stateTableView addHeaderWithTarget:self action:@selector(doRequestState)];
    [self.logTableView addHeaderWithTarget:self action:@selector(logHeaderRefresh)];
}

/**
 *  当手势密码发生多次错误时在进入主页调用
 */
- (void)setLock
{
    BOOL lockSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"lockSwitch"];
    NSString *lock = [[NSUserDefaults standardUserDefaults] valueForKey:@"lock"];
    
    if (lockSwitch && lock == nil)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            LLLockViewController *lockVc = [[LLLockViewController alloc] init];
            lockVc.nLockViewType = LLLockViewTypeCreate;
            lockVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            lockVc.title = @"手势密码";
            [self.navigationController pushViewController:lockVc animated:YES];
        });
    }
}

#pragma mark - TableVew Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 10)
    {
        return 1;
    }
    else
    {
        if (self.logArray.count == 0)
        {
            return 1;
        }
        else
        {
            return self.logArray.count;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 10)
    {
        return 11;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _stateTableView)
    {
        static  NSString *mainStateIdentifer=@"MainStateTableViewCell";
        MainStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mainStateIdentifer];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        [cell hideSeparatorLeftInset];
        
        NSArray *array = @[@"服务器时间：",@"累计运行时间：",@"服务器系统：",@"端口：",@"会话个数：",@"内存大小(MB)：",@"流量监控：",@"服务版本",@"授权用户信息：",@"授权点数(个)：",@"运行模式："];
        
        cell.nameLable.text = array[indexPath.row];
        
        switch (indexPath.row)
        {
            case 0:
            {
                cell.contentLable.text   = [self.stateDic objectForKey:@"nowdatetime"];
            }
                break;
                
            case 1:
            {
                cell.contentLable.text   = [self.stateDic objectForKey:@"uptime"];
            }
                break;
                
            case 2:
            {
                cell.contentLable.text   = [self.stateDic objectForKey:@"serverosversion"];
            }
                break;
                
            case 3:
            {
                cell.contentLable.text   = [self.stateDic objectForKey:@"port"];
                
            }
                break;
                
            case 4:
            {
                if (self.stateDic.count == 0)
                {
                    cell.contentLable.text   = @"";
                }
                else
                {
                    cell.contentLable.text   = [NSString stringWithFormat:@"%@ 个 / %@ 个",[self.stateDic objectForKey:@"actsidcount"],[self.stateDic objectForKey:@"sidcount"]];
                }
            }
                break;
                
            case 5:
            {
                if (self.stateDic.count == 0)
                {
                    cell.contentLable.text   = @"";
                }
                else
                {
                    float m = [[self.stateDic objectForKey:@"memory"] floatValue]/1000;
                    cell.contentLable.text   = [NSString stringWithFormat:@"%.1f MB",m];
                }
            }
                break;
                
            case 6:
            {
                if (self.stateDic.count == 0)
                {
                    cell.contentLable.text   = @"";
                }
                else
                {
                    float m = [[self.stateDic objectForKey:@"insize"] floatValue]/1024;
                    float n = [[self.stateDic objectForKey:@"outsize"] floatValue]/1024;
                    cell.contentLable.text   = [NSString stringWithFormat:@"%.1f MB / %.1f MB",m,n];
                }
            }
                break;
                
            case 7:
            {
                if (self.stateDic.count == 0)
                {
                    cell.contentLable.text   = @"";
                }
                else
                {
                    cell.contentLable.text   = [NSString stringWithFormat:@"V%@",[self.stateDic objectForKey:@"version"]];
                }
            }
                break;
                
            case 8:
            {
                if (self.stateDic.count == 0)
                {
                    cell.contentLable.text   = @"";
                }
                else
                {
                    cell.contentLable.text   = [self.stateDic objectForKey:@"authorizeduserinfo"];
                }
            }
                break;
                
            case 9:
            {
                if (self.stateDic.count == 0)
                {
                    cell.contentLable.text   = @"";
                }
                else
                {
                    cell.contentLable.text   = [NSString stringWithFormat:@"%@",[self.stateDic objectForKey:@"authorizedpoints"]];
                }
            }
                break;
                
            case 10:
            {
                if (self.stateDic.count == 0)
                {
                    cell.contentLable.text   = @"";
                }
                else
                {
                    cell.contentLable.text   = [self.stateDic objectForKey:@"runmode"];
                }
            }
                break;
                
            default:
                break;
        }
        
        return cell;
        
    }
    else
    {
        static NSString *mainLogIdenifier = @"MainLogTableViewCell";
        MainLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mainLogIdenifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.logArray.count != 0)
        {
            [cell setContentLableHeight:[self.logArray[indexPath.section] objectForKey:@"LogNote"]];
            
            cell.timeLable.text = [self.logArray[indexPath.section] objectForKey:@"LogTime"];
            cell.contentLable.text = [self.logArray[indexPath.section] objectForKey:@"LogNote"];
        }
        else
        {
            NSDate *  senddate=[NSDate date];
            NSDateFormatter  *dateformatter  = [[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"HH:mm:ss"];
            NSString *  locationString       =[dateformatter stringFromDate:senddate];
            
            [cell setContentLableHeight:@"无异常"];
            
            cell.timeLable.text = locationString;
            cell.contentLable.text = @"无异常";
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.stateTableView)
    {
        return 30*Proportion_height;
    }
    else
    {
        if (self.logArray.count == 0)
        {
            return 35;
        }
        
        //设置有内容时的行高
        return [MainLogTableViewCell calculateHeight:[self.logArray[indexPath.section] objectForKey:@"LogNote"]]+10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 11)
    {
        return 0.01;
    }
    else
    {
        return 0.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView.tag == 11)
    {
        return 5.0;
    }
    else
    {
        return 0.0;
    }
}

#pragma mark - stateButton和logButton的选择操作
/** 运行状态和异常日志之间的切换 */
- (void)doChoose:(UIButton *)button
{
    if (button.tag == 20)
    {
        [self.stateButton setBackgroundImage:[UIImage imageNamed:@"bgline"] forState:UIControlStateNormal];
        [self.logButton setBackgroundImage:[UIImage imageNamed:@"bgnull"] forState:UIControlStateNormal];
        
        [self.stateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.logButton setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
        
        self.stateTableView.hidden = NO;
        self.logTableView.hidden   = YES;
        
    }
    else if (button.tag == 21)
    {
        [self.stateButton setBackgroundImage:[UIImage imageNamed:@"bgnull"] forState:UIControlStateNormal];
        [self.logButton setBackgroundImage:[UIImage imageNamed:@"bgline"] forState:UIControlStateNormal];
        
        [self.stateButton setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
        [self.logButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        self.stateTableView.hidden = YES;
        self.logTableView.hidden   = NO;
    }
}

#pragma mark - scrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint point = [scrollView contentOffset];
    int n         = point.x/320;
    if (n == 0)
    {
        self.lineViewOne.alpha = 1.0;
        self.lineViewTwo.alpha = 0.5;
    }
    else if (n == 1)
    {
        self.lineViewOne.alpha = 0.5;
        self.lineViewTwo.alpha = 1.0;
    }
}

#pragma mark - WebView Deiegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    NSRange range = [url rangeOfString:@"ios://"];
    if (range.length != 0) {
        // 截取方法名
        NSString *method = [url substringFromIndex:range.location + range.length];
        // 将方法名转为SEL类型
        SEL selector = NSSelectorFromString(method);
        [self performSelector:selector withObject:nil];
        
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView == self.memoryWebview)
    {
        NSString *sid = [[IpAndOther shareInstance] getSid];
        NSString *type = @"2";
        NSString *url = [NSString stringWithFormat:@"http://%@:%@",[[IpAndOther shareInstance] getIP],[[IpAndOther shareInstance] getPort]];
        NSString *errorStr = @"内存曲线图获取异常";
        
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"pageLoaded('%@','%@','%@','%@');",url,sid,type,errorStr]];
        //        [self.webActivityOne stopAnimating];
        
        NSURL *url1 = [[NSBundle mainBundle] URLForResource:@"index.html" withExtension:nil];
        NSURLRequest *request1 = [NSURLRequest requestWithURL:url1];
        [_CPUWebVIew loadRequest:request1];
    }
    else
    {
        NSString *sid = [[IpAndOther shareInstance] getSid];
        NSString *type = @"1";
        NSString *url = [NSString stringWithFormat:@"http://%@:%@",[[IpAndOther shareInstance] getIP],[[IpAndOther shareInstance] getPort]];
        NSString *errorStr = @"CPU曲线图获取异常";
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"pageLoaded('%@','%@','%@','%@');",url,sid,type,errorStr]];
        //        [self.webActivityTwo stopAnimating];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (webView == _memoryWebview)
    {
        [self.memoryWebview removeFromSuperview];
        [self.webActivityOne stopAnimating];
        [self webviewError:@"内存曲线图获取异常" webTag:_memoryWebview];
    }
    else
    {
        [self.CPUWebVIew removeFromSuperview];
        [self.webActivityTwo stopAnimating];
        [self webviewError:@"CPU曲线图获取异常" webTag:_CPUWebVIew];
    }
}

/** 内存曲线图和cpu曲线图加载发生错误时展现的提示 */
- (void)webviewError:(NSString *)string webTag:(UIWebView *)webview
{
    UIImageView *webErrorImageView = [[UIImageView alloc] init];
    webErrorImageView.image        = [UIImage imageNamed:@"webError"];
    [self.scrollView addSubview:webErrorImageView];
    
    if (webview == _memoryWebview)
    {
        webErrorImageView.frame        = CGRectMake((SCREEN_WIDTH-60)/2, 50, 60, 60);
    }
    else
    {
        webErrorImageView.frame        = CGRectMake((SCREEN_WIDTH-60)/2+SCREEN_WIDTH, 50, 60, 60);
    }
    
    UILabel *lable      = [[UILabel alloc] init];
    lable.frame         = CGRectMake(webErrorImageView.frame.origin.x-100, webErrorImageView.frame.origin.y+webErrorImageView.frame.size.height, webErrorImageView.frame.size.width+200, 30);
    lable.textColor     = [UIColor whiteColor];
    lable.text          = string;
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font          = [UIFont fontWithName:TextFont_name size:13];
    lable.alpha         = 0.8;
    [self.scrollView addSubview:lable];
    
}

- (void)stopCpuActivity
{
    [self.webActivityOne stopAnimating];
}

- (void)stopMemoryActivity
{
    [self.webActivityTwo stopAnimating];
}

#pragma mark - 网络请求
/** 验证访问的url是否正确 */
- (void)verificationWebViewRequestUrl
{
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index.html" withExtension:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.memoryWebview loadRequest:request];
    
    
    //    NSString *IPStr1    = [NSString stringWithFormat:@"http://%@:%@/Adminmanager/app/index.html?sid=%@&type=0",[[IpAndOther shareInstance] getIP],[[IpAndOther shareInstance] getPort],[[IpAndOther shareInstance] getSid]];
    //    NSString *IPStr2    = [NSString stringWithFormat:@"http://%@:%@/Adminmanager/app/index.html?sid=%@&type=1",[[IpAndOther shareInstance] getIP],[[IpAndOther shareInstance] getPort],[[IpAndOther shareInstance] getSid]];
    //
    //    NSURL *url         = [NSURL URLWithString:IPStr1];
    //    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    //    [request setHTTPMethod:@"GET"];
    //    [request setTimeoutInterval:TimeoutInterval];
    //
    //    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    //    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    //     {
    //         TBXML *tbxml = [[TBXML alloc] initWithXMLData:operation.responseData];//初始化tbxml
    //         TBXMLElement *root = tbxml.rootXMLElement;//获得头节点
    //         if (root)//if 头节点不为空则向下解析
    //         {
    //             TBXMLElement *row = [TBXML childElementNamed:@"head" parentElement:root];
    //             TBXMLElement *p1 = [TBXML childElementNamed:@"title" parentElement:row];
    //
    //             if ([[TBXML textForElement:p1] isEqualToString:@"普洱平台"])
    //             {
    ////                 NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:IPStr1]];
    ////                 [request1 setHTTPMethod:@"GET"];
    ////                 [request1 setTimeoutInterval:TimeoutInterval];
    ////                 [_memoryWebview loadRequest:request1];
    //                 NSURL *url = [[NSBundle mainBundle] URLForResource:@"index.html" withExtension:nil];
    //                 NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //                 [_memoryWebview loadRequest:request];
    //
    ////                 NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:IPStr2]];
    ////                 [request2 setHTTPMethod:@"GET"];
    ////                 [request2 setTimeoutInterval:TimeoutInterval];
    ////                 [_CPUWebVIew loadRequest:request2];
    //             }
    //             else
    //             {
    //                 [self.webActivityOne stopAnimating];
    //                 [self webviewError:@"内存曲线图获取异常"  webTag:_memoryWebview];
    //
    //                 [self.webActivityTwo stopAnimating];
    //                 [self webviewError:@"CPU曲线图获取异常"  webTag:_CPUWebVIew];
    //             }
    //         }
    //     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    //     {
    //         [self.webActivityOne stopAnimating];
    //         [self webviewError:@"内存曲线图获取异常"  webTag:_memoryWebview];
    //
    //         [self.webActivityTwo stopAnimating];
    //         [self webviewError:@"CPU曲线图获取异常"  webTag:_CPUWebVIew];
    //     }];
    //
    //    [operation start];
}

/** 运行状态的数据请求 */
- (void)doRequestState
{
    //移除之前的延迟5s执行的请求
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doRequestState) object:nil];
    
    UIActivityIndicatorView *stateActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    if (self.stateDic.count == 0)
    {
        [stateActivity setCenter:CGPointMake(self.stateTableView.frame.size.width/2, self.stateTableView.frame.size.height/2)];//指定进度轮中心点
        [stateActivity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
        [stateActivity startAnimating];
        [self.stateTableView addSubview:stateActivity];
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = TimeoutInterval;
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/system/getallinfo.do;sessionid=%@",IP,port,sid];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"paramlist",nil];
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
         NSDictionary *resultDic  = [resultStr JSONValue];
         if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"])
         {
             [_stateDic removeAllObjects];
             
             NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
             [dic setValue:port forKey:@"port"];
             [dic setValue:[[resultDic objectForKey:@"data"] objectForKey:@"firstdatetime"] forKey:@"firstdatetime"];
             [dic setValue:[[resultDic objectForKey:@"data"] objectForKey:@"nowdatetime"] forKey:@"nowdatetime"];
             [dic setValue:[[resultDic objectForKey:@"data"] objectForKey:@"memory"] forKey:@"memory"];
             [dic setValue:[[resultDic objectForKey:@"data"] objectForKey:@"sidcount"] forKey:@"sidcount"];
             [dic setValue:[[resultDic objectForKey:@"data"] objectForKey:@"insize"] forKey:@"insize"];
             [dic setValue:[[resultDic objectForKey:@"data"] objectForKey:@"outsize"] forKey:@"outsize"];
             [dic setValue:[[resultDic objectForKey:@"data"] objectForKey:@"version"] forKey:@"version"];
             [dic setValue:[[resultDic objectForKey:@"data"] objectForKey:@"authorizedpoints"] forKey:@"authorizedpoints"];
             [dic setValue:[[resultDic objectForKey:@"data"] objectForKey:@"authorizeduserinfo"] forKey:@"authorizeduserinfo"];
             [dic setValue:[[resultDic objectForKey:@"data"] objectForKey:@"runmode"] forKey:@"runmode"];
             [dic setValue:[[resultDic objectForKey:@"data"] objectForKey:@"serverosversion"] forKey:@"serverosversion"];
             [dic setValue:[[resultDic objectForKey:@"data"] objectForKey:@"actsidcount"] forKey:@"actsidcount"];
             [dic setValue:[[resultDic objectForKey:@"data"] objectForKey:@"uptime"] forKey:@"uptime"];
             self.stateDic = dic;
             [stateActivity stopAnimating];
             [self.stateTableView reloadData];
             [self.stateTableView headerEndRefreshing];
             
             [self performSelector:@selector(doRequestState) withObject:nil afterDelay:5.0];
             
         }
         else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"])
         {
             [stateActivity stopAnimating];
             [self.stateTableView headerEndRefreshing];
             
             if (!_judgeBack)
             {
                 if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"])
                 {
                     [self.loginAgain_AlterView show];
                 }
                 else
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:[[resultDic objectForKey:@"state"] objectForKey:@"info"]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles: nil];
                     [alert show];
                 }
             }
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [stateActivity stopAnimating];
         
         [self.stateTableView headerEndRefreshing];
     }];
    
}

/** 异常日志的数据请求 */
- (void)doRequsetLog
{
    UIActivityIndicatorView *logActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    if (self.logArray.count == 0)
    {
        [logActivity setCenter:CGPointMake(self.logTableView.frame.size.width/2, self.logTableView.frame.size.height/2)];//指定进度轮中心点
        [logActivity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
        [logActivity startAnimating];
        [self.logTableView addSubview:logActivity];
    }
    
    NSString *IP       = [[NSUserDefaults standardUserDefaults] objectForKey:@"IP"];
    NSString *port     = [[NSUserDefaults standardUserDefaults] objectForKey:@"port"];
    NSString *sid      = [[NSUserDefaults standardUserDefaults] objectForKey:@"sid"];
    
    NSString *urlStr   = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/log/getlasterrorlog.do?RecordCount=10;sessionid=%@",IP,port,sid];
    NSURL *url         = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TimeoutInterval];
    
    AFHTTPRequestOperation *operation   = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *resultStr             = [[NSString alloc] initWithString:operation.responseString];
         NSMutableDictionary *resultDic  = [resultStr JSONValue];
         
         if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"])
         {
             
             [self.logArray removeAllObjects];
             [self.logTableView reloadData];
             
             if ([[resultDic objectForKey:@"data"] count] != 0) {
                 for (int i = 0; i<[[resultDic objectForKey:@"data"] count]; i ++)
                 {
                     NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                     [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"time"] forKey:@"LogTime"];
                     [dic setObject:[super ASCIIString:[[resultDic objectForKey:@"data"][i] objectForKey:@"note"]] forKey:@"LogNote"];
                     [self.logArray addObject:dic];
                 }
                 
                 [self.logTableView reloadData];
             }
             [logActivity stopAnimating];
             
         }
         else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"])
         {
             [logActivity stopAnimating];
             
             if (_judgeBack)
             {
                 if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"])
                 {
                     [self.loginAgain_AlterView show];
                 }
                 else
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:[[resultDic objectForKey:@"state"] objectForKey:@"info"]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles: nil];
                     [alert show];
                 }
             }
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [logActivity stopAnimating];
     }];
    
    [operation start];
}

/** 异常日志的下拉刷新请求 */
- (void)logHeaderRefresh
{
    NSString *IP       = [[NSUserDefaults standardUserDefaults] objectForKey:@"IP"];
    NSString *port     = [[NSUserDefaults standardUserDefaults] objectForKey:@"port"];
    NSString *sid      = [[NSUserDefaults standardUserDefaults] objectForKey:@"sid"];
    
    NSString *urlStr   = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/log/getlasterrorlog.do?RecordCount=10;sessionid=%@",IP,port,sid];
    NSURL *url         = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TimeoutInterval];
    
    AFHTTPRequestOperation *operation   = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *resultStr             = [[NSString alloc] initWithString:operation.responseString];
         NSMutableDictionary *resultDic  = [resultStr JSONValue];
         
         if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"])
         {
             [self.logArray removeAllObjects];
             [self.logTableView reloadData];
             
             if ([[resultDic objectForKey:@"data"] count] != 0)
             {
                 for (int i = 0; i<[[resultDic objectForKey:@"data"] count]; i ++)
                 {
                     NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                     [dic setObject:[[resultDic objectForKey:@"data"][i] objectForKey:@"time"] forKey:@"LogTime"];
                     [dic setObject:[super ASCIIString:[[resultDic objectForKey:@"data"][i] objectForKey:@"note"]] forKey:@"LogNote"];
                     [self.logArray addObject:dic];
                 }
                 
                 [self.logTableView reloadData];
             }
             
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                            {
                                [self.logTableView headerEndRefreshing];
                            });
             
         }
         else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"])
         {
             [self.logTableView headerEndRefreshing];
             
             if (_judgeBack)
             {
                 if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"])
                 {
                     [self.loginAgain_AlterView show];
                 }
                 else
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:[[resultDic objectForKey:@"state"] objectForKey:@"info"]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles: nil];
                     [alert show];
                 }
             }
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self.logTableView headerEndRefreshing];
     }];
    
    [operation start];
    
}

/** 检查sid是否过期 */
- (void)checkSid
{
    NSString *IP       = [[NSUserDefaults standardUserDefaults] objectForKey:@"IP"];
    NSString *port     = [[NSUserDefaults standardUserDefaults] objectForKey:@"port"];
    NSString *sid      = [[NSUserDefaults standardUserDefaults] objectForKey:@"sid"];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/public/dosession/checksession.do?sessionid=%@;sessionid=%@",IP,port,sid,sid];
    NSURL *url       = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TimeoutInterval];
    
    AFHTTPRequestOperation *operation   = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *resultStr             = [[NSString alloc] initWithString:operation.responseString];
         NSMutableDictionary *resultDic  = [resultStr JSONValue];
         
         if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"])
         {
             //发起统计图的请求
             [self verificationWebViewRequestUrl];
             
         }
         else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"])
         {
             [self.webActivityOne stopAnimating];
             [self webviewError:@"内存曲线图获取异常" webTag:_memoryWebview];
             [self.webActivityTwo stopAnimating];
             [self webviewError:@"CPU曲线图获取异常" webTag:_CPUWebVIew];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self.webActivityOne stopAnimating];
         [self webviewError:@"内存曲线图获取异常" webTag:_memoryWebview];
         [self.webActivityTwo stopAnimating];
         [self webviewError:@"CPU曲线图获取异常" webTag:_CPUWebVIew];
     }];
    
    [operation start];
}

/**
 *  判断sid是否过期
 */
- (void)judgeSid
{
    NSString *sid = [[NSUserDefaults standardUserDefaults] valueForKey:@"sid"];
    if ([sid isEqualToString:@""] || sid == nil) {
        //        [self login];
    }else {
        [self verificationWebViewRequestUrl];
        [self doRequestState];
        [self doRequsetLog];
    }
}

/**
 *  登陆操作
 */
- (void)login
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode           = MBProgressHUDModeIndeterminate;
    hud.labelText      = @"正在登录";
    
    AFHTTPRequestOperationManager *manager            = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval         = TimeoutInterval;
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/login.do",[[IpAndOther shareInstance] getIP],[[IpAndOther shareInstance] getPort]];
    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:@"acceptUserId"];
    NSString *password = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:username,@"username",password,@"password",nil];
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if ([[[responseObject objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"])
         {
             //主线程。
             [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
             
             NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
             //保存sessionid和账户名
             [ud setValue:[[responseObject objectForKey:@"data"] objectForKey:@"sid"] forKey:@"sid"];
             [ud setValue:[NSNumber numberWithBool:YES] forKey:@"loginsuccess"];
             [ud synchronize];
             
             NSLog(@"%@",[ud objectForKey:@"sid"]);
             
             [self doRequestState];
             [self doRequsetLog];
             [self verificationWebViewRequestUrl];
         }
         else if ([[[responseObject objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"])
         {
             [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
             
             LoginViewController *logVC = [[LoginViewController alloc] init];
             UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logVC];
             [self presentViewController:nav animated:YES completion:nil];
             
             //登陆发生错误则返回登陆界面，并滞空密码
             //将菜单view所指向的VC标识滞空
             [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"password"];
             [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ContentViewController"];
             [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:@"loginsuccess"];
             [[NSUserDefaults standardUserDefaults] synchronize];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //登陆发生错误则返回登陆界面，并滞空密码
         
         
         [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
         
         LoginViewController *logVC = [[LoginViewController alloc] init];
         UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logVC];
         [self presentViewController:nav animated:YES completion:nil];
         
         //将菜单view所指向的VC标识滞空
         [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ContentViewController"];
         [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:@"loginsuccess"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         
     }];
    
}

#pragma mark - alertView delegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1) {
//        [self dismissViewControllerAnimated:NO completion:nil];
//    }
//}

#pragma mark - 设置了tableview的分割线
-(void)viewDidLayoutSubviews
{
    if ([self.stateTableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.stateTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.stateTableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.stateTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.stateTableView)
    {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

#pragma mark - 监听进入后台
- (void)didEnterBackground
{
    //    [self.memoryWebview stopLoading];
    //    [self.CPUWebVIew stopLoading];
    //    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - 监听进入前台
- (void)didBecomeActive
{
    //    NSString *sid = [[NSUserDefaults standardUserDefaults] valueForKey:@"sid"];
    //    if ([sid isEqualToString:@""] || sid == nil) {
    //        [self login];
    //    }
}

#pragma mark - delloce'
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - view即将移除时
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.judgeBack = YES;
    
    //cookie清除
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies])
        {
            [storage deleteCookie:cookie];
        }
    
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    
    //移除之前的延迟5s执行的请求
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
}

@end
