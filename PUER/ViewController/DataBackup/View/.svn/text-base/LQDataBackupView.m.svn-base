//
//  LQDataBackupView.m
//  PUER
//
//  Created by admin on 15/6/1.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "LQDataBackupView.h"
#import "LQDataBackupButton.h"

#define dataMaintenanceTitle @[@"表",@"视图",@"函数",@"存储过程",@"触发器",@"活动监视",@"文件",@"SQL执行"]
#define dataBackupTitle @[@"完全备份",@"差异备份",@"数据收缩"]

@interface LQDataBackupView()

@property (nonatomic, strong) UIView *menuView;

@end

@implementation LQDataBackupView

- (UIView *)menuView
{
    if (_menuView == nil) {
        
        CGRect menuframe = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.menuHeight);
        UIView * view = [[UIView alloc] initWithFrame:menuframe];
        view.backgroundColor = [UIColor whiteColor];
        [self.superview addSubview:view];
        
        _menuView = view;
    }
    
    return _menuView;
}

- (void)setButtonNum:(int)buttonNum
{
    _buttonNum = buttonNum;
    
    int totalCol ;
    int totalLine ;
    NSArray *title = [NSArray array];
    
    if (buttonNum >= 4) {
        totalCol = 4;
        totalLine = 2;
        title = dataMaintenanceTitle;
    }else {
        totalCol = 3;
        totalLine = 1;
        title = dataBackupTitle;
    }
    
    CGFloat buttonW = self.menuView.frame.size.width/totalCol;
    CGFloat buttonH = self.menuView.frame.size.height/totalLine;
    
    for (int i = 0; i < buttonNum; i++) {
        int row = i / totalCol;
        int col = i % totalCol;
        
        CGFloat x = col * buttonW;
        CGFloat y = row * buttonH;
        CGRect buttonFrame = CGRectMake(x, y , buttonW, buttonH);
        
        LQDataBackupButton *button = [[LQDataBackupButton alloc] initWithFrame:buttonFrame];
        [button setImage:[UIImage imageNamed:title[i]] forState:UIControlStateNormal];
        [button setTitle:title[i] forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        
        CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(button.bounds), CGRectGetMidY(button.bounds));
        
        // 找出imageView最终的center
        CGPoint endImageViewCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetMidY(button.imageView.bounds));
        
        // 找出titleLabel最终的center
        CGPoint endTitleLabelCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetHeight(button.bounds)-CGRectGetMaxY(button.titleLabel.bounds));
        
        // 取得imageView最初的center
        CGPoint startImageViewCenter = button.imageView.center;
        
        // 取得titleLabel最初的center
        CGPoint startTitleLabelCenter = button.titleLabel.center;
        
        // 设置imageEdgeInsets
        CGFloat imageEdgeInsetsTop = endImageViewCenter.y - startImageViewCenter.y+10;
        CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x;
        CGFloat imageEdgeInsetsBottom = -imageEdgeInsetsTop;
        CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
        
        button.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop, imageEdgeInsetsLeft, imageEdgeInsetsBottom, imageEdgeInsetsRight);
        
        // 设置titleEdgeInsets
        CGFloat titleEdgeInsetsTop = endTitleLabelCenter.y-startTitleLabelCenter.y;
        CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x-10;
        CGFloat titleEdgeInsetsBottom = -titleEdgeInsetsTop;
        CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft-20;
        
        button.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop, titleEdgeInsetsLeft, titleEdgeInsetsBottom, titleEdgeInsetsRight);
        
        [self.menuView addSubview:button];
        
        // 添加监听方法，点击事件
        [button addTarget:self action:@selector(optionClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setOpen:(BOOL)open
{
    _open = open;
    
    if (_open) {
        self.hidden = !_open;
        self.menuView.hidden = !_open;
        [UIView animateWithDuration:0.3 animations:^{
            self.menuView.frame = CGRectMake(0, SCREEN_HEIGHT - self.menuHeight, SCREEN_WIDTH, self.menuHeight);
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self.menuView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.menuHeight);
        } completion:^(BOOL finished) {
            self.hidden = !_open;
            self.menuView.hidden = !_open;
        }];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.5;
    }
    
    return self;
}

+ (instancetype)dataBackupView
{
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    LQDataBackupView *dataBackupView = [[LQDataBackupView alloc] initWithFrame:frame];
    
    return dataBackupView;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.open = NO;
    
    if ([self.dataBackupViewDelegate respondsToSelector:@selector(dataBackupMenuDidClose:)]) {
        [self.dataBackupViewDelegate dataBackupMenuDidClose:self];
    }
}

- (void)optionClick:(UIButton *)button
{
    if (self.buttonNum == 3) {
        NSArray *array = dataBackupTitle;
        
        for (int i = 0; i < array.count; i ++) {
            if ([button.titleLabel.text isEqualToString:dataBackupTitle[i]]) {
                
                switch (i) {
                    case 0:
                        if ([self.dataBackupViewDelegate respondsToSelector:@selector(dataBackupButtonDidCompleteBackup:)]) {
                            [self.dataBackupViewDelegate dataBackupButtonDidCompleteBackup:self];
                        }
                        break;
                        
                    case 1:
                        if ([self.dataBackupViewDelegate respondsToSelector:@selector(dataBackupButtonDidDifferentialBackup:)]) {
                            [self.dataBackupViewDelegate dataBackupButtonDidDifferentialBackup:self];
                        }
                        break;
                        
                    case 2:
                        if ([self.dataBackupViewDelegate respondsToSelector:@selector(dataBackupButtonDidDataShrinkage:)]) {
                            [self.dataBackupViewDelegate dataBackupButtonDidDataShrinkage:self];
                        }
                        break;
                        
                    default:
                        break;
                }
                
                break;
            }
        }
    }else {
        NSArray *array = dataMaintenanceTitle;
        
        for (int i = 0; i < array.count; i ++) {
            if ([button.titleLabel.text isEqualToString:dataMaintenanceTitle[i]]) {
                
                switch (i) {
                    case 0:
                        if ([self.dataBackupViewDelegate respondsToSelector:@selector(dataMaintenanceButtonWithTable:)]) {
                            [self.dataBackupViewDelegate dataMaintenanceButtonWithTable:self];
                        }
                        break;
                        
                    case 1:
                        if ([self.dataBackupViewDelegate respondsToSelector:@selector(dataMaintenanceButtonWithView:)]) {
                            [self.dataBackupViewDelegate dataMaintenanceButtonWithView:self];
                        }
                        break;
                        
                    case 2:
                        if ([self.dataBackupViewDelegate respondsToSelector:@selector(dataMaintenanceButtonWithFunction:)]) {
                            [self.dataBackupViewDelegate dataMaintenanceButtonWithFunction:self];
                        }
                        break;
                        
                    case 3:
                        if ([self.dataBackupViewDelegate respondsToSelector:@selector(dataMaintenanceButtonWithStoredProcedure:)]) {
                            [self.dataBackupViewDelegate dataMaintenanceButtonWithStoredProcedure:self];
                        }
                        break;
                        
                    case 4:
                        if ([self.dataBackupViewDelegate respondsToSelector:@selector(dataMaintenanceButtonWithTrigger:)]) {
                            [self.dataBackupViewDelegate dataMaintenanceButtonWithTrigger:self];
                        }
                        break;
                        
                    case 5:
                        if ([self.dataBackupViewDelegate respondsToSelector:@selector(dataMaintenanceButtonWithActivityMonitoring:)]) {
                            [self.dataBackupViewDelegate dataMaintenanceButtonWithActivityMonitoring:self];
                        }
                        break;
                        
                    case 6:
                        if ([self.dataBackupViewDelegate respondsToSelector:@selector(dataMaintenanceButtonWithFile:)]) {
                            [self.dataBackupViewDelegate dataMaintenanceButtonWithFile:self];
                        }
                        break;
                        
                    case 7:
                        if ([self.dataBackupViewDelegate respondsToSelector:@selector(dataMaintenanceButtonWithSQL:)]) {
                            [self.dataBackupViewDelegate dataMaintenanceButtonWithSQL:self];
                        }
                        break;
                        
                    default:
                        break;
                }
                
                break;
            }
        }
    }
}

@end
