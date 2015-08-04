//
//  LQNullDataTableViewCell.m
//  PUER
//
//  Created by admin on 15/3/25.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "LQNullDataTableViewCell.h"

@implementation LQNullDataTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *idenifier = @"nullDataCell";
    [tableView registerNib:[UINib nibWithNibName:@"LQNullDataTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:idenifier];
    LQNullDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    
    return cell;
}

@end
