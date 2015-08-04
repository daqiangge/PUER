//
//  FilterView.m
//  PUER
//
//  Created by admin on 14/12/23.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "FilterView.h"

@implementation FilterView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return [self.delegate overlayView:self didHitTest:point withEvent:event];
}

@end
