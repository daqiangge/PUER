//
//  MainLogTableViewCell.m
//  PUER
//
//  Created by admin on 14/12/15.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "MainLogTableViewCell.h"

@implementation MainLogTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _timeLable.frame             = CGRectMake(5, 10, 55*Proportion_width, 15);
    _timeLable.font              = [UIFont fontWithName:TextFont_name size:14];
    _timeLable.textAlignment     = NSTextAlignmentLeft;
    _timeLable.textColor          = [UIColor colorWithRed:231/255.0 green:76/255.0 blue:60/255.0 alpha:1];
    
    _contentLable.frame           = CGRectMake(_timeLable.frame.origin.x+_timeLable.frame.size.width+10, 10,(SCREEN_WIDTH-20)-(_timeLable.frame.origin.x+_timeLable.frame.size.width+10)-5, 10);
    _contentLable.font            = _timeLable.font;
    _contentLable.textColor       = _timeLable.textColor;
    _contentLable.numberOfLines   = 0;
    
    self.layer.cornerRadius   = 2;
    self.layer.borderWidth    = 0.5;
    self.layer.borderColor    = _timeLable.textColor.CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//设置lable 的高度
- (void)setContentLableHeight:(NSString *)string
{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont fontWithName:TextFont_name size:14]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(self.contentLable.frame.size.width, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    self.contentLable.frame = CGRectMake(self.contentLable.frame.origin.x, self.contentLable.frame.origin.y, self.contentLable.frame.size.width, size.height);
}

+ (CGFloat)calculateHeight:(NSString *)string
{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont fontWithName:TextFont_name size:14]};
    CGSize size = [string boundingRectWithSize:CGSizeMake((SCREEN_WIDTH-20)-(5+55*Proportion_width+10)-5, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size.height+10;
}


@end
