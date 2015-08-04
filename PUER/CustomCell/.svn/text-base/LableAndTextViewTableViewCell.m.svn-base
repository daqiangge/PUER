//
//  LableAndTextViewTableViewCell.m
//  GOBO
//
//  Created by admin on 14/11/27.
//  Copyright (c) 2014年 蝶尚软件. All rights reserved.
//

#import "LableAndTextViewTableViewCell.h"

@implementation LableAndTextViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _nameLable.frame = CGRectMake(10, 0, 80, 50);
    _contentTextView.frame = CGRectMake(_nameLable.frame.origin.x+_nameLable.frame.size.width+10, 7.5, SCREEN_WIDTH- (_nameLable.frame.origin.x+_nameLable.frame.size.width+10+10), 100-15);
    
    _contentTextView.layer.borderColor  = TextField_layer_borderColor;
    _contentTextView.layer.borderWidth  = TextField_layer_borderWidth;
    _contentTextView.layer.cornerRadius = TextField_layer_cornerRadius;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNameLableFrameAndContentFrame:(CGRect)NameLableFrame
{
    
    _nameLable.frame = NameLableFrame;
    _contentTextView.frame = CGRectMake(_nameLable.frame.origin.x+_nameLable.frame.size.width+10, 7.5, SCREEN_WIDTH- (_nameLable.frame.origin.x+_nameLable.frame.size.width+10+10), 100-15);
    
    _contentTextView.backgroundColor = TextField_backgroundCollor;
    
    _contentTextView.layer.borderColor  = TextField_layer_borderColor;
    _contentTextView.layer.borderWidth  = TextField_layer_borderWidth;
    _contentTextView.layer.cornerRadius = TextField_layer_cornerRadius;
}

@end
