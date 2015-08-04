//
//  LogTableViewCell.h
//  GOBO
//
//  Created by admin on 14/12/4.
//  Copyright (c) 2014年 蝶尚软件. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *IDLable;//ID号
@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;//类别图标
@property (weak, nonatomic) IBOutlet UILabel *categoryLable;//类别的名称
@property (weak, nonatomic) IBOutlet UILabel *timeLable;//时间
@property (weak, nonatomic) IBOutlet UILabel *contentLable;//内容

//计算高度
+ (CGFloat)calculateHeight:(NSString *)string;
- (void)setContentTextViewHeight:(NSString *)string;
- (void)setViewAttribute:(NSString *)stype;
@end
