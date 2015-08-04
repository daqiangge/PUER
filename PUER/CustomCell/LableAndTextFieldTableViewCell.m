//
//  LableAndTextFieldTableViewCell.m
//  GOBO
//
//  Created by admin on 14/11/27.
//  Copyright (c) 2014年 蝶尚软件. All rights reserved.
//

#import "LableAndTextFieldTableViewCell.h"

@implementation LableAndTextFieldTableViewCell

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
    _contentTextField.frame = CGRectMake(_nameLable.frame.origin.x+_nameLable.frame.size.width+10, 7.5, SCREEN_WIDTH-(_nameLable.frame.origin.x+_nameLable.frame.size.width+10+10), TextField_height);
    
    _contentTextField.backgroundColor = TextField_backgroundCollor;
    
    _contentTextField.layer.borderColor  = TextField_layer_borderColor;
    _contentTextField.layer.borderWidth  = TextField_layer_borderWidth;
    _contentTextField.layer.cornerRadius = TextField_layer_cornerRadius;
}

@end
