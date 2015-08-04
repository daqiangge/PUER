//
//  LQResourcesTableViewCell.m
//  PUER
//
//  Created by admin on 15/3/24.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "LQResourcesTableViewCell.h"
#import "LQResourcesFile.h"
#import "LQResourcesFolder.h"

@interface LQResourcesTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *resourcesImageView;
@property (weak, nonatomic) IBOutlet UIView *fileBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *folderBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLable;
@property (weak, nonatomic) IBOutlet UILabel *fileTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *fileSizeLable;
@property (weak, nonatomic) IBOutlet UILabel *fileVersionLable;
@property (weak, nonatomic) IBOutlet UILabel *folderNameLable;

@end

@implementation LQResourcesTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *indenifier = @"resourcesCell";
    [tableView registerNib:[UINib nibWithNibName:@"LQResourcesTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:indenifier];
    LQResourcesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indenifier];
    
    return cell;
}

- (void)setResourcesFile:(LQResourcesFile *)resourcesFile
{
    _resourcesFile = resourcesFile;
    
    //判断摸个字符串是否以某个字符串结尾
    if ([resourcesFile.type isEqualToString:@".prs"] || [resourcesFile.type isEqualToString:@".prss"])
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    
    self.folderBackgroundView.hidden = YES;
    self.fileBackgroundView.hidden = NO;
    
    self.resourcesImageView.image = [UIImage imageNamed:@"file"];
    self.fileNameLable.text = resourcesFile.name;
    self.fileSizeLable.text = resourcesFile.size;
    self.fileTimeLable.text = resourcesFile.lastchgtime;
    self.fileVersionLable.text = resourcesFile.version;
}

- (void)setResourcesFolder:(LQResourcesFolder *)resourcesFolder
{
    _resourcesFolder = resourcesFolder;
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.folderBackgroundView.hidden = NO;
    self.fileBackgroundView.hidden = YES;
    
    self.resourcesImageView.image = [UIImage imageNamed:@"folder"];
    self.folderNameLable.text = resourcesFolder.name;

}

@end
