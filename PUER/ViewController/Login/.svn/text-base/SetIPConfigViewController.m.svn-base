//
//  SetIPConfigViewController.m
//  PUER
//
//  Created by admin on 14-8-14.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "SetIPConfigViewController.h"
#import "SetIPandPortTableViewCell.h"

@interface SetIPConfigViewController ()

@end

@implementation SetIPConfigViewController

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
    
    _cellRow = 0;
    
    [super setNavTitle:@"设置IP及端口"];
    [self doLoading];
    [self initPullDownButton];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 加载视图控件
- (void)doLoading
{
    
    NSString *IP                       = [[NSUserDefaults standardUserDefaults] objectForKey:@"IP"];
    NSString *port                     = [[NSUserDefaults standardUserDefaults] objectForKey:@"port"];
    
    UILabel *IPLable                   = [[UILabel alloc] init];
    UILabel *portLable                 = [[UILabel alloc] init];
    _IPTextField                       = [[LQTextField alloc] init];
    _portTextField                     = [[LQTextField alloc] init];
    
    IPLable.frame                      = CGRectMake(10, 20+64, 200, 20);
    
    self.IPTextField.frame             = CGRectMake(IPLable.frame.origin.x, IPLable.frame.origin.y+IPLable.frame.size.height+5, SCREEN_WIDTH-20, TextField_height);
    portLable.frame                    = CGRectMake(IPLable.frame.origin.x, self.IPTextField.frame.origin.y+self.IPTextField.frame.size.height+20, IPLable.frame.size.width, IPLable.frame.size.height);
    self.portTextField.frame           = CGRectMake(IPLable.frame.origin.x, portLable.frame.origin.y+portLable.frame.size.height+5, self.IPTextField.frame.size.width, self.IPTextField.frame.size.height);
    
    self.IPTextField.layer.cornerRadius        = TextField_layer_cornerRadius;
    self.IPTextField.layer.borderWidth         = TextField_layer_borderWidth;
    self.IPTextField.layer.borderColor         = TextField_layer_borderColor;
    self.portTextField.layer.cornerRadius      = TextField_layer_cornerRadius;
    self.portTextField.layer.borderWidth       = TextField_layer_borderWidth;
    self.portTextField.layer.borderColor       = TextField_layer_borderColor;
    
    IPLable.text                       = @"服务器地址：";
    portLable.text                     = @"服务器端口：";
    
    IPLable.textAlignment              = NSTextAlignmentLeft;
    portLable.textAlignment            = NSTextAlignmentLeft;
    
    IPLable.font                       = [UIFont fontWithName:TextFont_name size:15];
    portLable.font                     = [UIFont fontWithName:TextFont_name size:15];
    
    self.IPTextField.backgroundColor   = TextField_backgroundCollor;
    self.portTextField.backgroundColor = TextField_backgroundCollor;
    
    self.IPTextField.delegate          = self;
    self.portTextField.delegate        = self;
    
    self.IPTextField.text              = IP;
    self.portTextField.text            = port;
    
    self.IPTextField.textAlignment     = NSTextAlignmentLeft;
    self.portTextField.textAlignment   = NSTextAlignmentLeft;
    
    self.IPTextField.keyboardType      = UIKeyboardTypeASCIICapable;
    self.portTextField.keyboardType    = UIKeyboardTypeNumberPad;
    
    [self.view addSubview:IPLable];
    [self.view addSubview:self.IPTextField];
    [self.view addSubview:portLable];
    [self.view addSubview:self.portTextField];
    
    UIButton *saveButton               = [[UIButton alloc] init];
    saveButton.frame                   = CGRectMake(IPLable.frame.origin.x, self.portTextField.frame.origin.y+self.portTextField.frame.size.height+30, self.portTextField.frame.size.width, Button_height);
    [saveButton setBackgroundImage:[UIImage imageNamed:@"buttonbg3"] forState:UIControlStateNormal];
    [saveButton setTitle:@"确定" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveIPandPost) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
    //设置点击空白处释放键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(releaseKeyBoard)];
    tapGestureRecognizer.delegate = self;
    tapGestureRecognizer.numberOfTapsRequired = 1; // * 点击空白处几下
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

/** 初始化下拉列表按钮 */
- (void)initPullDownButton
{
    _pullDownButton = [[UIButton alloc] init];
    _pullDownButton.frame = CGRectMake(_IPTextField.frame.origin.x+_IPTextField.frame.size.width-TextField_height, _IPTextField.frame.origin.y, TextField_height, TextField_height);
    [_pullDownButton setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    _pullDownButton.layer.cornerRadius      = TextField_layer_cornerRadius;
    _pullDownButton.layer.borderWidth       = TextField_layer_borderWidth;
    _pullDownButton.layer.borderColor       = TextField_layer_borderColor;
    [_pullDownButton addTarget:self action:@selector(pullDownTableView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pullDownButton];
}

/** 初始化下拉列表 */
- (void)initTableView
{
    _IPandPortArray = [[NSMutableArray alloc] init];
    [_IPandPortArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"IPandPortArray"]];
    
    
    _pullDownTableView = [[UITableView alloc] init];
    _pullDownTableView.frame = CGRectMake(_IPTextField.frame.origin.x, _IPTextField.frame.origin.y+_IPTextField.frame.size.height+2, _IPTextField.frame.size.width, 50*3);
    _pullDownTableView.delegate = self;
    _pullDownTableView.dataSource = self;
    _pullDownTableView.hidden = YES;
    _pullDownTableView.delaysContentTouches = NO;
    _pullDownTableView.layer.cornerRadius      = TextField_layer_cornerRadius;
    _pullDownTableView.layer.borderWidth       = TextField_layer_borderWidth;
    _pullDownTableView.layer.borderColor       = TextField_layer_borderColor;
    [self.view addSubview:_pullDownTableView];
    
    //给tableview注册一个cell模板
    NSString *identifer = @"SetIPandPortTableViewCell";
    UINib *nib = [UINib nibWithNibName:@"SetIPandPortTableViewCell" bundle:nil];
    [_pullDownTableView registerNib:nib forCellReuseIdentifier:identifer];
}

#pragma mark - 按钮操作
/** 保存ip和端口操作 */
- (void)saveIPandPost
{
    [self releaseKeyBoard];
    _pullDownTableView.hidden = YES;
    
    //判断输入框是否有空
    if ([self.IPTextField.text isEqualToString:@""] || [self.portTextField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入正确的服务器地址和端口"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if (![[Regex shareInstance] judgeIPAndURL:self.IPTextField.text])
    {
        return;
    }
    
    //等待指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"保存成功";
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.IPTextField.text forKey:@"IP"];
    [dic setObject:self.portTextField.text forKey:@"port"];
    [dic setObject:@"" forKey:@"note"];
    
    if (_IPandPortArray.count == 0)
    {
        [_IPandPortArray addObject:dic];
    }
    else
    {
        int z = 0;
        
        for (int i = 0; i<_IPandPortArray.count; i++) {
            if ([[_IPandPortArray[i] objectForKey:@"IP"] isEqualToString:self.IPTextField.text] && [[_IPandPortArray[i] objectForKey:@"port"] isEqualToString:self.portTextField.text])
            {
                break;
            }
            else
            {
                z ++;
            }
        }
        
        if (z == _IPandPortArray.count)
        {
            [_IPandPortArray addObject:dic];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:_IPandPortArray   forKey:@"IPandPortArray"];
    [[NSUserDefaults standardUserDefaults] setObject:self.IPTextField.text   forKey:@"IP"  ];
    [[NSUserDefaults standardUserDefaults] setObject:self.portTextField.text forKey:@"port"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_pullDownTableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        //隐藏等待指示器
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    });
}

/** 点击按钮下拉列表操作 */
- (void)pullDownTableView:(UIButton *)sender
{
    [self releaseKeyBoard];
    
    _pullDownTableView.hidden = !_pullDownTableView.hidden;
}

/** 修改备注操作 */
- (void)editIPandPort:(UIButton *)sender
{
    _cellRow = sender.tag-100;
    _editAlterView = [[UIAlertView alloc] initWithTitle:@"修改备注"
                                                  message:nil
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                        otherButtonTitles:@"确定", nil];
    _editAlterView.alertViewStyle = UIAlertViewStylePlainTextInput;
    _editTextField = [_editAlterView textFieldAtIndex:0];
    _editTextField.text = [_IPandPortArray[_cellRow] objectForKey:@"note"];
    [_editAlterView show];

}

/** 删除ip和端口的操作 */
- (void)deleteIPandPort:(UIButton *)sender
{
    _cellRow = sender.tag-200;
    
    _deleteAlterView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                  message:[NSString stringWithFormat:@"确定要删除 %@:%@ 这条记录吗？",[_IPandPortArray[_cellRow] objectForKey:@"IP"],[_IPandPortArray[_cellRow] objectForKey:@"port"]]
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                        otherButtonTitles:@"确定", nil];
    [_deleteAlterView show];
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    long int IPandPortArrayCount = _IPandPortArray.count;
    
    
    if (IPandPortArrayCount == 0)
    {
        IPandPortArrayCount = 1;
    }
    
    return IPandPortArrayCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_IPandPortArray.count == 0)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cell.textLabel.text = @"无";
        cell.textLabel.font = [UIFont fontWithName:TextFont_name size:15];
        
        return cell;
    }
    
    static NSString *idenifier = @"SetIPandPortTableViewCell";
    SetIPandPortTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    
    cell.IPLable.text = [NSString stringWithFormat:@"%@:%@",[_IPandPortArray[indexPath.row] objectForKey:@"IP"],[_IPandPortArray[indexPath.row] objectForKey:@"port"]];
    cell.editButton.tag   = indexPath.row+100;
    cell.deleteButton.tag = indexPath.row+200;
    [cell.editButton addTarget:self action:@selector(editIPandPort:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteButton addTarget:self action:@selector(deleteIPandPort:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[_IPandPortArray[indexPath.row] objectForKey:@"note"] isEqualToString:@""])
    {
        cell.nameLable.text = @"暂无备注";
    }
    else
    {
        cell.nameLable.text = [_IPandPortArray[indexPath.row] objectForKey:@"note"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_IPandPortArray.count == 0)
    {
        _pullDownTableView.hidden = YES;
    }
    else
    {
        _IPTextField.text         = [_IPandPortArray[indexPath.row] objectForKey:@"IP"];
        _portTextField.text       = [_IPandPortArray[indexPath.row] objectForKey:@"port"];
        _pullDownTableView.hidden = YES;
        
        [[NSUserDefaults standardUserDefaults] setObject:self.IPTextField.text   forKey:@"IP"  ];
        [[NSUserDefaults standardUserDefaults] setObject:self.portTextField.text forKey:@"port"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint touchPoint = [touch locationInView:self.view];
    
    CGRect rectArrow1 = _pullDownTableView.frame;
    CGRect rectArrow2 = CGRectMake(_pullDownTableView.frame.origin.x+_IPTextField.frame.size.width-_pullDownButton.frame.size.width, _pullDownTableView.frame.origin.y-_pullDownButton.frame.size.height, _pullDownButton.frame.size.width, _pullDownButton.frame.size.height);
    
    //Touch either arrows or month in middle
    if (!CGRectContainsPoint(rectArrow1, touchPoint) && !CGRectContainsPoint(rectArrow2, touchPoint))
    {
        _pullDownTableView.hidden = YES;
    }
    
    if (CGRectContainsPoint(rectArrow1, touchPoint) && !_pullDownTableView.hidden)
    {
        return NO;
    }
    
    return YES;
}

#pragma mark - AlterView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == _deleteAlterView)
    {
        if (buttonIndex == 1)
        {
            if ([_IPTextField.text isEqualToString:[_IPandPortArray[_cellRow] objectForKey:@"IP"]]&&[_portTextField.text isEqualToString:[_IPandPortArray[_cellRow] objectForKey:@"port"]])
            {
                _IPTextField.text   = @"";
                _portTextField.text = @"";
                
                [[NSUserDefaults standardUserDefaults] setObject:self.IPTextField.text   forKey:@"IP"  ];
                [[NSUserDefaults standardUserDefaults] setObject:self.portTextField.text forKey:@"port"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            [_IPandPortArray removeObjectAtIndex:_cellRow];
            [_pullDownTableView reloadData];
            [[NSUserDefaults standardUserDefaults] setObject:_IPandPortArray   forKey:@"IPandPortArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            _pullDownTableView.hidden = YES;
            
        }
    }
    else if (alertView == _editAlterView)
    {
        if (buttonIndex == 1)
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_IPandPortArray[_cellRow]];
            [dic setObject:_editTextField.text forKey:@"note"];
            
            [(NSMutableArray *)_IPandPortArray replaceObjectAtIndex:_cellRow withObject:dic];
            [_pullDownTableView reloadData];
            
            [[NSUserDefaults standardUserDefaults] setObject:_IPandPortArray   forKey:@"IPandPortArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
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
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (self.IPTextField == textField)
    {
        if ([toBeString length] > 128) {
            textField.text = [toBeString substringToIndex:128];
            
            return NO;
        }
    }
    else if(self.portTextField == textField)
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
        
        if ([toBeString length] > 5)
        {
            textField.text = [toBeString substringToIndex:5];
            
            return NO;
        }
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

#pragma mark - 点击空白处释放键盘
/** 释放键盘 */
- (void)releaseKeyBoard
{
//    [self.IPTextField resignFirstResponder];
//    [self.portTextField resignFirstResponder];
    [self.view endEditing:YES];
}

#pragma mark - 设置了tableview的分割线
-(void)viewDidLayoutSubviews
{
    if ([self.pullDownTableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.pullDownTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.pullDownTableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.pullDownTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.pullDownTableView) {
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

@end
