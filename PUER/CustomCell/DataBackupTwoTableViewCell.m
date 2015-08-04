//
//  DataBackupTwoTableViewCell.m
//  PUER
//
//  Created by admin on 14/10/24.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "DataBackupTwoTableViewCell.h"

@implementation DataBackupTwoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _actualContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        self.actualContentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.actualContentView];
        
        //背景view下的细线
        UIView *lineView       = [[UIView alloc] init];
        lineView.frame         = CGRectMake(0, 44.5, SCREEN_WIDTH, 0.5);
        lineView.backgroundColor = [UIColor grayColor];
        lineView.alpha           = 0.6;
        [self.actualContentView addSubview:lineView];
        
        //ID
        _IDLable = [[UILabel alloc] init];
        self.IDLable.frame    = CGRectMake(6, 15, 24, 16);
        self.IDLable.textColor = [UIColor blackColor];
        self.IDLable.textAlignment = NSTextAlignmentCenter;
        self.IDLable.font          = [UIFont systemFontOfSize:15];
        
        //名称
        _nameLable      = [[UILabel alloc] init];
        self.nameLable.frame         = CGRectMake(self.IDLable.frame.origin.x+self.IDLable.frame.size.width+5, self.IDLable.frame.origin.y, 145, self.IDLable.frame.size.height);
        self.nameLable.textColor     = [UIColor blackColor];
        self.nameLable.textAlignment = NSTextAlignmentLeft;
        self.nameLable.font          = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        
        //备份路径
        _backupPathLable = [[UILabel alloc] init];
        self.backupPathLable.frame    = CGRectMake(self.nameLable.frame.origin.x+self.nameLable.frame.size.width+5, self.nameLable.frame.origin.y, SCREEN_WIDTH-(self.nameLable.frame.origin.x+self.nameLable.frame.size.width+5)-25, self.nameLable.frame.size.height);
        self.backupPathLable.textColor     = [UIColor blackColor];
        self.backupPathLable.textAlignment = NSTextAlignmentLeft;
        self.backupPathLable.font          = [UIFont systemFontOfSize:14];
        
        //等待指示器
        _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        [self.activity setCenter:CGPointMake(SCREEN_WIDTH-20, 45/2)];//指定进度轮中心点
        [self.activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
        //        self.webActivity.backgroundColor = [UIColor grayColor];
        [self.activity stopAnimating];
        self.activity.hidden = YES;
        
        //用于遮盖view
        _coverView                     = [[UIView alloc] init];
        self.coverView.frame           = CGRectMake(0, 0, self.actualContentView.frame.size.width, self.actualContentView.frame.size.height);
        self.coverView.backgroundColor = [UIColor whiteColor];
        self.coverView.alpha           = 0.0;
        
        //将控件添加到cell上
        [self.actualContentView addSubview:self.IDLable];
        [self.actualContentView addSubview:self.nameLable];
        [self.actualContentView addSubview:self.backupPathLable];
        [self.actualContentView addSubview:self.activity];
        [self.actualContentView addSubview:self.coverView];
        
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
