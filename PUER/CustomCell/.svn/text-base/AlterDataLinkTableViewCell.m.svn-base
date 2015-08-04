//
//  AlterDataLinkTableViewCell.m
//  PUER
//
//  Created by admin on 14-10-9.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "AlterDataLinkTableViewCell.h"

@implementation AlterDataLinkTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code    //总容器
        _souceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _souceView.backgroundColor = [UIColor whiteColor];
        
        _Lable              = [[UILabel alloc] init];
        self.Lable.frame    = CGRectMake(10, 7.5, 90, 33);
        self.Lable.font     = [UIFont systemFontOfSize:15];
        self.Lable.textColor = [UIColor blackColor];
        
        _bgView        = [[UIView alloc] init];
        self.bgView.frame          = CGRectMake(100,self.Lable.frame.origin.y, SCREEN_WIDTH-110, self.Lable.frame.size.height);
        self.bgView.backgroundColor    = TextField_backgroundCollor;
        self.bgView.layer.cornerRadius = 2;//画圆角2度
        self.bgView.layer.borderColor  = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1].CGColor;//设置划线颜色
        self.bgView.layer.borderWidth  = 0.5;//设置划线粗细
        _bgView.hidden                 = NO;
        
        _textField                  = [[UITextField alloc] init];
        self.textField.frame        = CGRectMake(5, 0, self.bgView.frame.size.width-5, self.bgView.frame.size.height);
        self.textField.font         = [UIFont systemFontOfSize:15];
        self.textField.enabled      = YES;
        
        //下拉选项框按钮
        _button           = [[UIButton alloc] init];
        _button.frame     = CGRectMake(210-33, 0, 33, 33);
        [_button setBackgroundImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
        _button.hidden    = YES;
        
        
        //连接描述
        _textView                         = [[UITextView alloc] init];
        self.textView.frame               = CGRectMake(100, 7.5, _souceView.frame.size.width-110, 87.5);
        self.textView.layer.cornerRadius  = 2;//画圆角2度
        self.textView.layer.borderColor   = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1].CGColor;
        self.textView.layer.borderWidth   = 0.5;
        self.textView.font                = self.textField.font;
        self.textView.backgroundColor     = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
        self.textView.hidden              = YES;
        
        [self addSubview:_souceView];
        [_bgView    addSubview:self.textField];
        [_bgView    addSubview:self.button];
        [_souceView addSubview:self.textView];
        [_souceView addSubview:self.Lable];
        [_souceView addSubview:self.bgView];
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
