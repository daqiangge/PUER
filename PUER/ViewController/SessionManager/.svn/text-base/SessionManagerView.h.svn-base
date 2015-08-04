//
//  SessionManagerView.h
//  PUER
//
//  Created by admin on 14-9-5.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SessionManagerView;

@protocol SessionManagerViewDelegate <NSObject>

- (UIView *)overlayView:(SessionManagerView *)view didHitTest:(CGPoint)point withEvent:(UIEvent *)event;

@end

@interface SessionManagerView : UIView

@property (weak, nonatomic) id<SessionManagerViewDelegate> delegate;

@end
