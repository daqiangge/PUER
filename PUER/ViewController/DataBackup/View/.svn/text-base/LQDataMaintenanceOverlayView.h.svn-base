//
//  LQDataMaintenanceOverlayView.h
//  PUER
//
//  Created by admin on 15/6/2.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LQDataMaintenanceOverlayView;

@protocol LQDataMaintenanceOverlayViewDelegate <NSObject>

- (UIView *)overlayView:(LQDataMaintenanceOverlayView *)view didHitTest:(CGPoint)point withEvent:(UIEvent *)event;

@end

@interface LQDataMaintenanceOverlayView : UIView

@property (nonatomic, weak) id<LQDataMaintenanceOverlayViewDelegate> delegate;

@end
