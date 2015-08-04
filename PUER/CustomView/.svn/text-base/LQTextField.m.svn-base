//
//  LQTextField.m
//  GOBO
//
//  Created by admin on 14/11/12.
//  Copyright (c) 2014年 蝶尚软件. All rights reserved.
//

#import "LQTextField.h"

@implementation LQTextField


- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x+5, bounds.origin.y, bounds.size.width-5,bounds.size.height );
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x+5, bounds.origin.y, bounds.size.width-5,bounds.size.height );
}

//禁止输入框粘贴
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return YES;
}

@end
