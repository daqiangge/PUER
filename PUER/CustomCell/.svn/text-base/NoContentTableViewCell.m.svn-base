//
//  NoContentTableViewCell.m
//  PUER
//
//  Created by admin on 14-10-17.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

//---------------------------显示没有内容--------------------------

#import "NoContentTableViewCell.h"

@implementation NoContentTableViewCell

+ (NoContentTableViewCell *)noContentTableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *idenifier = @"NoContentTableViewCell";
    NoContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    if (cell == nil) {
        cell = [[NoContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.showLable.text = @"无内容";
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor whiteColor];
        
        _showLable          = [[UILabel alloc] init];
        _showLable.frame             = CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height);
        _showLable.alpha             = 0.5;
        _showLable.font              = [UIFont systemFontOfSize:17];
        _showLable.textAlignment     = NSTextAlignmentCenter;
        
        [self addSubview:_showLable];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
