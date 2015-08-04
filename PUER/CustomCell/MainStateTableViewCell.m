//
//  MainStateTableViewCell.m
//  PUER
//
//  Created by admin on 14/12/15.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "MainStateTableViewCell.h"

@implementation MainStateTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.nameLable.frame = CGRectMake(10*Proportion_width, 0, 100*Proportion_width, 30*Proportion_height);
    self.nameLable.font  = [UIFont fontWithName:TextFont_name size:13*Proportion_text];
    
    self.contentLable.frame = CGRectMake(self.nameLable.frame.origin.x+self.nameLable.frame.size.width, self.nameLable.frame.origin.y, 190*Proportion_width, self.nameLable.frame.size.height);
    self.contentLable.font  = self.nameLable.font;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
