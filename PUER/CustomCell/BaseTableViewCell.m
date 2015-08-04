//
//  BaseTableViewCell.m
//  PUER
//
//  Created by admin on 14-9-1.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor whiteColor];
        
        _Lable              = [[UILabel alloc] init];
        self.Lable.frame    = CGRectMake(10, 7.5, 90, 33);
        self.Lable.font     = [UIFont systemFontOfSize:15];
        
        _bgView        = [[UIView alloc] init];
        self.bgView.frame          = CGRectMake(100,self.Lable.frame.origin.y, SCREEN_WIDTH-110, self.Lable.frame.size.height);
        self.bgView.backgroundColor = TextField_backgroundCollor;
        self.bgView.layer.cornerRadius = 2;//画圆角2度
        self.bgView.layer.borderColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1].CGColor;//设置划线颜色
        self.bgView.layer.borderWidth=0.5;//设置划线粗细
        self.bgView.hidden = NO;
        
        _textField                  = [[UITextField alloc] init];
        self.textField.frame        = CGRectMake(5, 0, self.bgView.frame.size.width-5, self.bgView.frame.size.height);
        self.textField.font         = [UIFont systemFontOfSize:15];
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        
        [self addSubview:self.Lable];
        [self addSubview:self.bgView];
        [_bgView addSubview:self.textField];

    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
