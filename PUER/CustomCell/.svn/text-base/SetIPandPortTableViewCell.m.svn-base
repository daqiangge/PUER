//
//  SetIPandPortTableViewCell.m
//  PUER
//
//  Created by admin on 14/12/19.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "SetIPandPortTableViewCell.h"

#define EditButton_frame (CGRectMake(SCREEN_WIDTH-20-50*2+15, 0, 50, 50))

@implementation SetIPandPortTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _IPLable.frame = CGRectMake(10, 0, 200*Proportion_width, 30);
    _nameLable.frame = CGRectMake(_IPLable.frame.origin.x, _IPLable.frame.origin.y+_IPLable.frame.size.height, _IPLable.frame.size.width, 15);
    _editButton.frame = EditButton_frame;
    _deleteButton.frame = CGRectMake(_editButton.frame.origin.x+_editButton.frame.size.width, 0, _editButton.frame.size.width, _editButton.frame.size.height);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
