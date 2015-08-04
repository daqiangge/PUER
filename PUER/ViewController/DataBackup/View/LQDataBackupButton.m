//
//  LQDataBackupButton.m
//  PUER
//
//  Created by admin on 15/6/1.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "LQDataBackupButton.h"

@implementation LQDataBackupButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    }
    
    return self;
}

+ (instancetype)dataBackupButtonWithFrame:(CGRect)frame
{
    LQDataBackupButton *button = [[LQDataBackupButton alloc] initWithFrame:frame];
    
    return button;
}

@end
