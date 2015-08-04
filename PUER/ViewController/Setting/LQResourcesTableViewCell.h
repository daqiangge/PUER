//
//  LQResourcesTableViewCell.h
//  PUER
//
//  Created by admin on 15/3/24.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LQResourcesFolder;
@class LQResourcesFile;


@interface LQResourcesTableViewCell : UITableViewCell

@property (nonatomic, strong) LQResourcesFolder *resourcesFolder;
@property (nonatomic, strong) LQResourcesFile *resourcesFile;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
