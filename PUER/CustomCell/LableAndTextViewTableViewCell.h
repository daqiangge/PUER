//
//  LableAndTextViewTableViewCell.h
//  GOBO
//
//  Created by admin on 14/11/27.
//  Copyright (c) 2014年 蝶尚软件. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LableAndTextViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

- (void)setNameLableFrameAndContentFrame:(CGRect)NameLableFrame;

@end
