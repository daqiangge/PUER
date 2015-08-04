//
//  LQExecutiveSQLHeaderView.m
//  PUER
//
//  Created by admin on 15/6/4.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "LQExecutiveSQLHeaderView.h"

@implementation LQExecutiveSQLHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat executivebgvX = 10;
        CGFloat executivebgvY = 10;
        CGFloat executivebgvH = self.frame.size.height-10;
        CGFloat executivebgvW = (self.frame.size.width-50)*0.5;
        CGRect executivebgvF = CGRectMake(executivebgvX, executivebgvY, executivebgvW, executivebgvH);
        
        UIView *executivebgv = [[UIView alloc] init];
        executivebgv.frame = executivebgvF;
        executivebgv.layer.borderColor = layer_borderColor;
        executivebgv.layer.borderWidth = layer_borderWidth;
        executivebgv.layer.cornerRadius = layer_cornerRadius;
        [self addSubview:executivebgv];
        
        //执行
        CGFloat executiveButtonX = 0;
        CGFloat executiveButtonY = 0;
        CGFloat executiveButtonW = executivebgvW-executivebgvH;
        CGFloat executiveButtonH = executivebgvH;
        CGRect executiveButtonF = CGRectMake(executiveButtonX, executiveButtonY, executiveButtonW, executiveButtonH);
        
        UIButton *executiveButton = [[UIButton alloc] init];
        executiveButton.frame = executiveButtonF;
        [executiveButton setTitle:@"执行" forState:UIControlStateNormal];
        [executiveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        executiveButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [executiveButton setBackgroundImage:[UIImage imageNamed:@"buttonbg3"] forState:UIControlStateNormal];
        [executiveButton addTarget:self action:@selector(executive) forControlEvents:UIControlEventTouchUpInside];
        [executivebgv addSubview:executiveButton];
        
        //下拉
        CGFloat pulldownButtonX = CGRectGetMaxX(executiveButton.frame);
        CGFloat pulldownButtonY = CGRectGetMinY(executiveButton.frame);
        CGFloat pulldownButtonW = executiveButtonH;
        CGFloat pulldownButtonH = executiveButtonH;
        CGRect pulldownButtonF = CGRectMake(pulldownButtonX, pulldownButtonY, pulldownButtonW, pulldownButtonH);
        
        UIButton *pulldownButton = [[UIButton alloc] init];
        pulldownButton.frame = pulldownButtonF;
        [pulldownButton setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
        [pulldownButton addTarget:self action:@selector(pullDown) forControlEvents:UIControlEventTouchUpInside];
        [executivebgv addSubview:pulldownButton];
        self.pullDownBtn = pulldownButton;
        
        //锁
        CGFloat lockButtonX = CGRectGetMaxX(executivebgv.frame)+10;
        CGFloat lockButtonY = CGRectGetMinY(executivebgv.frame);
        CGFloat lockButtonW = self.frame.size.width-lockButtonX-10;
        CGFloat lockButtonH = CGRectGetHeight(executivebgv.frame);
        CGRect lockButtonF = CGRectMake(lockButtonX, lockButtonY, lockButtonW, lockButtonH);
        
        UIButton *lockButton = [[UIButton alloc] init];
        lockButton.frame = lockButtonF;
        [lockButton setTitle:@"锁定SQL语句执行功能" forState:UIControlStateNormal];
        [lockButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [lockButton addTarget:self action:@selector(lock) forControlEvents:UIControlEventTouchUpInside];
        lockButton.titleLabel.font = executiveButton.titleLabel.font;
        [lockButton setBackgroundImage:[UIImage imageNamed:@"buttonbg2"] forState:UIControlStateNormal];
        lockButton.layer.borderColor = layer_borderColor;
        lockButton.layer.borderWidth = layer_borderWidth;
        lockButton.layer.cornerRadius = layer_cornerRadius;
        [self addSubview:lockButton];
        
    }
    
    return self;
}

+ (instancetype)executiveSQLHeaderView
{
    CGRect frame = CGRectMake(0, NavgationBarAndStareBar_height, SCREEN_WIDTH, TableViewHeaderHeight+10);
    
    LQExecutiveSQLHeaderView *hearderView = [[LQExecutiveSQLHeaderView alloc] initWithFrame:frame];
    
    return hearderView;
}

/**
 *  执行
 */
- (void)executive
{
    if ([self.delegate respondsToSelector:@selector(executiveSQLHeaderViewDidExecutive:)]) {
        [self.delegate executiveSQLHeaderViewDidExecutive:self];
    }
}

/**
 *  下啦
 */
- (void)pullDown
{
    if ([self.delegate respondsToSelector:@selector(executiveSQLHeaderViewDidPullDown:)]) {
        [self.delegate executiveSQLHeaderViewDidPullDown:self];
    }
}

/**
 *  锁定SQL
 */
- (void)lock
{
    if ([self.delegate respondsToSelector:@selector(executiveSQLHeaderViewDidLock:)]) {
        [self.delegate executiveSQLHeaderViewDidLock:self];
    }
}

@end
