//
//  BaseViewController.h
//  PUER
//
//  Created by admin on 14-8-13.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic,retain) UIButton *menuButton;
@property (nonatomic,retain) UIAlertView *loginAgain_AlterView;//重新登陆提示框
@property (nonatomic,retain) UIAlertView *requestError_AlterView;//请求发生错位的提示框
@property (nonatomic,retain) UILabel *titleLable;

- (void)setNavTitle:(NSString *)navigationTitle;
- (void)menuButton:(NSString *)navigationTitle;
- (void)navTitle;
- (BOOL)isConnectionAvailable;
- (NSString *)ASCIIString:(NSString *)unicodeStr;
- (void)sessionToRemove:(NSString *)code info:(NSString *)info;
- (void)setDataBackVCTitile:(NSString *)mainTitle viceTitle:(NSString *)viceTitle;

@end
