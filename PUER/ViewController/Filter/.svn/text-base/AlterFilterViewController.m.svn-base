//
//  AlterFilterViewController.m
//  PUER
//
//  Created by admin on 14/12/24.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "AlterFilterViewController.h"
#import "LableAndTextFieldTableViewCell.h"
#import "LableAndTextFieldAndPullDownButtonTableViewCell.h"
#import "LableAndButtonTableViewCell.h"
#import "LableAndTextViewTableViewCell.h"

#define AlterFilterArray (@[@"过滤器名称",@"过滤类型",@"文件类型",@"动作文件路径",@"检查会话",@"描述"])
#define DoTypeArray (@[@"left",@"same"])
#define FileTypeArray (@[@"dll",@"prs",@"prss"])

@interface AlterFilterViewController ()

@end

@implementation AlterFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //防止键盘遮挡住输入框
    _keyBoardController=[[UIKeyboardViewController alloc] initWithControllerDelegate:self];
    
    [self initData];

    if (_issys) {
        [super setNavTitle:@"过滤器(系统自带)"];
        [self doRequest];
    }else {
        if (_isNewAdd) {
            [super setNavTitle:@"新增过滤器"];
            [self doRequestFileName];
            
            [_filterDic setObject:@"" forKey:@"name"];
            [_filterDic setObject:@"left" forKey:@"dotype"];
            [_filterDic setObject:@"dll" forKey:@"filetype"];
            [_filterDic setObject:@"" forKey:@"filename"];
            [_filterDic setObject:@"" forKey:@"chksid"];
            [_filterDic setObject:@"" forKey:@"issys"];
            [_filterDic setObject:@"" forKey:@"note"];
            
        }else {
            [super setNavTitle:@"修改过滤器"];
            [self doRequest];
        }
    }
    
    [self initView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldChange) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldChange) name:UITextViewTextDidChangeNotification object:nil];
    
    _judgeBack  = NO;
    _filterDic = [[NSMutableDictionary alloc] init];
    _fileNameArray = [[NSMutableArray alloc] init];
}

- (void)initView
{
    [self initTableView];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(releaseKeyBoard)];
    tapGR.numberOfTapsRequired = 1; // * 点击空白处几下
    tapGR.delegate = self;
    [_alterFilterTableView addGestureRecognizer:tapGR];
}

- (void)initTableView
{
    _alterFilterTableView = [[UITableView alloc] init];
    _alterFilterTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _alterFilterTableView.delegate = self;
    _alterFilterTableView.dataSource = self;
    _alterFilterTableView.delaysContentTouches = NO;
    [_alterFilterTableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_alterFilterTableView];
    
    [self initSaveButton];
    
    //给tableview注册一个cell模板
    NSString *identifer1 = @"alterFilterTableViewCell1";
    UINib *nib1 = [UINib nibWithNibName:@"LableAndTextFieldTableViewCell" bundle:nil];
    [_alterFilterTableView registerNib:nib1 forCellReuseIdentifier:identifer1];
    
    NSString *identifer2 = @"alterFilterTableViewCell2";
    UINib *nib2 = [UINib nibWithNibName:@"LableAndTextFieldAndPullDownButtonTableViewCell" bundle:nil];
    [_alterFilterTableView registerNib:nib2 forCellReuseIdentifier:identifer2];
    
    NSString *identifer3 = @"alterFilterTableViewCell3";
    UINib *nib3 = [UINib nibWithNibName:@"LableAndButtonTableViewCell" bundle:nil];
    [_alterFilterTableView registerNib:nib3 forCellReuseIdentifier:identifer3];
    
    NSString *identifer4 = @"alterFilterTableViewCell4";
    UINib *nib4 = [UINib nibWithNibName:@"LableAndTextViewTableViewCell" bundle:nil];
    [_alterFilterTableView registerNib:nib4 forCellReuseIdentifier:identifer4];
    
    
    _doTypeTableView              = [[UITableView alloc] init];
    _doTypeTableView.frame        = CGRectMake(110, 50*2-5, SCREEN_WIDTH-110-10, 30*2);
    _doTypeTableView.delegate     = self;
    _doTypeTableView.dataSource   = self;
    _doTypeTableView.hidden       = YES;
    [_alterFilterTableView addSubview:_doTypeTableView];
    
    
    _fileTypeTableView            = [[UITableView alloc] init];
    _fileTypeTableView.frame      = CGRectMake(_doTypeTableView.frame.origin.x, 50*3-5, _doTypeTableView.frame.size.width, 30*3);
    _fileTypeTableView.delegate   = self;
    _fileTypeTableView.dataSource = self;
    _fileTypeTableView.hidden     = YES;
    [_alterFilterTableView addSubview:_fileTypeTableView];
    
    
    _fileNameTableView            = [[UITableView alloc] init];
    _fileNameTableView.frame      = CGRectMake(_doTypeTableView.frame.origin.x, 50*4-5, _doTypeTableView.frame.size.width, 30*4);
    _fileNameTableView.delegate   = self;
    _fileNameTableView.dataSource = self;
    _fileNameTableView.hidden     = YES;
    [_alterFilterTableView addSubview:_fileNameTableView];
    
    _doTypeTableView.layer.borderColor    = TextField_layer_borderColor;
    _doTypeTableView.layer.borderWidth    = TextField_layer_borderWidth;
    _doTypeTableView.layer.cornerRadius   = TextField_layer_cornerRadius;
    
    _fileTypeTableView.layer.borderColor  = TextField_layer_borderColor;
    _fileTypeTableView.layer.borderWidth  = TextField_layer_borderWidth;
    _fileTypeTableView.layer.cornerRadius = TextField_layer_cornerRadius;
    
    _fileNameTableView.layer.borderColor  = TextField_layer_borderColor;
    _fileNameTableView.layer.borderWidth  = TextField_layer_borderWidth;
    _fileNameTableView.layer.cornerRadius = TextField_layer_cornerRadius;
}

- (void)initSaveButton
{
    UIButton *saveButton       = [[UIButton alloc] init];
    saveButton.frame           = CGRectMake(10, 50*5+100+5, SCREEN_WIDTH-20, Button_height);
    saveButton.titleLabel.font = [UIFont fontWithName:TextFont_name size:Button_Font_SmallSize];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"buttonbg3"] forState:UIControlStateNormal];
    [saveButton setTitle:@"确定" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(doSave) forControlEvents:UIControlEventTouchUpInside];
    
    if (_issys) {
        saveButton.alpha   = 0.7;
        saveButton.enabled = NO;
    }
    
    [_alterFilterTableView addSubview:saveButton];
}

#pragma mark - 按钮的操作

- (void)doSave
{
    if ([_filterNameTextField.text isEqualToString:@""] || [_fileNameTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请正确填写过滤器名称、动作文件路径" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if (![[Regex shareInstance] judgeFilterName:_filterNameTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"过滤器名称必须是以\"/\"开头的路径名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if (_isNewAdd) {
        [self doNewAddRequest];
    }else {
        [self saveRequest];
    }
    
}

- (void)checkSession:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

- (void)doTypePullDown:(UIButton *)sender
{
    [self releaseKeyBoard];
    
    _doTypeTableView.hidden = !_doTypeTableView.hidden;
    _fileNameTableView.hidden = YES;
    _fileTypeTableView.hidden = YES;
}

- (void)fileTypePullDown:(UIButton *)sender
{
    [self releaseKeyBoard];
    
    _fileTypeTableView.hidden = !_fileTypeTableView.hidden;
    _fileNameTableView.hidden = YES;
    _doTypeTableView.hidden = YES;
}

- (void)fileNamePullDown:(UIButton *)sender
{
    [self releaseKeyBoard];
    
    _fileNameTableView.hidden = !_fileNameTableView.hidden;
    _fileTypeTableView.hidden = YES;
    _doTypeTableView.hidden = YES;
}

#pragma mark - 网络请求
- (void)doRequest
{
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载...";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = TimeoutInterval;
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/filter/getfilterbyname.do;sessionid=%@",[[IpAndOther shareInstance] getIP],[[IpAndOther shareInstance] getPort],[[IpAndOther shareInstance] getSid]];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys: _oldFilterName,@"Name", nil];
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            
            [_filterDic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"name"] forKey:@"name"];
            [_filterDic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"dotype"] forKey:@"dotype"];
            [_filterDic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"filetype"] forKey:@"filetype"];
            [_filterDic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"filename"] forKey:@"filename"];
            [_filterDic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"chksid"] forKey:@"chksid"];
            [_filterDic setObject:[[resultDic objectForKey:@"data"] objectForKey:@"issys"] forKey:@"issys"];
            [_filterDic setObject:[super ASCIIString:[[resultDic objectForKey:@"data"] objectForKey:@"note"]] forKey:@"note"];
            
            [_alterFilterTableView reloadData];
            
            [self doRequestFileName];
            
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
        
        if (!_judgeBack) {
            [self.requestError_AlterView show];
        }
        
    }];
}

- (void)doRequestFileName
{
    if (_isNewAdd) {
        //等待指示器
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"正在加载...";
    }
    
    NSURL *url         = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/adminmanager/do/filter/getdodlllist.do;sessionid=%@",[[IpAndOther shareInstance] getIP],[[IpAndOther shareInstance] getPort],[[IpAndOther shareInstance] getSid]]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TimeoutInterval];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        resultStr                = [resultStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        resultStr                = [resultStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            
            if ([[resultDic objectForKey:@"data"] count] != 0) {
                for (int i = 0; i<[[resultDic objectForKey:@"data"] count]; i ++) {
                    
                    [_fileNameArray addObject:[resultDic objectForKey:@"data"][i]];
                }
            }
            
            [_fileNameTableView reloadData];
            
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            
            
        }else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"]) {
            
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            
            if (!self.judgeBack) {
                if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"]) {
                    [self.loginAgain_AlterView show];
                }else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        
        if (!self.judgeBack) {
            [self.requestError_AlterView show];
        }
    }];
    
    [operation start];
}

- (void)saveRequest
{
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在保存...";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = TimeoutInterval;
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/filter/savefilter.do;sessionid=%@",[[IpAndOther shareInstance] getIP],[[IpAndOther shareInstance] getPort],[[IpAndOther shareInstance] getSid]];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       _oldFilterName,@"OldName",
                                       _filterNameTextField.text,@"Name",
                                       _doTypeTextField.text,@"DoType",
                                       _fileTypeTextField.text,@"FileType",
                                       _fileNameTextField.text,@"FileName",
                                       [NSNumber numberWithBool:_checkSessionButton.selected],@"ChkSid",
                                       _noteTextView.text,@"Note", nil];
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            
            _oldFilterName = _filterNameTextField.text;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FromAlterFilterView" object:nil];
            
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"保存成功,重启平台后生效";
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            });
            
        }else if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"false"]) {
            
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window]animated:YES];
            
            if ([[[resultDic objectForKey:@"state"] objectForKey:@"code"] isEqualToString:@"1006"]) {
                [self.loginAgain_AlterView show];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[resultDic objectForKey:@"state"] objectForKey:@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        
        if (!_judgeBack) {
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
    
    NSString *urlpath = [NSString stringWithFormat:@"http://%@:%@/adminmanager/do/filter/addfilter.do;sessionid=%@",[[IpAndOther shareInstance] getIP],[[IpAndOther shareInstance] getPort],[[IpAndOther shareInstance] getSid]];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       _filterNameTextField.text,@"Name",
                                       _doTypeTextField.text,@"DoType",
                                       _fileTypeTextField.text,@"FileType",
                                       _fileNameTextField.text,@"FileName",
                                       [NSNumber numberWithBool:_checkSessionButton.selected],@"ChkSid",
                                       _noteTextView.text,@"Note",nil];
    
    [manager POST:urlpath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr      = [[NSString alloc] initWithString:operation.responseString];
        NSDictionary *resultDic  = [resultStr JSONValue];
        
        if ([[[resultDic objectForKey:@"state"] objectForKey:@"return"] isEqualToString:@"true"]) {
            
            //返回成功时，改变等待指示器的样式，变为保存成功
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"保存成功,重启平台后生效";
            
            self.titleLable.text = @"修改过滤器";
            _oldFilterName = _filterNameTextField.text;
            _isNewAdd = NO;
            
            //通知数据连接列表刷新列表
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FromAlterFilterView" object:nil];
            
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

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView  == _doTypeTableView) {
        
        NSArray *array = DoTypeArray;
        return array.count;
        
    }else if (tableView  == _fileTypeTableView) {
        
        NSArray *array = FileTypeArray;
        
        return array.count;
        
    }else if (tableView  == _fileNameTableView) {
        return _fileNameArray.count;
    }
    
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView  == _doTypeTableView) {
        
        NSArray *array = DoTypeArray;
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cell.textLabel.text = array[indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:TextFont_name size:15];
        
        return cell;
        
    }else if (tableView  == _fileTypeTableView) {
        
        NSArray *array = FileTypeArray;
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cell.textLabel.text = array[indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:TextFont_name size:15];
        
        return cell;
        
    }else if (tableView  == _fileNameTableView) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cell.textLabel.text = _fileNameArray[indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:TextFont_name size:15];
        
        return cell;
        
    }
    
    NSArray *array = AlterFilterArray;
    if (indexPath.row == 0) {
        static NSString *idenifier1 = @"alterFilterTableViewCell1";
        LableAndTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setNameLableFrameAndContentFrame:CGRectMake(10, 0, 90, 50)];
        
        if (_issys) {
            cell.nameLable.alpha = 0.7;
            cell.contentTextField.alpha = 0.7;
            cell.contentTextField.enabled = NO;
        }
        
        cell.nameLable.text = array[indexPath.row];
        cell.contentTextField.text = [_filterDic objectForKey:@"name"];
        _filterNameTextField = cell.contentTextField;
        _filterNameTextField.keyboardType = UIKeyboardTypeDefault;
        _filterNameTextField.delegate = self;
        _filterNameTextField.placeholder = @"以\"/\"开头的路径名";
        
        return cell;
        
    }else if (indexPath.row >0 && indexPath.row <4) {
        static NSString *idenifier2 = @"alterFilterTableViewCell2";
        LableAndTextFieldAndPullDownButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier2];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setNameLableFrameAndContentFrame:CGRectMake(10, 0, 90, 50)];
        
        if (_issys) {
            cell.nameLable.alpha = 0.7;
            cell.contentBackgroundView.alpha = 0.7;
            cell.contentTextField.enabled = NO;
            cell.pullDownButton.enabled = NO;
        }
        
        cell.nameLable.text = array[indexPath.row];
        
        switch (indexPath.row) {
            case 1:
            {
                cell.contentTextField.text    = [_filterDic objectForKey:@"dotype"];
                cell.contentTextField.enabled = NO;
                _doTypeTextField              = cell.contentTextField;
                _doTypeTextField.delegate     = self;
                
                _doTypePullDownButton = cell.pullDownButton;
                [_doTypePullDownButton addTarget:self action:@selector(doTypePullDown:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
                
            case 2:
            {
                cell.contentTextField.text    = [_filterDic objectForKey:@"filetype"];
                cell.contentTextField.enabled = NO;
                _fileTypeTextField            = cell.contentTextField;
                _fileTypeTextField.delegate   = self;
                
                _fileTypePullDownButton = cell.pullDownButton;
                [_fileTypePullDownButton addTarget:self action:@selector(fileTypePullDown:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
                
            case 3:
            {
                cell.contentTextField.text  = [_filterDic objectForKey:@"filename"];
                _fileNameTextField          = cell.contentTextField;
                _fileNameTextField.keyboardType = UIKeyboardTypeDefault;
                _fileNameTextField.delegate = self;
                
                _fileNamePullDownButton = cell.pullDownButton;
                [_fileNamePullDownButton addTarget:self action:@selector(fileNamePullDown:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
                
            default:
                break;
        }
        
        return cell;
        
    }else if (indexPath.row == 4) {
        static NSString *idenifier3 = @"alterFilterTableViewCell3";
        LableAndButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier3];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setNameLableFrameAndContentFrame:CGRectMake(10, 0, 90, 50)];
        
        if (_issys) {
            cell.nameLable.alpha = 0.7;
            cell.chooseButton.enabled = NO;
        }
        
        cell.nameLable.text = array[indexPath.row];
        _checkSessionButton = cell.chooseButton;
        [_checkSessionButton addTarget:self action:@selector(checkSession:) forControlEvents:UIControlEventTouchDown];
        
        if ([[_filterDic objectForKey:@"chksid"] intValue] == 0) {
            _checkSessionButton.selected = NO;
        }else {
            _checkSessionButton.selected = YES;
        }
        
        return cell;
        
    }else if (indexPath.row == 5) {
        static NSString *idenifier4 = @"alterFilterTableViewCell4";
        LableAndTextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier4];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setNameLableFrameAndContentFrame:CGRectMake(10, 0, 90, 50)];
        
        if (_issys) {
            cell.nameLable.alpha = 0.7;
            cell.contentTextView.alpha = 0.7;
            cell.contentTextView.editable = NO;
        }
        
        cell.nameLable.text = array[indexPath.row];
        
        cell.contentTextView.text = [_filterDic objectForKey:@"note"];
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
    if (tableView  == _doTypeTableView || tableView  == _fileTypeTableView || tableView  == _fileNameTableView) {
        return 30;
    }
    
    if (indexPath.row == 5) {
        return 100;
    }else if (indexPath.row == 6) {
        return 100;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _doTypeTableView) {
        
        NSArray *array = DoTypeArray;
        _doTypeTextField.text = array[indexPath.row];
        [self textfieldChange];
        _doTypeTableView.hidden = YES;
        
    }else if (tableView == _fileTypeTableView) {
        
        NSArray *array = FileTypeArray;
        _fileTypeTextField.text = array[indexPath.row];
        [self textfieldChange];
        _fileTypeTableView.hidden = YES;
        
    }else if (tableView == _fileNameTableView) {
        
        _fileNameTextField.text = _fileNameArray[indexPath.row];
        [self textfieldChange];
        _fileNameTableView.hidden = YES;
        
    }
}

#pragma mark - Textfield Delegate
//释放键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self releaseKeyBoard];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _doTypeTableView.hidden   = YES;
    _fileTypeTableView.hidden = YES;
    _fileNameTableView.hidden = YES;
    
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
    
    if (_filterNameTextField == textField)
    {
        if ([toBeString length] > 1024) {
            //如果粘贴内容大于128，将只截取前128的字符
            textField.text = [toBeString substringToIndex:1024];
            
            return NO;
            
        }
    }
    
    return YES;
}

//监听输入框的改变，并将修改过的数据存储，以防tableview的重用机制导致数据复原
- (void)textfieldChange
{
    [_filterDic setObject:_filterNameTextField.text forKey:@"name"];
    [_filterDic setObject:_doTypeTextField.text forKey:@"dotype"];
    [_filterDic setObject:_fileTypeTextField.text forKey:@"filetype"];
    [_filterDic setObject:_fileNameTextField.text forKey:@"filename"];
    [_filterDic setObject:_noteTextView.text forKey:@"note"];
    
    if (_checkSessionButton.selected) {
        [_filterDic setObject:@"1" forKey:@"chksid"];
    }else {
        [_filterDic setObject:@"0" forKey:@"chksid"];
    }
}

#pragma mark - TextView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text]; //得到输入框的内容
    
    if (_noteTextView == textView)
    {
        if ([toBeString length] > 1024) {
            //如果粘贴内容大于128，将只截取前128的字符
            textView.text = [toBeString substringToIndex:1024];
            
            return NO;
            
        }
    }
    
    return YES;
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (_issys) {
        return NO;
    }else {
        CGPoint touchPoint = [touch locationInView:_alterFilterTableView];
        
        CGRect rectArrow1 = _doTypeTableView.frame;
        CGRect rectArrow2 = _fileTypeTableView.frame;
        CGRect rectArrow3 = _fileNameTableView.frame;
        
        CGRect rectArrow4 = CGRectMake(_doTypeTableView.frame.origin.x+_doTypeTableView.frame.size.width-_doTypePullDownButton.frame.size.width, _doTypeTableView.frame.origin.y-_doTypePullDownButton.frame.size.height, _doTypePullDownButton.frame.size.width, _doTypePullDownButton.frame.size.height);
        CGRect rectArrow5 = CGRectMake(_fileTypeTableView.frame.origin.x+_fileTypeTableView.frame.size.width-_fileTypePullDownButton.frame.size.width, _fileTypeTableView.frame.origin.y-_fileTypePullDownButton.frame.size.height, _fileTypePullDownButton.frame.size.width, _fileTypePullDownButton.frame.size.height);
        CGRect rectArrow6 = CGRectMake(_fileNameTableView.frame.origin.x+_fileNameTableView.frame.size.width-_fileNamePullDownButton.frame.size.width, _fileNameTableView.frame.origin.y-_fileNamePullDownButton.frame.size.height, _fileNamePullDownButton.frame.size.width, _fileNamePullDownButton.frame.size.height);
        
        //Touch either arrows or month in middle
        if (!_doTypeTableView.hidden && !CGRectContainsPoint(rectArrow1, touchPoint) && !CGRectContainsPoint(rectArrow4, touchPoint))
        {
            _doTypeTableView.hidden = YES;
            return YES;
        }
        else if (!_fileTypeTableView.hidden && !CGRectContainsPoint(rectArrow2, touchPoint) && !CGRectContainsPoint(rectArrow5, touchPoint))
        {
            _fileTypeTableView.hidden = YES;
            return YES;
        }
        else if (!_fileNameTableView.hidden && !CGRectContainsPoint(rectArrow3, touchPoint) && !CGRectContainsPoint(rectArrow6, touchPoint))
        {
            _fileNameTableView.hidden = YES;
            return YES;
        }
        else {
            [self releaseKeyBoard];
            return NO;
        }
    }
}

#pragma mark - 点击空白处事件
//点击空白处释放键盘
- (void)releaseKeyBoard
{
    [_filterNameTextField resignFirstResponder];
    [_doTypeTextField     resignFirstResponder];
    [_fileTypeTextField   resignFirstResponder];
    [_fileNameTextField   resignFirstResponder];
    [_noteTextView        resignFirstResponder];
}

#pragma mark - 设置了tableview的分割线
-(void)viewDidLayoutSubviews
{
    if ([self.doTypeTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.doTypeTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([self.doTypeTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.doTypeTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.fileNameTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.fileNameTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([self.fileNameTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.fileNameTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.fileTypeTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.fileTypeTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.fileTypeTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.fileTypeTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - view即将移除时
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.judgeBack = YES;
}

@end
