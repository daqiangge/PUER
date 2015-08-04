//
//  AlterDataLinkTableViewCell.h
//  PUER
//
//  Created by admin on 14-10-9.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlterDataLinkTableViewCell : UITableViewCell

@property (nonatomic,strong)  UIView *souceView;//总容器
@property (nonatomic,retain)  UILabel *Lable;
@property (nonatomic,retain)  UIView *bgView;
@property (nonatomic,retain)  UITextField *textField;
@property (nonatomic,retain)  UIButton *button;//弹出下拉选项框
@property (nonatomic,retain)  UITextView  *textView;//连接描述

@end
