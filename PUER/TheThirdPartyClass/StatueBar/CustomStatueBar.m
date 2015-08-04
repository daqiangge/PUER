//
//  CustomStatueBar.m
//  CustomStatueBar
//
//  Created by 贺 坤 on 12-5-21.
//  Copyright (c) 2012年 深圳市瑞盈塞富科技有限公司. All rights reserved.
//

#import "CustomStatueBar.h"

@implementation CustomStatueBar

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelNormal;
        self.windowLevel = UIWindowLevelStatusBar + 1.0f;
		self.frame = CGRectMake(SCREEN_WIDTH, 0, 110, 20);
        self.backgroundColor = [UIColor colorWithRed:47/255. green:110/255. blue:145/255. alpha:1];
        self.layer.cornerRadius = 10;
        
//        defaultLabel = [[BBCyclingLabel alloc]initWithFrame:[UIApplication sharedApplication].statusBarFrame andTransitionType:BBCyclingLabelTransitionEffectScrollUp];
//        defaultLabel.backgroundColor = [UIColor clearColor];
//        defaultLabel.textColor = [UIColor whiteColor];
//        defaultLabel.font = [UIFont systemFontOfSize:10.0f];
//        defaultLabel.textAlignment = UITextAlignmentCenter;
//        [self addSubview:defaultLabel];
//        [defaultLabel setText:@"default label text" animated:NO];
//        defaultLabel.transitionDuration = 0.75;
//        defaultLabel.shadowOffset = CGSizeMake(0, 1);
//        defaultLabel.font = [UIFont systemFontOfSize:15];
//        defaultLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1];
//        defaultLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.75];
//        defaultLabel.clipsToBounds = YES;
        
        isFull = NO;
        
        _msgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_msgButton setFrame:CGRectMake(10, 0, 90, 20)];
        [_msgButton setTitle:@"" forState:UIControlStateNormal];
        _msgButton.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
        _msgButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _msgButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_msgButton setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_msgButton];
        
    }
    return self;
}

- (void)showStatusBar
{
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:1.0f];
    self.frame = CGRectMake(SCREEN_WIDTH-100, 0,110, 20);
    [UIView commitAnimations];
}

- (void)closeStatusBar
{
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.5f];
    self.frame = CGRectMake(SCREEN_WIDTH, 0,110, 20);
    [UIView commitAnimations];

}

- (void)showStatusMessage:(NSString *)message{
    self.hidden = NO;
    self.alpha = 1.0f;
    [defaultLabel setText:@"new message" animated:NO];
    
    CGSize totalSize = self.frame.size;
    self.frame = (CGRect){ self.frame.origin, 0, totalSize.height };
    
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = (CGRect){ self.frame.origin, totalSize };
    } completion:^(BOOL finished){
        defaultLabel.text = message;
    }];
}
- (void)hide{
    self.alpha = 1.0f;
    
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished){
        defaultLabel.text = @"";
        self.hidden = YES;
    }];;

}
- (void)changeMessge:(NSString *)message{
    [defaultLabel setText:message animated:YES];
}
@end
