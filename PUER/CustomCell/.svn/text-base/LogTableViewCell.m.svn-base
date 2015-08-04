//
//  LogTableViewCell.m
//  GOBO
//
//  Created by admin on 14/12/4.
//  Copyright (c) 2014年 蝶尚软件. All rights reserved.
//

#import "LogTableViewCell.h"

@implementation LogTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.IDLable.frame         = CGRectMake(6, 10, 24, 15);
    self.categoryImageView.frame = CGRectMake(self.IDLable.frame.origin.x+self.IDLable.frame.size.width+5, self.IDLable.frame.origin.y, 15, self.IDLable.frame.size.height);
    self.categoryLable.frame     = CGRectMake(self.categoryImageView.frame.origin.x+self.categoryImageView.frame.size.width+5, self.categoryImageView.frame.origin.y, 150, self.IDLable.frame.size.height);
    self.timeLable.frame         = CGRectMake(SCREEN_WIDTH-60-10, self.categoryLable.frame.origin.y, 60, self.IDLable.frame.size.height);
    self.contentLable.frame     = CGRectMake(self.categoryImageView.frame.origin.x, self.categoryImageView.frame.origin.y+self.categoryImageView.frame.size.height, SCREEN_WIDTH-self.categoryImageView.frame.origin.x-10, 10);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//设置lable 的高度
- (void)setContentTextViewHeight:(NSString *)string
{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont fontWithName:TextFont_name size:13]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(self.contentLable.frame.size.width, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    self.contentLable.frame = CGRectMake(self.contentLable.frame.origin.x, self.contentLable.frame.origin.y, self.contentLable.frame.size.width, size.height+5);
}

//设置控件的属性
- (void)setViewAttribute:(NSString *)stype
{
    if ([stype isEqualToString:@"error"]) {
        
        self.categoryLable.text      = @"错误";
        self.categoryImageView.image = [UIImage imageNamed:@"error"];
        self.categoryLable.textColor = [UIColor colorWithRed:231/255. green:76/255. blue:60/255. alpha:1.];
        self.IDLable.textColor       = self.categoryLable.textColor;
        self.timeLable.textColor     = self.categoryLable.textColor;
        
        
    }else if ([stype isEqualToString:@"warn"]) {
        
        self.categoryLable.text      = @"警告";
        self.categoryImageView.image = [UIImage imageNamed:@"warn"];
        self.categoryLable.textColor = [UIColor colorWithRed:243/255. green:156/255. blue:18/255. alpha:1.];
        self.IDLable.textColor       = self.categoryLable.textColor;
        self.timeLable.textColor     = self.categoryLable.textColor;
        
    }else if ([stype isEqualToString:@"info"]) {
        
        self.categoryLable.text      = @"信息";
        self.categoryImageView.image = [UIImage imageNamed:@"info"];
        self.categoryLable.textColor = [UIColor blackColor];
        self.IDLable.textColor       = self.categoryLable.textColor;
        self.timeLable.textColor     = self.categoryLable.textColor;
        
    }
}

+ (CGFloat)calculateHeight:(NSString *)string
{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont fontWithName:TextFont_name size:13]};
    CGSize size = [string boundingRectWithSize:CGSizeMake((SCREEN_WIDTH-35*Proportion_width)-10, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size.height+40;
}

@end
