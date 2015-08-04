//
//  AlterNetworkViewController.m
//  PUER
//
//  Created by admin on 14-9-3.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "AlterNetworkViewController.h"
#import "LableAndButtonTableViewCell.h"
#import "LableAndTextFieldTableViewCell.h"
#import "LableAndTextViewTableViewCell.h"

#define AlterNetworkArray (@[@"代理标记",@"目标命令",@"超时",@"检查会话",@"描述"])

@interface AlterNetworkViewController ()

@end

@implementation AlterNetworkViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//        self.view.backgroundColor = [UIColor whiteColor];
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldChange) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldChange) name:UITextViewTextDidChangeNotification object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //防止键盘遮挡住输入框
    _keyBoardController=[[UIKeyboardViewController alloc] initWithControllerDelegate:self];
    
    //初始化一个ob，提供调用object中的方法
    _ob = [[object alloc] init];
    _alterNetworkDic = [[NSMutableDictionary alloc] init];
    _judgeBack = NO;
    
    
    if (_isNewAdd) {
        
        [super setNavTitle:@"新增网络代理"];
        
        [_alterNetworkDic setObject:@"" forKey:@"fromurl"];
        [_alterNetworkDic setObject:@"http://" forKey:@"tourl"];
        [_alterNetworkDic setObject:@"30" forKey:@"timeout"];
        [_alterNetworkDic setObject:@"" forKey:@"chksid"];
        [_alterNetworkDic setObject:@"" forKey:@"note"];
    }else {
        
        [super setNavTitle:@"修改网络代理"];
        
        [self doRequest];
    }
    
    [self doLoading];
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
    _alterNetworkTableView                = [[UITableView alloc] init];
    self.alterNetworkTableView.frame      = CGRectMake(0, NavgationBarAndStareBar_height, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.alterNetworkTableView.delegate   = self;
    self.alterNetworkTableView.dataSource = self;
    self.alterNetworkTableView.delaysContentTouches = NO;//使列表上按钮出现高亮状态
    [self.alterNetworkTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.alterNetworkTableView];
    
    //给tableview注册一个cell模板
    NSString *identifer1 = @"alterNetworkTableViewCell1";
    UINib *nib1 = [UINib nibWithNibName:@"LableAndTextFieldTableViewCell" bundle:nil];
    [self.alterNetworkTableView registerNib:nib1 forCellReuseIdentifier:identifer1];
    
    //给tableview注册一个cell模板
    NSString *identifer2 = @"alterNetworkTableViewCell2";
    UINib *nib2 = [UINib nibWithNibName:@"LableAndButtonTableViewCell" bundle:nil];
    [self.alterNetworkTableView registerNib:nib2 forCellReuseIdentifier:identifer2];
    
    //给tableview注册一个cell模板
    NSString *identifer3 = @"alterNetworkTableViewCell3";
    UINib *nib3 = [UINib nibWithNibName:@"LableAndTextViewTableViewCell" bundle:nil];
    [self.alterNetworkTableView registerNib:nib3 forCellReuseIdentifier:identifer3];
    
    
    //保存按钮
    UIButton *saveButton  = [[UIButton alloc] init];
    saveButton.frame      = CGRectMake(10, 50*4+100+10, SCREEN_WIDTH-20, Button_height);
    saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"buttonbg3"] forState:UIControlStateNormal];
    [saveButton setTitle:@"确定" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(doSave) forControlEvents:UIControlEventTouchUpInside];
    [_alterNetworkTableView addSubview:saveButton];
    
    //设置点击空白处释放键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(releaseKeyBoard)];
    tapGestureRecognizer.numberOfTapsRequired = 1; // * 点击空白处几下
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = AlterNetworkArray;
    
    if (indexPath.row <3) {
        static NSString *idenifier1 = @"alterNetworkTableViewCell1";
        LableAndTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setNameLableFrameAndContentFrame:CGRectMake(10, 0, 110, 50)];
        
        cell.nameLable.text = array[indexPath.row];
        
        switch (indexPath.row) {
            case 0:
            {
                //代理标记
                cell.contentTextField.text = [self.alterNetworkDic objectForKey:@"fromurl"];
                _fromUrlTextField = cell.contentTextField;
                _fromUrlTextField.placeholder = @"以\"/\"开头的路径名";
                _fromUrlTextField.keyboardType = UIKeyboardTypeDefault;
                _fromUrlTextField.delegate = self;
            }
                break;
                
            case 1:
            {
                //目标命令
                cell.contentTextField.text = [self.alterNetworkDic objectForKey:@"tourl"];
                _toUrlTextField = cell.contentTextField;
                _toUrlTextField.keyboardType = UIKeyboardTypeDefault;
                _toUrlTextField.delegate = self;
            }
                break;
                
            case 2:
            {
                //超时
                if (self.alterNetworkDic.count == 0) {
                    cell.contentTextField.text     = @"";
                }else {
                    cell.contentTextField.text     = [NSString stringWithFormat:@"%@",[self.alterNetworkDic objectForKey:@"timeout"]];
                }
                _timeOutTextField = cell.contentTextField;
                _timeOutTextField.delegate = self;
                _timeOutTextField.keyboardType = UIKeyboardTypeNumberPad;
            }
                break;
            default:
                break;
        }
        
        return cell;
        
    }else if (indexPath.row == 3) {
        static NSString *idenifier2 = @"alterNetworkTableViewCell2";
        LableAndButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier2];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setNameLableFrameAndContentFrame:CGRectMake(10, 0, 110, 50)];
        
        cell.nameLable.text = array[indexPath.row];
        _checkSessionButton = cell.chooseButton;
        [_checkSessionButton addTarget:self action:@selector(checkSessionOperation) forControlEvents:UIControlEventTouchUpInside];
        
        if ([[self.alterNetworkDic objectForKey:@"chksid"] intValue] == 0) {
            _checkSessionButton.selected = NO;
        }else {
            _checkSessionButton.selected = YES;
        }
        
        return cell;
        
    }else if (indexPath.row == 4) {
        static NSString *idenifier3 = @"alterNetworkTableViewCell3";
        LableAndTextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier3];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setNameLableFrameAndContentFrame:CGRectMake(10, 0, 110, 50)];
        
        cell.nameLable.text = array[indexPath.row];
        
        cell.contentTextView.text = [self.alterNetworkDic objectForKey:@"note"];
        _noteTextView = cell.contentTextView;
        _noteTextView.delegate = self;
        
        return cell;
        
    }else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
        return 100;
    }else if (indexPath.row == 5) {
        return 100;
    }
    return 50;
}

#pragma mark - 网络请求
- (void)doRequest
{
    //判断当前网络状况
    if (![GetNetworkStates getNetWorkStates]) {
        return;
    }
    
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载...";
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = TimeoutInterval;
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/proxy/getproxybyfromurl.do;sessionid=%@",[[IpAndOther shareInstance] getIP],[[IpAndOther shareInstance] getPort],[[IpAndOther shareInstance] getSid]];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:_fromurl,@"FromUrl", nil];
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"tourl"] forKey:@"tourl"];
            [dic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"fromurl"] forKey:@"fromurl"];
            [dic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"timeout"] forKey:@"timeout"];
            [dic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"chksid"] forKey:@"chksid"];
            [dic setObject:[super ASCIIString:[[resultDic objectForKey:@"data"] objectForKey:@"note"]] forKey:@"note"];
            
            self.alterNetworkDic = dic;
            [self.alterNetworkTableView reloadData];
            
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
//        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        
        if (!self.judgeBack) {
            [self.requestError_AlterView show];
        }
        
    }];
}

- (void)doModifyRequest
{
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在保存...";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = TimeoutInterval;
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/proxy/saveproxy.do;sessionid=%@",[[IpAndOther shareInstance] getIP],[[IpAndOther shareInstance] getPort],[[IpAndOther shareInstance] getSid]];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       _fromurl,@"OldFromUrl",
                                       self.fromUrlTextField.text,@"FromUrl",
                                       self.toUrlTextField.text,@"ToUrl",
                                       self.timeOutTextField.text,@"TimeOut",
                                       [NSNumber numberWithBool:_checkSessionButton.selected],@"ChkSid",
                                       self.noteTextView.text,@"Note", nil];
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"])
        {
            
            _fromurl = self.fromUrlTextField.text;
            
            //返回成功时，改变等待指示器的样式，变为保存成功
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"保存成功,重启平台后生效";
            
            //通知数据连接列表刷新列表
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkDidSave" object:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            });
            
        }
        else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"])
        {
            
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            
            if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"]) {
                [self.loginAgain_AlterView show];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        
        if (!self.judgeBack)
        {
            [self.requestError_AlterView show];
        }
    }];
}

- (void)doNewAddRequest
{
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在保存...";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = TimeoutInterval;
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/proxy/addproxy.do;sessionid=%@",[[IpAndOther shareInstance] getIP],[[IpAndOther shareInstance] getPort],[[IpAndOther shareInstance] getSid]];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.fromUrlTextField.text,@"FromUrl",
                                       self.toUrlTextField.text,@"ToUrl",
                                       self.timeOutTextField.text,@"TimeOut",
                                       [NSNumber numberWithBool:_checkSessionButton.selected],@"ChkSid",
                                       self.noteTextView.text,@"Note", nil];
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            
            //返回成功时，改变等待指示器的样式，变为保存成功
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"保存成功,重启平台后生效";
            
            self.titleLable.text = @"修改网络代理";
            _fromurl = self.fromUrlTextField.text;
            _isNewAdd = NO;
            
            //通知数据连接列表刷新列表
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkDidSave" object:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
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

#pragma mark - 保存按钮
- (void)doSave
{
    [self releaseKeyBoard];
    
    if ([self.fromUrlTextField.text isEqualToString:@""] || [self.toUrlTextField.text isEqualToString:@""] || [self.timeOutTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请正确填写代理标记、目标命令、超时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if (![[Regex shareInstance] judgeFromURL:self.fromUrlTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"代理标记必须是以\"/\"开头的路径名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if ([self.timeOutTextField.text intValue]<5 || [self.timeOutTextField.text intValue]>300) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接超时必须在5～300之间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if (_isNewAdd) {
        [self doNewAddRequest];
    }else {
        [self doModifyRequest];
    }
    
}

//检查会话
- (void)checkSessionOperation
{
    _checkSessionButton.selected = !_checkSessionButton.selected;
    
    if (_checkSessionButton.selected) {
        [_alterNetworkDic setObject:[NSNumber numberWithInt:1] forKey:@"chksid"];
    }else {
        [_alterNetworkDic setObject:[NSNumber numberWithInt:0] forKey:@"chksid"];
    }
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
    
    if (self.fromUrlTextField == textField)
    {
        if ([toBeString length] > 1024) { //如果输入框内容大于20则弹出警告
            //如果粘贴内容大于24，将只截取前24的字符
            textField.text = [toBeString substringToIndex:1024];
            return NO;
            
        }
    }else if (self.toUrlTextField == textField)
    {
        if ([toBeString length] > 1024) { //如果输入框内容大于20则弹出警告
            //如果粘贴内容大于24，将只截取前24的字符
            textField.text = [toBeString substringToIndex:1024];
            return NO;
            
        }
    }else if (self.timeOutTextField == textField)
    {
        if ([toBeString length] > 3) { //如果输入框内容大于20则弹出警告
            //如果粘贴内容大于24，将只截取前24的字符
            textField.text = [toBeString substringToIndex:3];
            return NO;
            
        }
        
        for (int i = 0; i<[toBeString length]; i++) {
            //截取字符串中的每一个字符
            NSString *s = [toBeString substringWithRange:NSMakeRange(i, 1)];
            if (![[Regex shareInstance] judgeNumber:s]) {
                return NO;
            }
        }
    }
    
    return YES;
}

//监听输入框的改变，并将修改过的数据存储，以防tableview的重用机制导致数据复原
- (void)textfieldChange
{
    [_alterNetworkDic setObject:_fromUrlTextField.text forKey:@"fromurl"];
    [_alterNetworkDic setObject:_toUrlTextField.text forKey:@"tourl"];
    [_alterNetworkDic setObject:_timeOutTextField.text forKey:@"timeout"];
    [_alterNetworkDic setObject:_noteTextView.text forKey:@"note"];
    
}

- (void)releaseKeyBoard
{
    [self.fromUrlTextField  resignFirstResponder];
    [self.toUrlTextField  resignFirstResponder];
    [self.timeOutTextField  resignFirstResponder];
    [self.noteTextView  resignFirstResponder];
}

#pragma mark - TextView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:nil];
    
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text]; //得到输入框的内容
    
    if (self.noteTextView == textView)
    {
        if ([toBeString length] > 1024) { //如果输入框内容大于20则弹出警告
            //如果粘贴内容大于24，将只截取前24的字符
            textView.text = [toBeString substringToIndex:1024];
            return NO;
            
        }
    }
    return YES;
}



#pragma mark - view即将移除时
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.judgeBack = YES;
}

@end
