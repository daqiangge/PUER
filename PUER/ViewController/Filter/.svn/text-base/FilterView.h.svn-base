//
//  FilterView.h
//  PUER
//
//  Created by admin on 14/12/23.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterView;

@protocol FilterViewDelegate <NSObject>

- (UIView *)overlayView:(FilterView *)view didHitTest:(CGPoint)point withEvent:(UIEvent *)event;

@end

@interface FilterView : UIView

@property (weak, nonatomic) id<FilterViewDelegate> delegate;

@end
