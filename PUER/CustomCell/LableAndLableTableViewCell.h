//
//  LableAndLableTableViewCell.h
//  PUER
//
//  Created by admin on 14/12/18.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LableAndLableTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;

- (void)setNameLableFrameAndContentFrame:(CGRect)NameLableFrame;
@end
