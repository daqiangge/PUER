//
//  DataBackupView.h
//  PUER
//
//  Created by admin on 14-9-12.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DataBackupView;

@protocol DataBackupViewDelegate <NSObject>

- (UIView *)overlayView:(DataBackupView *)view didHitTest:(CGPoint)point withEvent:(UIEvent *)event;

@end


@interface DataBackupView : UIView

@property (weak, nonatomic) id<DataBackupViewDelegate> delegate;

@end
