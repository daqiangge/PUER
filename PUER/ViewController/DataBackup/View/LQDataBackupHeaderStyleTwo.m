//
//  LQDataBackupHeaderStyleTwo.m
//  PUER
//
//  Created by admin on 15/6/3.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "LQDataBackupHeaderStyleTwo.h"

@interface LQDataBackupHeaderStyleTwo()

@property (nonatomic, weak) UILabel *lableOne;
@property (nonatomic, weak) UILabel *lableTwo;
@property (nonatomic, weak) UILabel *lableThr;
@property (nonatomic, weak) UILabel *lableFou;

@end

@implementation LQDataBackupHeaderStyleTwo

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = HearderViewBackgroundColor;
        
        //背景view下的细线
        UIView *lineView       = [[UIView alloc] init];
        lineView.frame         = CGRectMake(0, 39.5, SCREEN_WIDTH, 0.5);
        lineView.backgroundColor = [UIColor grayColor];
        lineView.alpha           = 0.6;
        [self addSubview:lineView];
        
        //属性名称lable--ID
        UILabel *lableOne      = [[UILabel alloc] init];
        lableOne.frame         = CGRectMake(10, 0, 20, TableViewHeaderHeight);
        lableOne.textAlignment = NSTextAlignmentCenter;
        lableOne.font          = [UIFont systemFontOfSize:14];
        lableOne.textColor     = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        [self addSubview:lableOne];
        self.lableOne = lableOne;
        
        //属性名称lable--进程ID
        CGFloat lableTwoX = CGRectGetMaxX(self.lableOne.frame) +5;
        CGFloat lableTwoY = CGRectGetMinY(self.lableOne.frame);
        CGFloat lableTwoW = 80;
        CGFloat lableTwoH = CGRectGetHeight(self.lableOne.frame);
        CGRect  lableTwoF = CGRectMake(lableTwoX, lableTwoY, lableTwoW, lableTwoH);
        
        UILabel *lableTwo      = [[UILabel alloc] init];
        lableTwo.frame         = lableTwoF;
        lableTwo.textAlignment = NSTextAlignmentLeft;
        lableTwo.font          = [UIFont systemFontOfSize:14];
        lableTwo.textColor     = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        [self addSubview:lableTwo];
        self.lableTwo = lableTwo;
        
        //属性名称lable--状态
        CGFloat lableThrX = CGRectGetMaxX(self.lableTwo.frame) +5;
        CGFloat lableThrY = CGRectGetMinY(self.lableTwo.frame);
        CGFloat lableThrW = 80;
        CGFloat lableThrH = CGRectGetHeight(self.lableTwo.frame);
        CGRect  lableThrF = CGRectMake(lableThrX, lableThrY, lableThrW, lableThrH);
        
        UILabel *lableThr      = [[UILabel alloc] init];
        lableThr.frame         = lableThrF;
        lableThr.textAlignment = NSTextAlignmentLeft;
        lableThr.font          = [UIFont systemFontOfSize:14];
        lableThr.textColor     = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        [self addSubview:lableThr];
        self.lableThr = lableThr;
        
        //属性名称lable--开启的事务
        CGFloat lableFouX = CGRectGetMaxX(self.lableThr.frame) +5;
        CGFloat lableFouY = CGRectGetMinY(self.lableThr.frame);
        CGFloat lableFouW = 80;
        CGFloat lableFouH = CGRectGetHeight(self.lableThr.frame);
        CGRect  lableFouF = CGRectMake(lableFouX, lableFouY, lableFouW, lableFouH);
        
        UILabel *lableFou      = [[UILabel alloc] init];
        lableFou.frame         = lableFouF;
        lableFou.textAlignment = NSTextAlignmentLeft;
        lableFou.font          = [UIFont systemFontOfSize:14];
        lableFou.textColor     = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        [self addSubview:lableFou];
        self.lableFou = lableFou;
    }
    
    return self;
}

+ (instancetype)DataBackupHeaderStyleTwo
{
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, TableViewHeaderHeight);
    
    LQDataBackupHeaderStyleTwo *style = [[LQDataBackupHeaderStyleTwo alloc] initWithFrame:frame];
    
    return style;
}

- (void)setTitleNames:(NSArray *)titleNames
{
    _titleNames = titleNames;
    
    self.lableOne.text = titleNames[0];
    self.lableTwo.text = titleNames[1];
    self.lableThr.text = titleNames[2];
    self.lableFou.text = titleNames[3];
}

@end
