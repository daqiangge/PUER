//
//  NoCopyAndPaste_TexrField.m
//  PUER
//
//  Created by admin on 14-10-13.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "NoCopyAndPaste_TexrField.h"

@implementation NoCopyAndPaste_TexrField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

//禁止输入框粘贴
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end
