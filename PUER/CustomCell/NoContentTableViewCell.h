//
//  NoContentTableViewCell.h
//  PUER
//
//  Created by admin on 14-10-17.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoContentTableViewCell : UITableViewCell

@property (nonatomic,retain) UILabel *showLable;//显示“无内容”

+ (NoContentTableViewCell *)noContentTableViewCellWithTableView:(UITableView *)tableView;

@end
