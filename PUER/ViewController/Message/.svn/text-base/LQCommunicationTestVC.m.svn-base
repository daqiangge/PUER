//
//  LQCommunicationTestVC.m
//  PUER
//
//  Created by admin on 15/3/23.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "LQCommunicationTestVC.h"

@interface LQCommunicationTestVC ()<UITextViewDelegate,UITextFieldDelegate,UIKeyboardViewControllerDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *tabBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIButton *radioBtn;
@property (weak, nonatomic) IBOutlet UIButton *emailBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *messageScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *radioScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *emailScrollView;
@property (weak, nonatomic) IBOutlet UITextField *messageTelTextField;
@property (weak, nonatomic) IBOutlet UITextView *messageContentTextView;
@property (weak, nonatomic) IBOutlet UITextView *messageContentTextView_placehoder;
@property (weak, nonatomic) IBOutlet UITextView *radioContentTextView;
@property (weak, nonatomic) IBOutlet UITextView *radioContentTextView_placehoder;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *emailContentTextView;
@property (weak, nonatomic) IBOutlet UITextView *emailContentTextView_placehoder;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetMessageBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendRadioBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetRadioBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendEmailBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetEmailBtn;
@property (nonatomic,retain) UIKeyboardViewController *keyBoardController;
@property BOOL judgeBack;//判断是否以执行反悔按钮操作

@end

#define tabBarBtnColor_Normal ([UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1])

@implementation LQCommunicationTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //防止键盘遮挡住输入框
    _keyBoardController = [[UIKeyboardViewController alloc] initWithControllerDelegate:self];
    
    [super menuButton:@"通信测试"];
    
    [self initView];
    [self requestInitialData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.judgeBack  = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    self.tabBackgroundView.backgroundColor = [UIColor hexStringToColor:@"#F8F8F8"];
    [self.messageBtn setTitleColor:tabBarBtnColor_Normal forState:UIControlStateNormal];
    [self.radioBtn setTitleColor:tabBarBtnColor_Normal forState:UIControlStateNormal];
    [self.emailBtn setTitleColor:tabBarBtnColor_Normal forState:UIControlStateNormal];
    
    [self.sendMessageBtn setBackgroundColor:[UIColor hexStringToColor:@"#5CB85C"] forState:UIControlStateNormal];
    [self.resetMessageBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendRadioBtn setBackgroundColor:[UIColor hexStringToColor:@"#5CB85C"] forState:UIControlStateNormal];
    [self.resetRadioBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendEmailBtn setBackgroundColor:[UIColor hexStringToColor:@"#5CB85C"] forState:UIControlStateNormal];
    [self.resetEmailBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self setLayer:self.messageTelTextField];
    [self setLayer:self.messageContentTextView];
    [self setLayer:self.radioContentTextView];
    [self setLayer:self.emailAddressTextField];
    [self setLayer:self.emailNameTextField];
    [self setLayer:self.emailContentTextView];
    [self setLayer:self.sendMessageBtn];
    [self setLayer:self.resetMessageBtn];
    [self setLayer:self.sendRadioBtn];
    [self setLayer:self.resetRadioBtn];
    [self setLayer:self.sendEmailBtn];
    [self setLayer:self.resetEmailBtn];
}

/**
 *  设置边框
 */
- (void)setLayer:(UIView *)view
{
    view.layer.borderColor = layer_borderColor;
    view.layer.borderWidth = layer_borderWidth;
    view.layer.cornerRadius = layer_cornerRadius;
}

/**
 *  按钮的选择操作
 */
- (IBAction)chooseModuleOptions:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    self.messageBtn.selected = NO;
    self.radioBtn.selected = NO;
    self.emailBtn.selected = NO;
    self.messageScrollView.hidden = YES;
    self.radioScrollView.hidden = YES;
    self.emailScrollView.hidden = YES;
    
    if (sender == self.messageBtn)
    {
        self.messageBtn.selected = YES;
        self.messageScrollView.hidden = NO;
    }
    else if (sender == self.radioBtn)
    {
        self.radioBtn.selected = YES;
        self.radioScrollView.hidden = NO;
    }
    else
    {
        self.emailBtn.selected = YES;
        self.emailScrollView.hidden = NO;
    }
}

- (IBAction)sendMessage:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    if ([self.messageTelTextField.text isEqualToString:@""]||[self.messageContentTextView.text isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发送失败"
                                                            message:@"手机号和短信内容不能为空"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    if (![self judgeTelFormat]) {
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/sms/sendsms.do;sessionid=%@",[LQIPSetting sharedLQIPSetting].IP,[LQIPSetting sharedLQIPSetting].port,[LQIPSetting sharedLQIPSetting].sid];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.messageTelTextField.text,@"Tel",self.messageContentTextView.text,@"Msg", nil];
    
    [self sendRequestWithUrlStr:urlStr parameters:parameters];
}

- (IBAction)sendRadio:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    if ([self.radioContentTextView.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发送失败"
                                                            message:@"广播内容不能为空"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = TimeoutInterval;
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/msg/sendmsg.do;sessionid=%@",[LQIPSetting sharedLQIPSetting].IP,[LQIPSetting sharedLQIPSetting].port,[LQIPSetting sharedLQIPSetting].sid];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.radioContentTextView.text,@"msgtxt", nil];
    
    [self sendRequestWithUrlStr:urlStr parameters:parameters];
}

- (IBAction)sendEmail:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    if ([self.emailAddressTextField.text isEqualToString:@""]||[self.emailNameTextField.text isEqualToString:@""]||[self.emailContentTextView.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发送失败"
                                                            message:@"请检查是否有未填项"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    if (![self.emailAddressTextField.text isEqualToString:@""]) {
        if (![[Regex shareInstance] judgeEmail:self.emailAddressTextField.text]) {
            return;
        }
    }

    NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/email/sendemail.do;sessionid=%@",[LQIPSetting sharedLQIPSetting].IP,[LQIPSetting sharedLQIPSetting].port,[LQIPSetting sharedLQIPSetting].sid];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.emailAddressTextField.text,@"tomailaddress", self.emailNameTextField.text,@"subject",self.emailContentTextView.text,@"mailbodytext",nil];
    
    [self sendRequestWithUrlStr:urlStr parameters:parameters];
}

/**
 *  重置所以输入框
 */
- (IBAction)resetAll:(UIButton *)sender
{
    if (sender == self.resetMessageBtn)
    {
        self.messageTelTextField.text = @"";
        self.messageContentTextView.text = @"";
        self.messageContentTextView_placehoder.text = @"短信长度不超过256个字,超过70个字系统自动拆分后发送";
    }
    else if (sender == self.resetRadioBtn)
    {
        self.radioContentTextView.text = @"";
        self.radioContentTextView_placehoder.text = @"总长度不超过1024个字";
    }
    else
    {
        self.emailNameTextField.text = @"";
        self.emailContentTextView.text = @"";
        self.emailContentTextView_placehoder.text = @"总长度不超过1024个字";
    }
}

/**
 *  释放键盘
 */
- (IBAction)releaseKeyboard:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

/**
 *   判断联系方式的格式
 */
- (BOOL)judgeTelFormat
{
    
    //正则表达式判断email地址是否符合规范
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^(((\\+?\\d{1,20})(,(\\+?\\d{1,20}))*)|.{0})$" options:0 error:&error];
    
    NSTextCheckingResult *firstMatch = [regex firstMatchInString:self.messageTelTextField.text options:0 range:NSMakeRange(0, [self.messageTelTextField.text length])];
    NSTextCheckingResult *secondMatch = [regex firstMatchInString:self.messageTelTextField.text options:0 range:NSMakeRange(0, [self.messageTelTextField.text length])];
    
    if (firstMatch || secondMatch)
    {
        return YES;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"手机号码错误"
                                                        message:@"可以填写多个号码用逗号隔开"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        [alert show];
        return NO;
    }
}

#pragma mark - 网络请求
/**
 *  请求初始数据
 */
- (void)requestInitialData
{
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载…";
    
    NSString *IP       = [LQIPSetting sharedLQIPSetting].IP;
    NSString *port     = [LQIPSetting sharedLQIPSetting].port;
    NSString *sid      = [LQIPSetting sharedLQIPSetting].sid;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = TimeoutInterval;
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/getsysadmininfo.do;sessionid=%@",IP,port,sid];
    
    [manager GET:urlpath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSDictionary *resultDic = [[CJSONDeserializer deserializer] deserialize:operation.responseData error:&error];
        
        self.messageTelTextField.text = [[resultDic objectForKey:@"data"] objectForKey:@"tel"];
        self.emailAddressTextField.text = [[resultDic objectForKey:@"data"] objectForKey:@"email"];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!self.judgeBack)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接超时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }];
}

- (void)sendRequestWithUrlStr:(NSString *)urlStr parameters:(NSMutableDictionary *)parameters
{
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在发送...";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = TimeoutInterval;
    
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSDictionary *resultDic = [[CJSONDeserializer deserializer] deserialize:operation.responseData error:&error];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"发送成功";
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                
            });
            
        }else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"]) {
            
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            
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
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        
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

#pragma mark - textField Delegate
//释放键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    return YES;
}


//限制输入框字符串长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"])  //按会车可以改变
        
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (textField == self.messageTelTextField)
    {
        for (int i = 0; i<[toBeString length]; i++)
        {
            //截取字符串中的每一个字符
            NSString *s = [toBeString substringWithRange:NSMakeRange(i, 1)];
            
            if (![[Regex shareInstance] judgeNumber:s])
            {
                return NO;
            }
        }
    }
    else
    {
        if ([toBeString length] > 128) {
            //如果粘贴内容大于128，将只截取前128的字符
            textField.text = [toBeString substringToIndex:128];
            
            return NO;
            
        }
    }
    return YES;
}

#pragma mark - textView Delegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView == self.messageContentTextView)
    {
        if (textView.text.length == 0)
        {
            self.messageContentTextView_placehoder.text = @"短信长度不超过256个字,超过70个字系统自动拆分后发送";
        }
        else
        {
            self.messageContentTextView_placehoder.text = @"";
        }
    }
    else if (textView == self.radioContentTextView)
    {
        if (textView.text.length == 0)
        {
            self.radioContentTextView_placehoder.text = @"总长度不超过1024个字";
        }
        else
        {
            self.radioContentTextView_placehoder.text = @"";
        }
    }
    else
    {
        if (textView.text.length == 0)
        {
            self.emailContentTextView_placehoder.text = @"总长度不超过1024个字";
        }
        else
        {
            self.emailContentTextView_placehoder.text = @"";
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])  //按会车可以改变
        
    {
        return YES;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:nil];
    
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text]; //得到输入框的内容
    
    if (self.messageContentTextView == textView)
    {
        if ([toBeString length] > 256)
        {
            textView.text = [toBeString substringToIndex:256];
            
            return NO;
        }
    }
    else
    {
        if ([toBeString length] > 1024)
        {
            textView.text = [toBeString substringToIndex:1024];
            
            return NO;
        }
    }
    
    return YES;
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
