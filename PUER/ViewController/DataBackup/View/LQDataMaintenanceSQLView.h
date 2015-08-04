//
//  LQDataMaintenanceSQLView.h
//  PUER
//
//  Created by admin on 15/6/11.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQExecutiveSQLHeaderView.h"

@class LQDataMaintenanceSQLView;
@protocol LQDataMaintenanceSQLViewDelegate <NSObject>

- (void)dataMaintenanceSQLViewGetCommonSqlTextWithIndexPath:(NSIndexPath *)indexPath sqlView:(LQDataMaintenanceSQLView *)sqlView;

@end


@interface LQDataMaintenanceSQLView : UIView

@property (nonatomic, weak) id<LQDataMaintenanceSQLViewDelegate> delegate;
@property (nonatomic, strong) LQExecutiveSQLHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, weak) UITableView *pulldownTableView;
@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) UIWebView *webview;

+ (instancetype)dataMaintenanceSQLView;
- (void)tap;

@end
