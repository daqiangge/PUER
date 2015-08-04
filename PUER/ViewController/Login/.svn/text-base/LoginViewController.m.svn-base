//
//  LoginViewController.m
//  PUER
//
//  Created by admin on 14-8-14.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "LoginViewController.h"
#import "MeunViewController.h"
#import "MainViewController.h"
#import "FindPWViewController.h"
#import "SetIPConfigViewController.h"

@interface LoginViewController ()
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    //防止键盘遮挡住输入框
    _keyBoardController=[[UIKeyboardViewController alloc] initWithControllerDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearPassword) name:@"Notification_lockError" object:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    [self doLoading];
    [self loadingGuidePageView];
    [self registeredNetworkState];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_DidBecomeActive" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doLogin) name:@"Notification_DidBecomeActive" object:nil];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 引导页
- (void)loadingGuidePageView
{
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        _guidePageScrollView                       = [[UIScrollView alloc] init];
        _guidePageScrollView.frame                 = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _guidePageScrollView.contentSize           = CGSizeMake(SCREEN_WIDTH*3, _guidePageScrollView.frame.size.height);
        _guidePageScrollView.scrollEnabled         = YES;
        _guidePageScrollView.pagingEnabled         = YES;
        _guidePageScrollView.bounces               = NO;
        _guidePageScrollView.delegate              = self;
        [_guidePageScrollView setShowsHorizontalScrollIndicator:NO];
        [self.view addSubview:_guidePageScrollView];
        
        UIView *viewOne= [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        viewOne.backgroundColor = [UIColor colorWithRed:38/255. green:169/255. blue:227/255. alpha:1];
        [_guidePageScrollView addSubview:viewOne];
        
        UIView *viewTwo= [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        viewTwo.backgroundColor = [UIColor colorWithRed:221/255. green:164/255. blue:13/255. alpha:1];
        [_guidePageScrollView addSubview:viewTwo];
        
        UIView *viewThr= [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        viewThr.backgroundColor = [UIColor colorWithRed:35/255. green:171/255. blue:114/255. alpha:1];
        [_guidePageScrollView addSubview:viewThr];
        
        //引导页1 Lable1
        CGFloat lableOneX = SCREEN_WIDTH/6;
        CGFloat lableOneY = SCREEN_HEIGHT/6;
        CGFloat lableOneW = SCREEN_WIDTH - lableOneX;
        CGFloat lableOneH = 30;
        
        UILabel *lableOne = [[UILabel alloc] init];
        lableOne.frame    = CGRectMake(lableOneX, lableOneY, lableOneW, lableOneH);
        lableOne.text     = @"灵活的开发模式";
        lableOne.font     = [UIFont fontWithName:TextFont_name size:24*Proportion_text];
        lableOne.textColor = [UIColor whiteColor];
        lableOne.textAlignment = NSTextAlignmentLeft;
        [_guidePageScrollView addSubview:lableOne];
        
        //引导页1 Lable2
        UILabel *lableTwo = [[UILabel alloc] init];
        lableTwo.frame    = CGRectMake(lableOne.frame.origin.x+50*Proportion_width, lableOne.frame.origin.y+lableOne.frame.size.height+10*Proportion_height, SCREEN_WIDTH-lableOne.frame.origin.x-50*Proportion_width, lableOne.frame.size.height);
        lableTwo.text     = @"中间件及多种脚本开发";
        lableOne.font     = [UIFont fontWithName:TextFont_name size:20*Proportion_text];
        lableTwo.textColor = lableOne.textColor;
        lableTwo.textAlignment = lableOne.textAlignment;
        [_guidePageScrollView addSubview:lableTwo];
        
        //引导页2 Lable1
        CGFloat lableThrX = lableOneX + SCREEN_WIDTH;
        CGFloat lableThrY = lableOneY;
        CGFloat lableThrW = lableOneW;
        CGFloat lableThrH = lableOneH;
        
        UILabel *lableThr = [[UILabel alloc] init];
        lableThr.frame    = CGRectMake(lableThrX, lableThrY,lableThrW, lableThrH);
        lableThr.text     = @"便捷的远程运维";
        lableThr.font     = lableOne.font;
        lableThr.textColor = lableOne.textColor;
        lableThr.textAlignment = lableOne.textAlignment;
        [_guidePageScrollView addSubview:lableThr];
        
        //引导页2 Lable2
        UILabel *lableFou = [[UILabel alloc] init];
        lableFou.frame    = CGRectMake(lableThr.frame.origin.x+50*Proportion_width, lableTwo.frame.origin.y,SCREEN_WIDTH-lableOne.frame.origin.x-40, lableOne.frame.size.height);
        lableFou.text     = @"平台运行动态实时掌握";
        lableFou.font     = lableTwo.font;
        lableFou.textColor = lableOne.textColor;
        lableFou.textAlignment = lableOne.textAlignment;
        [_guidePageScrollView addSubview:lableFou];
        
        //引导页3 Lable1
        CGFloat lableFivX = lableThrX + SCREEN_WIDTH;
        CGFloat lableFivY = lableOneY;
        CGFloat lableFivW = lableOneW;
        CGFloat lableFivH = lableOneH;
        
        UILabel *lableFiv = [[UILabel alloc] init];
        lableFiv.frame    = CGRectMake(lableFivX, lableFivY, lableFivW,lableFivH);
        lableFiv.text     = @"丰富的图表样式";
        lableFiv.font     = lableOne.font;
        lableFiv.textColor = lableOne.textColor;
        lableFiv.textAlignment = lableOne.textAlignment;
        [_guidePageScrollView addSubview:lableFiv];
        
        //引导页3 Lable2
        UILabel *lableSix = [[UILabel alloc] init];
        lableSix.frame    = CGRectMake(lableFiv.frame.origin.x+50*Proportion_width, lableTwo.frame.origin.y,SCREEN_WIDTH-lableOne.frame.origin.x-40, lableOne.frame.size.height);
        lableSix.text     = @"所见即所得的模板设计";
        lableSix.font     = lableTwo.font;
        lableSix.textColor = lableOne.textColor;
        lableSix.textAlignment = lableOne.textAlignment;
        [_guidePageScrollView addSubview:lableSix];
        
        //引导页1 的图片
        CGFloat imageViewOneW = 275*Proportion_width;
        CGFloat imageViewOneH = 252*Proportion_width;
        CGFloat imageViewOneX = (SCREEN_WIDTH - imageViewOneW)*0.5;
        CGFloat imageViewOneY = CGRectGetMaxY(lableTwo.frame) +30*Proportion_height;
        
        UIImageView *imageViewOne = [[UIImageView alloc] init];
        imageViewOne.frame        = CGRectMake(imageViewOneX, imageViewOneY, imageViewOneW, imageViewOneH);
        imageViewOne.image        = [UIImage imageNamed:@"yingdaoye1.png"];
        [_guidePageScrollView addSubview:imageViewOne];
        
        //引导页2 的图片
        UIImageView *imageViewTwo = [[UIImageView alloc] init];
        imageViewTwo.frame        = CGRectMake(SCREEN_WIDTH+imageViewOne.frame.origin.x, lableTwo.frame.origin.y+lableTwo.frame.size.height+30*Proportion_height, imageViewOne.frame.size.width,  imageViewOne.frame.size.height);
        imageViewTwo.image        = [UIImage imageNamed:@"yingdaoye2.png"];
        [_guidePageScrollView addSubview:imageViewTwo];
        
        //引导页3 的图片
        UIImageView *imageViewThr = [[UIImageView alloc] init];
        imageViewThr.frame        = CGRectMake(SCREEN_WIDTH*2+imageViewOne.frame.origin.x, lableTwo.frame.origin.y+lableTwo.frame.size.height+30*Proportion_height,  imageViewOne.frame.size.width,  imageViewOne.frame.size.height);
        imageViewThr.image        = [UIImage imageNamed:@"yingdaoye3.png"];
        [_guidePageScrollView addSubview:imageViewThr];
        
        _pageController = [[UIPageControl alloc] init];
        _pageController.frame = CGRectMake((SCREEN_WIDTH-100)/2, SCREEN_HEIGHT-60*Proportion_height, 100, 40);
        [_pageController addTarget:self action:@selector(switchGuidePage:) forControlEvents:UIControlEventTouchUpInside];
        _pageController.currentPage = 0;//当前处于第几个小圆点
        _pageController.numberOfPages = 3;//一共有三个小圆点
        [self.view addSubview:_pageController];
        
        _experienceBtn = [[UIButton alloc] init];
        _experienceBtn.frame = CGRectMake(SCREEN_WIDTH*2+(SCREEN_WIDTH-100)/2,SCREEN_HEIGHT-90*Proportion_height, 100, 40);
        [_experienceBtn setTitle:@"开始体验" forState:UIControlStateNormal];
        [_experienceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_experienceBtn setBackgroundColor:[UIColor clearColor]];
        [_experienceBtn addTarget:self action:@selector(removeGuidePageView) forControlEvents:UIControlEventTouchUpInside];
        [_guidePageScrollView addSubview:_experienceBtn];
        
        
        //        NSLog(@"第一次启动");
    }
    else
    {
        //        NSLog(@"已经不是第一次启动了");
    }
}

//移除引导页
- (void)removeGuidePageView
{
    [UIView animateWithDuration:0.3 animations:^
     {
         _pageController.alpha      = 0;
         _guidePageScrollView.alpha = 0;
     }];
}

#pragma mark - 加载视图控件
- (void)doLoading
{
    NSUserDefaults *ud  = [NSUserDefaults standardUserDefaults];
    NSString *name        = [ud objectForKey:@"acceptUserId"];
    NSString *password      = [ud objectForKey:@"password"];
    
    UIImageView *backgroundImageView       = [[UIImageView alloc] init];
    UIImageView *headPortraitIV            = [[UIImageView alloc] init];
    UIImageView *accountImageVIew          = [[UIImageView alloc] init];
    UIView *lineViewOne                    = [[UIView      alloc] init];
    UIImageView *passwordImageView         = [[UIImageView alloc] init];
    UIView *lineViewTwo                    = [[UIView      alloc] init];
    
    backgroundImageView.image              = [UIImage imageNamed:@"loginbg"];
    headPortraitIV.image                   = [UIImage imageNamed:@"logo"];
    accountImageVIew.image                 = [UIImage imageNamed:@"user"];
    passwordImageView.image                = [UIImage imageNamed:@"pas"];
    
    lineViewOne.backgroundColor            = [UIColor colorWithRed:31/255.0 green:38/255.0 blue:46/255.0 alpha:1];
    lineViewTwo.backgroundColor            = [UIColor colorWithRed:31/255.0 green:38/255.0 blue:46/255.0 alpha:1];
    
    _accountTextField                      = [[UITextField alloc] init];
    _passwordTextField                     = [[NoCopyAndPaste_TexrField alloc] init];
    
    self.accountTextField.placeholder      = @"账号";
    self.passwordTextField.placeholder     = @"密码";
    
    //输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.accountTextField.text             = name;
    self.passwordTextField.text            = password;
    
    self.accountTextField.textAlignment    = NSTextAlignmentLeft;
    self.passwordTextField.textAlignment   = NSTextAlignmentLeft;
    
    self.passwordTextField.secureTextEntry = YES;
    
    self.accountTextField.delegate         = self;
    self.passwordTextField.delegate        = self;
    
    self.accountTextField.keyboardType     = UIKeyboardTypeASCIICapable;
    self.passwordTextField.keyboardType    = UIKeyboardTypeASCIICapable;
    
    headPortraitIV.frame               = CGRectMake((SCREEN_WIDTH-80*Proportion_width)/2, 80*Proportion_height, 80*Proportion_width, 80*Proportion_width);
    
    backgroundImageView.frame              = CGRectMake(0, 0, SCREEN_WIDTH, 400*Proportion_height);
    accountImageVIew.frame                 = CGRectMake(45, headPortraitIV.frame.origin.y+headPortraitIV.frame.size.height+45*Proportion_height, 24, 24);
    lineViewOne.frame                      = CGRectMake(accountImageVIew.frame.origin.x-7, accountImageVIew.frame.origin.y+accountImageVIew.frame.size.width+5, SCREEN_WIDTH-2*40, 1);
    passwordImageView.frame                = CGRectMake(accountImageVIew.frame.origin.x, lineViewOne.frame.origin.y+lineViewOne.frame.size.height+25, 24, 24);
    lineViewTwo.frame                      = CGRectMake(lineViewOne.frame.origin.x, passwordImageView.frame.origin.y+passwordImageView.frame.size.width+5, lineViewOne.frame.size.width, lineViewOne.frame.size.height);
    self.accountTextField.frame            = CGRectMake(accountImageVIew.frame.origin.x+accountImageVIew.frame.size.width+7, accountImageVIew.frame.origin.y, lineViewOne.frame.size.width-accountImageVIew.frame.size.width, accountImageVIew.frame.size.height);
    self.passwordTextField.frame           = CGRectMake(self.accountTextField.frame.origin.x, passwordImageView.frame.origin.y, self.accountTextField.frame.size.width, self.accountTextField.frame.size.height);
    
    [self.view addSubview:backgroundImageView];
    [self.view addSubview:headPortraitIV];
    [self.view addSubview:accountImageVIew];
    [self.view addSubview:passwordImageView];
    [self.view addSubview:lineViewOne];
    [self.view addSubview:lineViewTwo];
    [self.view addSubview:self.accountTextField];
    [self.view addSubview:self.passwordTextField];
    
    
    
    UIButton *loginButton              = [[UIButton alloc] init];
    UIButton *findPasswordButton       = [[UIButton alloc] init];
    UIButton *setIPButton              = [[UIButton alloc] init];
    
    
    [loginButton setBackgroundImage:[UIImage imageNamed:@"buttonbg1"] forState:UIControlStateNormal];
    [setIPButton setBackgroundImage:[UIImage imageNamed:@"buttonbg2"] forState:UIControlStateNormal];
    
    loginButton.titleLabel.font        = [UIFont systemFontOfSize:16];
    setIPButton.titleLabel.font        = [UIFont systemFontOfSize:16];
    findPasswordButton.titleLabel.font = [UIFont systemFontOfSize:12];
    
    loginButton.layer.cornerRadius     = 2;
    loginButton.layer.borderColor      = UIColor.clearColor.CGColor;
    
    setIPButton.layer.cornerRadius     = 2;
    setIPButton.layer.borderWidth      = 0.5;
    setIPButton.layer.borderColor      = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1].CGColor;
    
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [setIPButton setTitle:@"设置" forState:UIControlStateNormal];
    [findPasswordButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [setIPButton setTitleColor:[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1] forState:UIControlStateNormal];
    [findPasswordButton setTitleColor:[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1] forState:UIControlStateNormal];
    [findPasswordButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    loginButton.frame                  = CGRectMake(lineViewOne.frame.origin.x, lineViewTwo.frame.origin.y+lineViewTwo.frame.size.height+40, lineViewOne.frame.size.width, 40);
    setIPButton.frame                  = CGRectMake(loginButton.frame.origin.x, loginButton.frame.origin.y+loginButton.frame.size.height+10, loginButton.frame.size.width, loginButton.frame.size.height);
    findPasswordButton.frame           = CGRectMake((SCREEN_WIDTH-100)/2+4, setIPButton.frame.origin.y+setIPButton.frame.size.height+10, 100, 25);
    
    [loginButton addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
    [findPasswordButton addTarget:self action:@selector(enterIntoFindPasswordView) forControlEvents:UIControlEventTouchUpInside];
    [setIPButton addTarget:self action:@selector(enterIntoSetIPView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loginButton];
    [self.view addSubview:findPasswordButton];
    [self.view addSubview:setIPButton];
    
    //设置点击空白处释放键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textFieldShouldReturn:)];
    tapGestureRecognizer.numberOfTapsRequired = 1; // * 点击空白处几下
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

/**
 *  手势发生错误清空密码
 */
- (void)clearPassword
{
    self.passwordTextField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
}

#pragma mark - 登陆操作
- (void)doLogin
{
    NSString *IP           = [LQIPSetting sharedLQIPSetting].IP;
    NSString *port         = [LQIPSetting sharedLQIPSetting].port;
    NSString *networkState = [[NSUserDefaults standardUserDefaults] objectForKey:@"networkState"];
    
    //判断输入框内容是否合格
    if (IP == nil || port == nil || [IP isEqualToString:@""] || [port isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"你还未设置服务器地址，请问是否现在设置"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        alert.tag          = 10;
        [alert show];
        return;
    }
    
    if ([self.accountTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请检查你的账号和密码"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if (self.passwordTextField.text.length < 6)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"密码长度必须在6～24位之间"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"正在登录...";
    });
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = TimeoutInterval;
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/login.do",IP,port];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.accountTextField.text,@"username",self.passwordTextField.text,@"password",networkState,@"from", nil];
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if ([[[responseObject objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"])
         {
             //主线程。
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             
             NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
             //保存sessionid和账户名
             [ud setValue:[[responseObject objectForKey:@"data"] objectForKey:@"sid"] forKey:@"sid"];
             [ud setValue:self.accountTextField.text  forKey:@"acceptUserId"];
             [ud setValue:self.passwordTextField.text  forKey:@"password"];
             [ud setValue:[NSNumber numberWithBool:YES] forKey:@"loginsuccess"];
             [ud synchronize];
             
             NSLog(@"%@",[ud objectForKey:@"sid"]);
             [self enterIntoMainView];
         }
         else if ([[[responseObject objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"])
         {
             [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:@"loginsuccess"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
//             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:[[responseObject objectForKey:@"state"] objectForKey:@"info"]
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles: nil];
             [alert show];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:@"loginsuccess"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         
//         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"登录失败，请重试"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles: nil];
         [alert show];
     }];
}

#pragma mark - 跳转进入首页
- (void)enterIntoMainView
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[MainViewController alloc] init]];
    MeunViewController *MeunView                 = [[MeunViewController alloc] init];
    
    RESideMenu *sideMenuViewController           = [[RESideMenu alloc] initWithContentViewController:navigationController
                                                                              leftMenuViewController:MeunView
                                                                             rightMenuViewController:nil];
    sideMenuViewController.backgroundImage             = [UIImage imageNamed:@"meunbg"];
    sideMenuViewController.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent; // UIStatusBarStyleLightContent
    sideMenuViewController.delegate = self;
    sideMenuViewController.contentViewShadowColor      = [UIColor blackColor];
    sideMenuViewController.contentViewShadowOffset     = CGSizeMake(0, 0);
    sideMenuViewController.contentViewShadowOpacity    = 0.6;
    sideMenuViewController.contentViewShadowRadius     = 12;
    sideMenuViewController.contentViewShadowEnabled    = YES;
    [self presentViewController:sideMenuViewController animated:YES completion:nil];
    
    NSUserDefaults *ud  = [NSUserDefaults standardUserDefaults];
    [ud setObject:@"0" forKey:@"ContentViewController"];
    [ud synchronize];
}

#pragma mark - 跳转忘记密码界面和设置IP界面
- (void)enterIntoFindPasswordView
{
    FindPWViewController *findPWView = [[FindPWViewController alloc] init];
    [self.navigationController pushViewController:findPWView animated:YES];
}

- (void)enterIntoSetIPView
{
    SetIPConfigViewController *setIPVIew = [[SetIPConfigViewController alloc] init];
    [self.navigationController pushViewController:setIPVIew animated:YES];
}

#pragma mark - Textfield Delegate
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField == self.passwordTextField) {
        [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return YES;
}

//释放键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.accountTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    return YES;
}

//限制textfield字符长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if ([toBeString length] > 24)
    {
        textField.text = [toBeString substringToIndex:24];
        
        return NO;
    }
    
    //判读是是否有中文
    for (int i = 0; i<[toBeString length]; i++)
    {
        //截取字符串中的每一个字符
        NSString *s = [toBeString substringWithRange:NSMakeRange(i, 1)];
        if ([[Regex shareInstance] judgeChinese:s])
        {
            return NO;
        }
    }
    
    return YES;
}

//当密码发生改变时就记录下来
- (void)passwordChanged
{
    [[NSUserDefaults standardUserDefaults] setObject:self.passwordTextField.text  forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 注册监听网络的通知
- (void)registeredNetworkState
{
    //先移除之前可能注册过的网络监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    
    //开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];//可以以多种形式初始化
    [hostReach startNotifier];  //开始监听,会启动一个run loop
    [self updateInterfaceWithReachability: hostReach];
    
}

//监听到网络状态改变
- (void) reachabilityChanged: (NSNotification* )note
{
    Reachability* curReach = [note object];
    
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    [self updateInterfaceWithReachability: curReach];
    
}


//处理连接改变后的情况
- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    switch ([curReach currentReachabilityStatus])
    {
        case NotReachable:
            //            NSLog(@"没有网络连接");
            break;
        case ReachableViaWWAN:
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                           {
                               // 状态栏是由当前app控制的，首先获取当前app
                               UIApplication *app = [UIApplication sharedApplication];
                               
                               NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
                               
                               int type = 0;
                               
                               for (id child in children)
                               {
                                   if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")])
                                   {
                                       type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
                                   }
                               }
                               
                               switch (type)
                               {
                                   case 0:
                                       //                        NSLog(@"没有网络连接");
                                       break;
                                       
                                   case 1:
                                       //                        NSLog(@"2G");
                                       [[NSUserDefaults standardUserDefaults] setObject:@"2G" forKey:@"networkState"];
                                       [[NSUserDefaults standardUserDefaults] synchronize];
                                       [self sendNetWorkStates:@"2G"];
                                       break;
                                       
                                   case 2:
                                       //                        NSLog(@"3G");
                                       [[NSUserDefaults standardUserDefaults] setObject:@"3G" forKey:@"networkState"];
                                       [[NSUserDefaults standardUserDefaults] synchronize];
                                       [self sendNetWorkStates:@"3G"];
                                       break;
                                       
                                   case 3:
                                       //                        NSLog(@"4G");
                                       [[NSUserDefaults standardUserDefaults] setObject:@"4G" forKey:@"networkState"];
                                       [[NSUserDefaults standardUserDefaults] synchronize];
                                       [self sendNetWorkStates:@"4G"];
                                       break;
                                       
                                   case 5:
                                       //                        NSLog(@"~~~wifi");
                                       break;
                                       
                                   default:
                                       break;
                               }
                           });
            
        }
            break;
        case ReachableViaWiFi:
            //            NSLog(@"使用WiFi网络") ;
            [[NSUserDefaults standardUserDefaults] setObject:@"WIFI" forKey:@"networkState"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self sendNetWorkStates:@"WIFI"];
            break;
            
        default:
            break;
    }
    
}

- (void)sendNetWorkStates:(NSString *)string
{
    //发送保存请求
    NSString *IP       = [LQIPSetting sharedLQIPSetting].IP;
    NSString *port     = [LQIPSetting sharedLQIPSetting].port;
    NSString *sid      = [LQIPSetting sharedLQIPSetting].sid;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = TimeoutInterval;
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/session/setsessionfrom.do;sessionid=%@",IP,port,sid];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"AdminManager",@"projectname",string,@"from",nil];
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
         NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
         //        NSLog(@"%@",string) ;
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //        NSLog(@"%@",error) ;
     }];
}

#pragma mark - alertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10)
    {
        if (buttonIndex == 1)
        {
            SetIPConfigViewController *setIPVIew = [[SetIPConfigViewController alloc] init];
            [self.navigationController pushViewController:setIPVIew animated:YES];
        }
    }
}

#pragma mark - UIScrollView
//逐渐停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint point=[scrollView contentOffset];//contentOffset偏移量
    int n=point.x/SCREEN_WIDTH;//所在的图为第几张图
    
    _pageController.currentPage=n;//currentpage当前图片所在的第几个点
}

- (void)switchGuidePage:(UIPageControl *)pageControl
{
    [_guidePageScrollView setContentOffset:CGPointMake([pageControl currentPage]*320, 0) animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_DidBecomeActive" object:nil];
}

@end
