//
//  UITableView+LQExpansion.m
//  PUER
//
//  Created by admin on 15/3/18.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "UITableView+LQExpansion.h"

@implementation UITableView (LQExpansion)

/**
 *  设置分割线处事位置为0
 */
- (void)hideSeparatorLeftInset
{
    if ([self respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
