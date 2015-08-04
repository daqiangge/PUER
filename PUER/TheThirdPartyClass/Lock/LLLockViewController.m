//
//  LLLockViewController.m
//  LockSample
//
//  Created by Lugede on 14/11/11.
//  Copyright (c) 2014年 lugede.cn. All rights reserved.
//

#import "LLLockViewController.h"
#import "LLLockIndicator.h"
#import "LockSettingVC.h"
#import <LocalAuthentication/LocalAuthentication.h>

#define kTipColorNormal [UIColor blackColor]
#define kTipColorError [UIColor redColor]


static BOOL fingerprint = NO;//指纹能否使用

@interface LLLockViewController ()
{
    int nRetryTimesRemain; // 剩余几次输入机会
}

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *preSnapImageView; // 上一界面截图
@property (weak, nonatomic) IBOutlet UIImageView *currentSnapImageView; // 当前界面截图
@property (nonatomic, strong) IBOutlet LLLockIndicator* indecator; // 九点指示图
@property (nonatomic, strong) IBOutlet LLLockView* lockview; // 触摸田字控件
@property (strong, nonatomic) IBOutlet UILabel *tipLable;
@property (strong, nonatomic)  UIButton *tipButton; // 重设/(取消)的提示按钮
@property (weak, nonatomic)  UIButton *fingerprintButton;

@property (nonatomic, strong) NSString* savedPassword; // 本地存储的密码
@property (nonatomic, strong) NSString* passwordOld; // 旧密码
@property (nonatomic, strong) NSString* passwordNew; // 新密码
@property (nonatomic, strong) NSString* passwordconfirm; // 确认密码
@property (nonatomic, strong) NSString* tip1; // 三步提示语
@property (nonatomic, strong) NSString* tip2;
@property (nonatomic, strong) NSString* tip3;

@end


@implementation LLLockViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithType:(LLLockViewType)type
{
    self = [super init];
    if (self) {
        _nLockViewType = type;
    }
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [super setNavTitle:@"手势密码"];
    [self setTipButtonAndFingerprintButton];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.indecator.backgroundColor = [UIColor clearColor];
    self.lockview.backgroundColor = [UIColor clearColor];
    
    //    self.horiScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, 320, 320)];
    
    self.lockview.delegate = self;
    
    LLLog(@"实例化了一个LockVC");
}

/**
 *  设置忘记密码和指纹锁按钮
 */
- (void)setTipButtonAndFingerprintButton
{
    CGFloat tipBtnW = 100;
    CGFloat tipBtnH = 40;
    CGFloat tipBtnX = 20;
    CGFloat tipBtnY = SCREEN_HEIGHT - 20 - tipBtnH;
    
    UIButton *tipBtn = [[UIButton alloc] init];
    tipBtn.frame = CGRectMake(tipBtnX, tipBtnY, tipBtnW, tipBtnH);
    tipBtn.backgroundColor = [UIColor clearColor];
    [tipBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    tipBtn.titleLabel.font = [UIFont fontWithName:TextFont_name_Bold size:13];
    tipBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [tipBtn addTarget:self action:@selector(tipButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tipBtn];
    self.tipButton = tipBtn;
    
    
    CGFloat fingerprintBtnW = tipBtnW;
    CGFloat fingerprintBtnH = tipBtnH;
    CGFloat fingerprintBtnX = SCREEN_WIDTH - 20 - fingerprintBtnW;
    CGFloat fingerprintBtnY = tipBtnY;
    
    UIButton *fingerprintBtn = [[UIButton alloc] init];
    fingerprintBtn.frame = CGRectMake(fingerprintBtnX, fingerprintBtnY, fingerprintBtnW, fingerprintBtnH);
    fingerprintBtn.backgroundColor = [UIColor clearColor];
    [fingerprintBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    fingerprintBtn.titleLabel.font = [UIFont fontWithName:TextFont_name_Bold size:13];
    [fingerprintBtn setTitle:@"指纹解锁" forState:UIControlStateNormal];
    fingerprintBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [fingerprintBtn addTarget:self action:@selector(fingerprintLock:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fingerprintBtn];
    self.fingerprintButton = fingerprintBtn;
    
//    if (!fingerprint) {
//        self.fingerprintButton.hidden = YES;
//        
//        tipBtnX = (SCREEN_WIDTH - tipBtnW)*0.5;
//        self.tipButton.frame = CGRectMake(tipBtnX, tipBtnY, tipBtnW, tipBtnH);
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    //判断是否为手势验证，如果为1则说明为验证，如果大于1则不是     验证
//    if (self.navigationController.viewControllers.count == 1)
//    {
//        self.navigationController.navigationBarHidden = YES;
//    }
    
    
    if (_nLockViewType == LLLockViewTypeCheck)
    {
        self.navigationController.navigationBarHidden = YES;
    }
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
#ifdef LLLockAnimationOn
    [self capturePreSnap];
#endif
    
    
    // 初始化内容
    switch (_nLockViewType) {
        case LLLockViewTypeCheck:
        {
            _tipLable.text = @"请输入解锁密码";
            self.logoImageView.hidden = NO;
            self.indecator.hidden = YES;
        }
            break;
            
        case LLLockViewTypeCreate:
        {
            _tipLable.text = @"创建手势密码";
            self.logoImageView.hidden = YES;
            self.indecator.hidden = NO;
            [self.indecator setPasswordString:@""];
        }
            break;
            
        case LLLockViewTypeModify:
        {
            _tipLable.text = @"请输入新的密码";
            self.logoImageView.hidden = YES;
            self.indecator.hidden = NO;
            [self.indecator setPasswordString:@""];
        }
            break;
            
        case LLLockViewTypeClean:
            
        default:
        {
            _tipLable.text = @"请输入密码以清除密码";
        }
    }
    
    // 尝试机会
    nRetryTimesRemain = LLLockRetryTimes;
    
    self.passwordOld = @"";
    self.passwordNew = @"";
    self.passwordconfirm = @"";
    
    // 本地保存的手势密码
    self.savedPassword = [LLLockPassword loadLockPassword];
    LLLog(@"本地保存的密码是%@", self.savedPassword);
    
    [self updateTipButtonStatus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 指纹验证
- (void)touchID
{
    LAContext *context = [LAContext new];
    NSError *error;
    context.localizedFallbackTitle = @"";//此处设置为空，可以影藏此左按钮
    
    //判断是否能使用指纹解锁
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        NSLog(@"Touch ID is available.");
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过验证指纹登陆PUER" reply:^(BOOL success, NSError *error) {
            if (success) {
                NSLog(@"指纹验证成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_DidBecomeActive" object:nil];
            } else {
                if (error.code == kLAErrorUserFallback) {
                    NSLog(@"用户要输入密码");
                } else if (error.code == kLAErrorUserCancel) {
                    NSLog(@"--用户取消");
                } else {
                    NSLog(@"身份验证失败。");
                }
            }
        }];
        
    }
    else
    {
        
    }
}

/**
 *  判断是否可以指纹解锁
 */
- (void)judgeFingerprint
{
    LAContext *context = [LAContext new];
    NSError *error;
    
    //判断是否能使用指纹解锁
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        fingerprint = YES;
    }
    else
    {
        fingerprint = NO;
    }
}

#pragma mark - 检查/更新密码
- (void)checkPassword:(NSString*)string
{
    // 验证密码正确
    if ([string isEqualToString:self.savedPassword]) {
        
        if (_nLockViewType == LLLockViewTypeModify) { // 验证旧密码
            
            self.passwordOld = string; // 设置旧密码，说明是在修改
            
            [self setTip:@"请输入新的密码"]; // 这里和下面的delegate不一致，有空重构
            
        } else if (_nLockViewType == LLLockViewTypeClean) { // 清除密码
            
            [LLLockPassword saveLockPassword:nil];
            [self hide];
            
            [self showAlert:self.tip2];
            
        } else { // 验证成功
            
            [self hide];
        }
        
    }
    // 验证密码错误
    else if (string.length > 0) {
        
        nRetryTimesRemain--;
        
        if (nRetryTimesRemain > 0) {
            
            if (1 == nRetryTimesRemain) {
                [self setErrorTip:[NSString stringWithFormat:@"最后的机会咯-_-!"]
                        errorPswd:string];
            } else {
                [self setErrorTip:[NSString stringWithFormat:@"密码错误，还可以再输入%d次", nRetryTimesRemain]
                        errorPswd:string];
            }
            
        } else {
            
            // 强制注销该账户，并清除手势密码，以便重设
//            [self dismissViewControllerAnimated:NO completion:nil]; // 由于是强制登录，这里必须以NO ani的方式才可
            [LLLockPassword saveLockPassword:nil];
            
            //多次错误，清除登录密码，并通知手势密码多次错误，关闭手势验证，通知回到登陆界面
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:@"fingerprintSwitch"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_lockError" object:nil];
            
            //            [self showAlert:@"超过最大次数，这里该做一些如强制退出重设密码等操作"];
        }
        
    } else {
        NSAssert(YES, @"意外情况");
    }
}

/**
 *  重置手势
 */
- (void)refershLock
{
    [self setTip:@"请输入解锁密码"];
    nRetryTimesRemain = LLLockRetryTimes;
    self.savedPassword = [LLLockPassword loadLockPassword];
}

- (void)createPassword:(NSString*)string
{
    //判读密码长度不得少于3位
    if ([string length] < 3)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"密码太短，至少3位，请重新输入";
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view  animated:YES];
        });
        
        return;
    }
    
    // 输入密码
    if ([self.passwordNew isEqualToString:@""] && [self.passwordconfirm isEqualToString:@""])
    {
        self.passwordNew = string;
        [self setTip:self.tip2];
    }
    // 确认输入密码
    else if (![self.passwordNew isEqualToString:@""] && [self.passwordconfirm isEqualToString:@""])
    {
        self.passwordconfirm = string;
        
        if ([self.passwordNew isEqualToString:self.passwordconfirm]) {
            // 成功
            LLLog(@"两次密码一致");
            
            [LLLockPassword saveLockPassword:string];
            
            [self showAlert:self.tip3];
            
            [self hide];
            
        }
        else
        {
            self.passwordconfirm = @"";
            [self setTip:@"与上一次绘制不一致，请重新绘制"];
            [self.indecator setPasswordString:@""];
            self.passwordNew = @"";
            
//            self.passwordNew = @"";
//            [self setTip:self.tip2];
//            [self setErrorTip:@"与上一次绘制不一致，请重新绘制" errorPswd:string];
        }
    }
    else
    {
        NSAssert(1, @"设置密码意外");
    }
}

#pragma mark - 显示提示
- (void)setTip:(NSString*)tip
{
    [_tipLable setText:tip];
    [_tipLable setTextColor:kTipColorNormal];
    
    _tipLable.alpha = 0;
    [UIView animateWithDuration:0.8
                     animations:^{
                         _tipLable.alpha = 1;
                     }completion:^(BOOL finished){
                     }
     ];
}

// 错误
- (void)setErrorTip:(NSString*)tip errorPswd:(NSString*)string
{
    // 显示错误点点
    [self.lockview showErrorCircles:string];
    
    // 直接_变量的坏处是
    [_tipLable setText:tip];
    [_tipLable setTextColor:kTipColorError];
    
    [self shakeAnimationForView:_tipLable];
}

#pragma mark 新建/修改后保存
- (void)updateTipButtonStatus
{
    NSLog(@"重设TipButton");
//    if ((_nLockViewType == LLLockViewTypeCreate || _nLockViewType == LLLockViewTypeModify) &&
//        ![self.passwordNew isEqualToString:@""]) // 新建或修改 & 确认时 才显示按钮
//    {
//        [self.tipButton setTitle:@"点击此处以重新开始" forState:UIControlStateNormal];
//        [self.tipButton setAlpha:1.0];
//        
//    }
    
    if (_nLockViewType == LLLockViewTypeCheck)//忘记密码---验证密码
    {
        [self.tipButton setTitle:@"忘记手势密码？" forState:UIControlStateNormal];
        [self.tipButton setAlpha:1.0];
        [self.fingerprintButton setAlpha:1.0];
    }
    else
    {
        [self.tipButton setAlpha:0.0];
        [self.fingerprintButton setAlpha:0.0];
    }
    
    // 更新指示圆点
    if (![self.passwordNew isEqualToString:@""] && [self.passwordconfirm isEqualToString:@""]){
        self.indecator.hidden = NO;
        [self.indecator setPasswordString:self.passwordNew];
    }
//    else
//    {
//        self.indecator.hidden = YES;
//    }
    
    
}

#pragma mark - 点击了按钮
- (void)tipButtonPressed:(id)sender
{
//    if ((_nLockViewType == LLLockViewTypeCreate || _nLockViewType == LLLockViewTypeModify) &&
//        ![self.passwordNew isEqualToString:@""]) // 新建或修改 & 确认时 才显示按钮
//    {
//        self.passwordNew = @"";
//        self.passwordconfirm = @"";
//        [self setTip:self.tip1];
//        [self updateTipButtonStatus];
//        
//    }
    
    if (_nLockViewType == LLLockViewTypeCheck)//忘记密码---验证密码
    {
        [LLLockPassword saveLockPassword:nil];
        
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:@"fingerprintSwitch"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_lockError" object:nil];
    }
}

/**
 *  指纹密码
 */
- (void)fingerprintLock:(UIButton *)sender
{
    BOOL fingerprintSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"fingerprintSwitch"];
    if (fingerprintSwitch)
    {
        [self touchID];
    }
    else
    {
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"未开启PUER指纹解锁" message:@"请在PUER设置-手势、指纹锁定，开启Touch ID指纹锁定" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alterView show];
        UIWindow *window = [alterView window];
        window.windowLevel = 2100.0;
        
    }
}

#pragma mark - 成功后返回
- (void)hide
{
    switch (_nLockViewType) {
            
        case LLLockViewTypeCheck:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_DidBecomeActive" object:nil];
        }
            break;
        case LLLockViewTypeCreate:
        {
            LockSettingVC *lockSettingVC = [[LockSettingVC alloc] init];
            [self.navigationController pushViewController:lockSettingVC animated:YES];
            
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:@"lockSwitch"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
            break;
            
        case LLLockViewTypeModify:
        {
            [LLLockPassword saveLockPassword:self.passwordNew];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case LLLockViewTypeClean:
        {
            
        }
            break;
        default:
        {
            [LLLockPassword saveLockPassword:nil];
        }
            break;
    }
    
    // 在这里可能需要回调上个页面做一些刷新什么的动作
    
    //#ifdef LLLockAnimationOn
    //     [self captureCurrentSnap];
    //    // 隐藏控件
    //    for (UIView* v in self.view.subviews) {
    //        if (v.tag > 10000) continue;
    //        v.hidden = YES;
    //    }
    //    // 动画解锁
    //    [self animateUnlock];
    //#else
    ////    [self dismissViewControllerAnimated:NO completion:nil];
    //#endif
    
}

#pragma mark - delegate 每次划完手势后
- (void)lockString:(NSString *)string
{
    LLLog(@"这次的密码=--->%@<---", string);
    
    switch (_nLockViewType) {
            
        case LLLockViewTypeCheck:
        {
            self.tip1 = @"请输入解锁密码";
            [self checkPassword:string];
        }
            break;
        case LLLockViewTypeCreate:
        {
            self.tip1 = @"创建解锁密码";
            self.tip2 = @"请再次绘制解锁密码";
            self.tip3 = @"手势密码创建成功";
            [self createPassword:string];
        }
            break;
        case LLLockViewTypeModify:
        {
//            if ([self.passwordOld isEqualToString:@""]) {
//                self.tip1 = @"请输入原来的密码";
//                [self checkPassword:string];
//            }
//            else
//            {
                self.tip1 = @"请输入新的密码";
                self.tip2 = @"请再次输入密码";
                self.tip3 = @"密码修改成功";
                [self createPassword:string];
//            }
        }
            break;
        case LLLockViewTypeClean:
        default:
        {
            self.tip1 = @"请输入密码以清除密码";
            self.tip2 = @"清除密码成功";
            [self checkPassword:string];
        }
    }
    
    [self updateTipButtonStatus];
}

#pragma mark - 解锁动画
// 截屏，用于动画
#ifdef LLLockAnimationOn
- (UIImage *)imageFromView:(UIView *)theView
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

// 上一界面截图
- (void)capturePreSnap
{
    self.preSnapImageView.hidden = YES; // 默认是隐藏的
    self.preSnapImageView.image = [self imageFromView:self.presentingViewController.view];
}

// 当前界面截图
- (void)captureCurrentSnap
{
    self.currentSnapImageView.hidden = YES; // 默认是隐藏的
    self.currentSnapImageView.image = [self imageFromView:self.view];
}

- (void)animateUnlock{
    
    self.currentSnapImageView.hidden = NO;
    self.preSnapImageView.hidden = NO;
    
    static NSTimeInterval duration = 0.5;
    
    // currentSnap
    CABasicAnimation* scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:2.0];
    
    CABasicAnimation *opacityAnimation;
    opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue=[NSNumber numberWithFloat:1];
    opacityAnimation.toValue=[NSNumber numberWithFloat:0];
    
    CAAnimationGroup* animationGroup =[CAAnimationGroup animation];
    animationGroup.animations = @[scaleAnimation, opacityAnimation];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.duration = duration;
    animationGroup.delegate = self;
    animationGroup.autoreverses = NO; // 防止最后显现
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    [self.currentSnapImageView.layer addAnimation:animationGroup forKey:nil];
    
    // preSnap
    scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.5];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
    
    opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:1];
    
    animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[scaleAnimation, opacityAnimation];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.duration = duration;
    
    [self.preSnapImageView.layer addAnimation:animationGroup forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.currentSnapImageView.hidden = YES;
    [self dismissViewControllerAnimated:NO completion:nil];
}
#endif

#pragma mark 抖动动画
- (void)shakeAnimationForView:(UIView *)view
{
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint left = CGPointMake(position.x - 10, position.y);
    CGPoint right = CGPointMake(position.x + 10, position.y);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:left]];
    [animation setToValue:[NSValue valueWithCGPoint:right]];
    [animation setAutoreverses:YES]; // 平滑结束
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    
    [viewLayer addAnimation:animation forKey:nil];
}

#pragma mark - 提示信息
- (void)showAlert:(NSString*)string
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:string
                                                   delegate:nil
                                          cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

@end
