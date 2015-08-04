//
//  PlanFragmentView.h
//  PUER
//
//  Created by admin on 14-9-12.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PlanFragmentView;

@protocol PlanFragmentViewDelegate <NSObject>

- (UIView *)overlayView:(PlanFragmentView *)view didHitTest:(CGPoint)point withEvent:(UIEvent *)event;

@end

@interface PlanFragmentView : UIView

@property (weak, nonatomic) id<PlanFragmentViewDelegate> delegate;

@end
