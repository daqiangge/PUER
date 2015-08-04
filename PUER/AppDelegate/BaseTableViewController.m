//
//  BaseTableViewController.m
//  PUER
//
//  Created by admin on 14-9-23.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "BaseTableViewController.h"

@implementation BaseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

//返回按钮
- (void)setNavTitle:(NSString *)navigationTitle
{
    //标题lable
    _titleLable                 = [[UILabel alloc] init];
    _titleLable.frame           = CGRectMake(0, 0, 100, 44);
    _titleLable.textAlignment   = NSTextAlignmentCenter;
    _titleLable.textColor       = [UIColor whiteColor];
    _titleLable.font            = [UIFont fontWithName:TextFont_name_Bold size:18];
    _titleLable.backgroundColor = [UIColor clearColor];
    _titleLable.text            = navigationTitle;
    
    self.navigationItem.titleView =_titleLable;
    
}

#pragma mark - 字符串转码
- (NSString *)ASCIIString:(NSString *)unicodeStr
{
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"%u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2]stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUnicodeStringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
}

#pragma mark - 设置了tableview的分割线
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
