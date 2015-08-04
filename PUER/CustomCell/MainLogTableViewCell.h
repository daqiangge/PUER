//
//  MainLogTableViewCell.h
//  PUER
//
//  Created by admin on 14/12/15.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainLogTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;


+ (CGFloat)calculateHeight:(NSString *)string;
- (void)setContentLableHeight:(NSString *)string;

@end
