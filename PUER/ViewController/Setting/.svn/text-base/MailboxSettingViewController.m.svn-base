//
//  MailboxSettingViewController.m
//  PUER
//
//  Created by admin on 14-8-14.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "MailboxSettingViewController.h"
#import "LableAndTextFieldTableViewCell.h"

@interface MailboxSettingViewController ()

@end

@implementation MailboxSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldChange) name:UITextFieldTextDidChangeNotification object:nil];
    
    //防止键盘遮挡住输入框
    _keyBoardController=[[UIKeyboardViewController alloc] initWithControllerDelegate:self];
    
    _emailBoxDic  = [[NSMutableDictionary alloc] init];
    _judgeBack    = NO;
    
    //初始化一个ob，提供调用object中的方法
    _ob = [[object alloc] init];
    
    [super setNavTitle:@"邮箱设置"];
    [self doLoadTextField];
    [self doLoadTableView];
    [self doRequest];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(releaseKeyBoard)];
    tapGR.numberOfTapsRequired = 1; // * 点击空白处几下
    [self.view addGestureRecognizer:tapGR];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (self.view.window == nil) {
        self.view = nil;
    }
}

#pragma mark - textField
- (void)doLoadTextField
{
    _emailaddressTextField  = [[UITextField alloc] init];
    _smtpaddressTextField   = [[UITextField alloc] init];
    _smtpportTextField      = [[UITextField alloc] init];
    _usernameTextField      = [[UITextField alloc] init];
    _passwordTextField      = [[NoCopyAndPaste_TexrField alloc] init];
}

#pragma mark - TableView
- (void)doLoadTableView
{
    _mailBoxSettingTableView            = [[UITableView alloc] init];
    _mailBoxSettingTableView.frame      = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
    _mailBoxSettingTableView.delegate   = self;
    _mailBoxSettingTableView.dataSource = self;
    _mailBoxSettingTableView.delaysContentTouches = NO;
    [_mailBoxSettingTableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_mailBoxSettingTableView];
    
    //给tableview注册一个cell模板
    NSString *identifer = @"mailBoxSettingTableViewCell";
    UINib *nib = [UINib nibWithNibName:@"LableAndTextFieldTableViewCell" bundle:nil];
    [self.mailBoxSettingTableView registerNib:nib forCellReuseIdentifier:identifer];
    
    [_mailBoxSettingTableView addSubview:[self saveButton:CGRectMake(10, 5*50, SCREEN_WIDTH-20, Button_height)]];
    [_mailBoxSettingTableView addSubview:[self resetButton:CGRectMake(10, 6*50, SCREEN_WIDTH-20, Button_height)]];
    [_mailBoxSettingTableView addSubview:[self emailBoxTestTheConnectionButton:CGRectMake(10, 7*50, SCREEN_WIDTH-20, Button_height)]];
}

#pragma mark - tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idenifier = @"mailBoxSettingTableViewCell";
    LableAndTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNameLableFrameAndContentFrame:CGRectMake(10, 0, 110, 50)];
    
    NSArray *array = @[@"邮箱地址",@"发送服务器地址\n(SMTP)",@"发送服务器端口\n(SMTP)",@"邮箱账号",@"邮箱密码"];
    cell.nameLable.text = array[indexPath.row];

    switch (indexPath.row) {
        case 0:
        {
            cell.contentTextField.placeholder     = @"例:yourname@example.com";
            cell.contentTextField.text            = [_emailBoxDic objectForKey:@"emailaddress"];
            _emailaddressTextField                = cell.contentTextField;
            _emailaddressTextField.delegate       = self;
            
        }
            break;
            
        case 1:
        {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:array[indexPath.row]];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:TextFont_name size:13] range:NSMakeRange(7, 7)];
            cell.nameLable.attributedText = str;
            
            cell.contentTextField.placeholder = @"例:smtp.example.com";
            cell.contentTextField.text        = [_emailBoxDic objectForKey:@"smtpaddress"];
            _smtpaddressTextField             = cell.contentTextField;
            _smtpaddressTextField.delegate    = self;
            
        }
            break;
            
        case 2:
        {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:array[indexPath.row]];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:TextFont_name size:13] range:NSMakeRange(7, 7)];
            cell.nameLable.attributedText = str;
            
            cell.contentTextField.placeholder = @"服务器端口默认为25";
            cell.contentTextField.text        = [_emailBoxDic objectForKey:@"smtpport"];
            _smtpportTextField                = cell.contentTextField;
            _smtpportTextField.keyboardType   = UIKeyboardTypeNumberPad;
            _smtpportTextField.delegate       = self;
            
        }
            break;
            
        case 3:
        {
            cell.contentTextField.placeholder  = @"可以填写_、数字和英文";
            cell.contentTextField.text         = [_emailBoxDic objectForKey:@"username"];
            _usernameTextField                 = cell.contentTextField;
            _usernameTextField.delegate        = self;
            
        }
            break;
            
        case 4:
        {
            cell.contentTextField.text         = [_emailBoxDic objectForKey:@"userpassword"];
            _passwordTextField                 = cell.contentTextField;
            _passwordTextField.secureTextEntry = YES;
            _passwordTextField.delegate        = self;
            
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
        return 180;
    }
    return 50.0;
}

#pragma mark - 网络请求
- (void)doRequest
{
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载…";
    
    
    //判断当前网络状况
    if (![super isConnectionAvailable]) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常,请检查你的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    //发送保存请求
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    NSURL *url         = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/adminmanager/do/email/getinfo.do;sessionid=%@",IP,port,sid]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TimeoutInterval];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            
            [dic setObject:[NSString stringWithFormat:@"%@",[[resultDic objectForKey:@"data"] objectForKey:@"emailaddress"]] forKey:@"emailaddress"];
            [dic setObject:[NSString stringWithFormat:@"%@",[[resultDic objectForKey:@"data"] objectForKey:@"smtpaddress"]] forKey:@"smtpaddress"];
            [dic setObject:[NSString stringWithFormat:@"%@",[[resultDic objectForKey:@"data"] objectForKey:@"smtpport"]] forKey:@"smtpport"];
            [dic setObject:[NSString stringWithFormat:@"%@",[[resultDic objectForKey:@"data"] objectForKey:@"username"]] forKey:@"username"];
            [dic setObject:[NSString stringWithFormat:@"%@",[[resultDic objectForKey:@"data"] objectForKey:@"userpassword"]] forKey:@"userpassword"];
            _emailBoxDic      = dic;
            _resetString      = [dic JSONRepresentation];
            
            //停止0.5s后执行刷新列表，并停止刷新的动画
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_mailBoxSettingTableView reloadData];
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常,请检查你的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }];
    
    [operation start];
    
}

#pragma mark - 保存、重置、测试邮箱连接按钮
//保存按钮
- (id)saveButton:(CGRect)rect
{
    UIButton *saveButton  = [[UIButton alloc] init];
    saveButton.frame      = rect;
    saveButton.titleLabel.font = [UIFont fontWithName:TextFont_name size:Button_Font_SmallSize];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"buttonbg3"] forState:UIControlStateNormal];
    [saveButton setTitle:@"确定" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(doSave) forControlEvents:UIControlEventTouchUpInside];
    
    return saveButton;
}

//重置按钮
- (id)resetButton:(CGRect)rect
{
    UIButton *resetButton  = [[UIButton alloc] init];
    resetButton.frame      = rect;
    resetButton.titleLabel.font = [UIFont fontWithName:TextFont_name size:Button_Font_SmallSize];
    [resetButton setBackgroundImage:[UIImage imageNamed:@"buttonbg4"] forState:UIControlStateNormal];
    [resetButton setTitle:@"重置" forState:UIControlStateNormal];
    [resetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(resetAll) forControlEvents:UIControlEventTouchUpInside];
    
    return resetButton;
}

//测试邮箱连接
- (id)emailBoxTestTheConnectionButton:(CGRect)rect
{
    UIButton *defaulValueButton  = [[UIButton alloc] init];
    defaulValueButton.frame      = rect;
    defaulValueButton.titleLabel.font = [UIFont fontWithName:TextFont_name size:Button_Font_SmallSize];
    [defaulValueButton setBackgroundImage:[UIImage imageNamed:@"buttonbg4"] forState:UIControlStateNormal];
    [defaulValueButton setTitle:@"测试邮箱连接" forState:UIControlStateNormal];
    [defaulValueButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [defaulValueButton addTarget:self action:@selector(emailBoxTestTheConnection) forControlEvents:UIControlEventTouchUpInside];
    
    return defaulValueButton;
}

- (void)doSave
{
    [self releaseKeyBoard];
    
    if (![self.emailaddressTextField.text isEqualToString:@""]) {
        if (![[Regex shareInstance] judgeEmail:self.emailaddressTextField.text]) {
            return;
        }
    }
    if (![self.smtpaddressTextField.text isEqualToString:@""]) {
        if (![[Regex shareInstance] judgeSmtp:self.smtpaddressTextField.text]) {
            return;
        }
    }
    if (![self.usernameTextField.text isEqualToString:@""]) {
        if (![[Regex shareInstance] judgeUserName:self.usernameTextField.text]) {
            return;
        }
    }
    
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在保存...";
    
    if (![super isConnectionAvailable]) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常,请检查你的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    //发送保存请求
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *IP       = [ud objectForKey:@"IP"];
    NSString *port     = [ud objectForKey:@"port"];
    NSString *sid      = [ud objectForKey:@"sid"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = TimeoutInterval;
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/email/setinfo.do;sessionid=%@",IP,port,sid];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.emailaddressTextField.text,@"emailaddress",
                                       self.smtpaddressTextField.text,@"smtpaddress",
                                       self.smtpportTextField.text,@"smtpport",
                                       self.usernameTextField.text,@"username",
                                       self.passwordTextField.text,@"userpassword",nil];
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        resultStr = [resultStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        resultStr = [resultStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"保存成功";
            
            _resetString = [self.emailBoxDic JSONRepresentation];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
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
        //如果未离开此界面则显示错误提示，如果已离开则不显示
        if (!self.judgeBack) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接超时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }];
}

- (void)resetAll
{
    [self releaseKeyBoard];
    
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在重置...";
    
    _emailBoxDic = [_resetString JSONValue];
    
    [_mailBoxSettingTableView reloadData];
    
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"重置成功";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        
    });
}

- (void)emailBoxTestTheConnection
{
    
    [self releaseKeyBoard];
    
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在测试...";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = TimeoutInterval;
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/email/testsmtpconn2.do;sessionid=%@",[[IpAndOther shareInstance] getIP],[[IpAndOther shareInstance] getPort],[[IpAndOther shareInstance] getSid]];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.smtpaddressTextField.text,@"smtpaddress",
                                       self.smtpportTextField.text,@"smtpport",
                                       self.usernameTextField.text,@"username",
                                       self.passwordTextField.text,@"userpassword",nil];
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        resultStr = [resultStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        resultStr = [resultStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"连接成功";
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            });
            
        }else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"]) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            
            if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"]) {
                [self.loginAgain_AlterView show];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        if (!self.judgeBack) {
            [self.requestError_AlterView show];
        }
    }];
}

#pragma mark - Textfield Delegate
//释放键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self releaseKeyBoard];
    
    return YES;
}

//限制输入框字符串长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"])  //按会车可以改变
        
    {
        return YES;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:nil];
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (self.emailaddressTextField == textField)
    {
        if ([toBeString length] > 128) {
            //如果粘贴内容大于128，将只截取前128的字符
            textField.text = [toBeString substringToIndex:128];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:nil];
            return NO;
            
        }
    }else if (self.smtpaddressTextField == textField)
    {
        if ([toBeString length] > 128) {
            textField.text = [toBeString substringToIndex:128];
            [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:nil];
            
            return NO;
            
        }
    }else if (self.smtpportTextField == textField)
    {
        if ([toBeString length] > 4) {
            textField.text = [toBeString substringToIndex:4];
            [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:nil];
            
            return NO;
            
        }
        
        for (int i = 0; i<[toBeString length]; i++) {
            //截取字符串中的每一个字符
            NSString *s = [toBeString substringWithRange:NSMakeRange(i, 1)];
            if (![[Regex shareInstance] judgeNumber:s]) {
                return NO;
            }
        }
        
    }else if (self.usernameTextField == textField)
    {
        if ([toBeString length] > 64) {
            textField.text = [toBeString substringToIndex:64];
            [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:nil];
            
            return NO;
            
        }
    }else if (self.passwordTextField == textField)
    {
        if ([toBeString length] > 20) {
            textField.text = [toBeString substringToIndex:20];
            [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:nil];
            
            return NO;
            
        }
    }
    
    //判读是是否有中文
    for (int i = 0; i<[toBeString length]; i++) {
        //截取字符串中的每一个字符
        NSString *s = [toBeString substringWithRange:NSMakeRange(i, 1)];
        if ([[Regex shareInstance] judgeChinese:s]) {
            return NO;
        }
    }
    
    return YES;
}

//监听输入框的改变，并将修改过的数据存储，以防tableview的重用机制导致数据复原
- (void)textfieldChange
{
    [_emailBoxDic setObject:_emailaddressTextField.text forKey:@"emailaddress"];
    [_emailBoxDic setObject:_smtpaddressTextField.text forKey:@"smtpaddress"];
    [_emailBoxDic setObject:_smtpportTextField.text forKey:@"smtpport"];
    [_emailBoxDic setObject:_usernameTextField.text forKey:@"username"];
    [_emailBoxDic setObject:_passwordTextField.text forKey:@"userpassword"];
}

#pragma mark - 点击空白释放键盘
- (void)releaseKeyBoard
{
    [self.emailaddressTextField resignFirstResponder];
    [self.smtpaddressTextField resignFirstResponder];
    [self.smtpportTextField resignFirstResponder];
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
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
