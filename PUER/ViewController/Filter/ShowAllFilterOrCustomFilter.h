//
//  ShowAllFilterOrCustomFilter.h
//  PUER
//
//  Created by admin on 14/12/30.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowAllFilterOrCustomFilter : NSObject

@property BOOL showAllFilter;

+ (ShowAllFilterOrCustomFilter *)shareInstance;//实例化--单例模式

- (void)setShowAllFilter:(BOOL)showAllFilter;

@end
