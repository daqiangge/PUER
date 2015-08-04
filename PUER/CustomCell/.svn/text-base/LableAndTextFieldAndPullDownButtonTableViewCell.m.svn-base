//
//  LableAndTextFieldAndPullDownButtonTableViewCell.m
//  GOBO
//
//  Created by admin on 14/11/27.
//  Copyright (c) 2014年 蝶尚软件. All rights reserved.
//

#import "LableAndTextFieldAndPullDownButtonTableViewCell.h"

@implementation LableAndTextFieldAndPullDownButtonTableViewCell

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
    _contentBackgroundView.frame = CGRectMake(_nameLable.frame.origin.x+_nameLable.frame.size.width+10, 7.5, SCREEN_WIDTH-(_nameLable.frame.origin.x+_nameLable.frame.size.width+10+10), TextField_height);
    _contentTextField.frame = CGRectMake(0, 0, _contentBackgroundView.frame.size.width-TextField_height, TextField_height);
    _pullDownButton.frame = CGRectMake(_contentTextField.frame.size.width,0, TextField_height,TextField_height);
    
    _contentBackgroundView.backgroundColor = TextField_backgroundCollor;
    
    _contentBackgroundView.layer.borderColor  = TextField_layer_borderColor;
    _contentBackgroundView.layer.borderWidth  = TextField_layer_borderWidth;
    _contentBackgroundView.layer.cornerRadius = TextField_layer_cornerRadius;
    _pullDownButton.layer.cornerRadius      = TextField_layer_cornerRadius;
    _pullDownButton.layer.borderWidth       = TextField_layer_borderWidth;
    _pullDownButton.layer.borderColor       = TextField_layer_borderColor;
}

@end
