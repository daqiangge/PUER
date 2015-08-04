//
//  LogQueryTableViewCell.m
//  PUER
//
//  Created by admin on 14-9-19.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "LogQueryTableViewCell.h"

@implementation LogQueryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self doLoading];
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

- (void)doLoading
{
    //ID号
    _IDLable                   = [[UILabel alloc] init];
    self.IDLable.frame         = CGRectMake(6, 10, 24, 15);
    self.IDLable.font          = [UIFont systemFontOfSize:14];
    self.IDLable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.IDLable];
    
    //类别图标
    _categoryImageView           = [[UIImageView alloc] init];
    self.categoryImageView.frame = CGRectMake(self.IDLable.frame.origin.x+self.IDLable.frame.size.width+5, self.IDLable.frame.origin.y, 15, 15);
    [self addSubview:self.categoryImageView];
    
    //类别名称
    _categoryLable                   = [[UILabel alloc] init];
    self.categoryLable.frame         = CGRectMake(self.categoryImageView.frame.origin.x+self.categoryImageView.frame.size.width+5, self.categoryImageView.frame.origin.y, 150, self.categoryImageView.frame.size.height);
    self.categoryLable.font          = self.IDLable.font;
    self.categoryLable.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.categoryLable];
    
    //时间
    _timeLable                   = [[UILabel alloc] init];
    self.timeLable.frame         = CGRectMake(SCREEN_WIDTH-60-10, self.categoryLable.frame.origin.y, 60, self.IDLable.frame.size.height);
    self.timeLable.font          = self.IDLable.font;
    self.timeLable.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.timeLable];
    
    //内容
    _contentLable                    = [[UILabel alloc] init];
    self.contentLable.frame          = CGRectMake(self.categoryImageView.frame.origin.x, self.categoryImageView.frame.origin.y+self.categoryImageView.frame.size.height+5, SCREEN_WIDTH-self.categoryImageView.frame.origin.x-10, 10);
    self.contentLable.font           = [UIFont fontWithName:@"Helvetica" size:13];
    self.contentLable.textColor      = [UIColor blackColor];
    self.contentLable.numberOfLines  = 0;
    [self addSubview:self.contentLable];
    
   _endLable                        = [[UILabel alloc] init];
    self.endLable.frame             = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, 50);
    self.endLable.alpha             = 0.5;
    self.endLable.font              = [UIFont fontWithName:@"Helvetica" size:17];
    self.endLable.textAlignment     = NSTextAlignmentCenter;
    [self addSubview:self.endLable];
    
}

-(void)setContent:(NSMutableDictionary*)dict
{
    //计算内容的高度
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:13]};
    CGSize size = [[dict objectForKey:@"note"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-self.categoryImageView.frame.origin.x-10, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    if ([[dict objectForKey:@"type"] isEqualToString:@"error"]) {
        
        self.endLable.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, 50);
        self.contentLable.frame               = CGRectMake(self.contentLable.frame.origin.x, self.contentLable.frame.origin.y, SCREEN_WIDTH-self.categoryImageView.frame.origin.x-10, size.height);
        
        self.categoryLable.text      = @"错误";
        self.timeLable.text          = [dict objectForKey:@"time"];
        self.contentLable.text       = [dict objectForKey:@"note"];
        self.categoryImageView.image = [UIImage imageNamed:@"error"];
        self.categoryLable.textColor = [UIColor colorWithRed:231/255. green:76/255. blue:60/255. alpha:1.];
        self.IDLable.textColor       = self.categoryLable.textColor;
        self.timeLable.textColor     = self.categoryLable.textColor;
        
        
    }else if ([[dict objectForKey:@"type"] isEqualToString:@"warn"]) {
        
        self.endLable.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, 50);
        self.contentLable.frame               = CGRectMake(self.contentLable.frame.origin.x, self.contentLable.frame.origin.y, SCREEN_WIDTH-self.categoryImageView.frame.origin.x-10, size.height);
        
        self.categoryLable.text      = @"警告";
        self.timeLable.text          = [dict objectForKey:@"time"];
        self.contentLable.text       = [dict objectForKey:@"note"];
        self.categoryImageView.image = [UIImage imageNamed:@"warn"];
        self.categoryLable.textColor = [UIColor colorWithRed:243/255. green:156/255. blue:18/255. alpha:1.];
        self.IDLable.textColor       = self.categoryLable.textColor;
        self.timeLable.textColor     = self.categoryLable.textColor;
        
    }else if ([[dict objectForKey:@"type"] isEqualToString:@"info"]) {
        
        self.endLable.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, 50);
        self.contentLable.frame               = CGRectMake(self.contentLable.frame.origin.x, self.contentLable.frame.origin.y, SCREEN_WIDTH-self.categoryImageView.frame.origin.x-10, size.height);
        
        self.categoryLable.text      = @"信息";
        self.timeLable.text          = [dict objectForKey:@"time"];
        self.contentLable.text       = [dict objectForKey:@"note"];
        self.categoryImageView.image = [UIImage imageNamed:@"info"];
        self.categoryLable.textColor = [UIColor blackColor];
        self.IDLable.textColor       = self.categoryLable.textColor;
        self.timeLable.textColor     = self.categoryLable.textColor;
        
    }else if ([[dict objectForKey:@"type"] isEqualToString:@"none"]) {
        
        self.endLable.frame          = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        self.endLable.text           = [dict objectForKey:@"endLable"];
        self.categoryLable.text      = @"";
        self.IDLable.text            = @"";
        self.timeLable.text          = [dict objectForKey:@"time"];
        self.contentLable.text       = [dict objectForKey:@"note"];
        self.categoryImageView.image = [UIImage imageNamed:@"imageName"];
    }
    
}

+ (CGFloat)calculateHeight:(NSString *)string
{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:13]};
    CGSize size = [string boundingRectWithSize:CGSizeMake((SCREEN_WIDTH-35)-10, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size.height+30;
}

@end
