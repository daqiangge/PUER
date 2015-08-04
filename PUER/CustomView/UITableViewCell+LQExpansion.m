//
//  UITableViewCell+LQExpansion.m
//  PUER
//
//  Created by admin on 15/3/18.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "UITableViewCell+LQExpansion.h"

@implementation UITableViewCell (LQExpansion)

/**
 *  设置分割线初始位置为0
 */
- (void)hideSeparatorLeftInset
{
    if ([self respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
