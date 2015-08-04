//
//  LQDataBackupHeaderStyleOne.m
//  PUER
//
//  Created by admin on 15/6/2.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "LQDataBackupHeaderStyleOne.h"

@interface LQDataBackupHeaderStyleOne()

@property (nonatomic, weak) UILabel *lableOne;
@property (nonatomic, weak) UILabel *lableTwo;
@property (nonatomic, weak) UILabel *lableThr;

@end

@implementation LQDataBackupHeaderStyleOne

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
        
        //属性名称lable--名称
        UILabel *lableTwo      = [[UILabel alloc] init];
        lableTwo.frame         = CGRectMake(lableOne.frame.origin.x+lableOne.frame.size.width+5, 0, 100, TableViewHeaderHeight);
        lableTwo.textAlignment = NSTextAlignmentLeft;
        lableTwo.font          = [UIFont systemFontOfSize:14];
        lableTwo.textColor     = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        [self addSubview:lableTwo];
        self.lableTwo = lableTwo;
        
        //属性名称lable--备份路径
        UILabel *lableThr      = [[UILabel alloc] init];
        lableThr.frame         = CGRectMake(lableTwo.frame.origin.x+lableTwo.frame.size.width+50, 0, 100, TableViewHeaderHeight);
        lableThr.textAlignment = NSTextAlignmentLeft;
        lableThr.font          = [UIFont systemFontOfSize:14];
        lableThr.textColor     = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        [self addSubview:lableThr];
        self.lableThr = lableThr;

    }
    
    return self;
}

+ (instancetype)dataBackupHeaderStyleOne
{
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, TableViewHeaderHeight);
    
    LQDataBackupHeaderStyleOne *stytle = [[LQDataBackupHeaderStyleOne alloc] initWithFrame:frame];
    
    return stytle;
}

- (void)setTitleNames:(NSArray *)titleNames
{
    _titleNames = titleNames;
    
    self.lableOne.text = titleNames[0];
    self.lableTwo.text = titleNames[1];
    self.lableThr.text = titleNames[2];
}

@end
