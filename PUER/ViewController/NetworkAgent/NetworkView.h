//
//  NetworkView.h
//  PUER
//
//  Created by admin on 14-9-3.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NetworkView;

@protocol NetworkViewDelegate <NSObject>

- (UIView *)overlayView:(NetworkView *)view didHitTest:(CGPoint)point withEvent:(UIEvent *)event;

@end

@interface NetworkView : UIView

@property (weak, nonatomic) id<NetworkViewDelegate> delegate;

@end
