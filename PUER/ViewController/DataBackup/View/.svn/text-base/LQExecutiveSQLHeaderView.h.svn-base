//
//  LQExecutiveSQLHeaderView.h
//  PUER
//
//  Created by admin on 15/6/4.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LQExecutiveSQLHeaderView;

@protocol  LQExecutiveSQLHeaderViewDelegate<NSObject>

- (void)executiveSQLHeaderViewDidExecutive:(LQExecutiveSQLHeaderView *)executiveSQLHeaderView;
- (void)executiveSQLHeaderViewDidPullDown:(LQExecutiveSQLHeaderView *)executiveSQLHeaderView;
- (void)executiveSQLHeaderViewDidLock:(LQExecutiveSQLHeaderView *)executiveSQLHeaderView;

@end

@interface LQExecutiveSQLHeaderView : UIView

@property (nonatomic, weak) id<LQExecutiveSQLHeaderViewDelegate> delegate;

@property (nonatomic, weak) UIButton *pullDownBtn;

+ (instancetype)executiveSQLHeaderView;

@end
