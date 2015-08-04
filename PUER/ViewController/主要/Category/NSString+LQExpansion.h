//
//  NSString+LQExpansion.h
//  PUER
//
//  Created by admin on 15/6/4.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LQExpansion)

- (NSString *)ASCIIString:(NSString *)unicodeStr;
- (CGFloat)calculationHeightWithString:(NSString *)string stringWidth:(CGFloat)width font:(UIFont *)font;

@end
