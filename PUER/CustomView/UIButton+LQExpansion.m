//
//  UIButton+LQExpansion.m
//  GOBO
//
//  Created by admin on 15/3/4.
//  Copyright (c) 2015年 蝶尚软件. All rights reserved.
//

#import "UIButton+LQExpansion.h"

@implementation UIButton (LQExpansion)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    CGRect rect = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self setBackgroundImage:image forState:state];
    
}
//
//- (UIImage *)roundCornersOfImage:(UIImage *)source;
//{
//    int w = source.size.width;
//    int h = source.size.height;
//    
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace,(CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
//    
//    CGContextBeginPath(context);
//    CGRect rect = CGRectMake(0, 0, w, h);
//    [self addRoundedRectToPath:context :rect :2 :2];
//    CGContextClosePath(context);
//    CGContextClip(context);
//    
//    CGContextDrawImage(context, CGRectMake(0, 0, w, h), source.CGImage);
//    
//    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//    
//    return [UIImage imageWithCGImage:imageMasked];
//}
//
//-(void) addRoundedRectToPath:(CGContextRef) context : (CGRect) rect : (float) ovalWidth : (float) ovalHeight{
//    float fw, fh;
//    if (ovalWidth == 0 || ovalHeight == 0) {
//        CGContextAddRect(context, rect);
//        return;
//    }
//    CGContextSaveGState(context);
//    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
//    CGContextScaleCTM (context, ovalWidth, ovalHeight);
//    fw = CGRectGetWidth (rect) / ovalWidth;
//    fh = CGRectGetHeight (rect) / ovalHeight;
//    CGContextMoveToPoint(context, fw, fh/2);
//    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
//    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
//    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
//    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
//    CGContextClosePath(context);
//    CGContextRestoreGState(context);
//}

@end
