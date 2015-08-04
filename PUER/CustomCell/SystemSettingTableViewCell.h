//
//  SystemSettingTableViewCell.h
//  PUER
//
//  Created by admin on 14-10-9.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemSettingTableViewCell : UITableViewCell

@property (nonatomic,retain) UILabel *Lable;
@property (nonatomic,retain) UIView *bgView;
@property (nonatomic,retain) NoCopyAndPaste_TexrField *textField;
@property (nonatomic,retain) UILabel *contentLable;//此处用于显示服务的端口号

@end
