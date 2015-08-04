//
//  AlterSessionManagerViewController.h
//  PUER
//
//  Created by admin on 14-9-11.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlterSessionManagerViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) UITableView *alterSessionManagerTableView;
@property (nonatomic,retain) NSMutableDictionary *alterSessionManagerDic;
@property BOOL judgeBack;//判断是否以执行反悔按钮操作

@end
