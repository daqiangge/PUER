//
//  LableAndLableTableViewCell.m
//  PUER
//
//  Created by admin on 14/12/18.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "LableAndLableTableViewCell.h"

@implementation LableAndLableTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNameLableFrameAndContentFrame:(CGRect)NameLableFrame
{
    _nameLable.frame = NameLableFrame;
    _contentLable.frame = CGRectMake(_nameLable.frame.origin.x+_nameLable.frame.size.width+14, 7.5, SCREEN_WIDTH-(_nameLable.frame.origin.x+_nameLable.frame.size.width+10+10), TextField_height);
}

@end
