//
//  SessionManagerViewController.h
//  PUER
//
//  Created by admin on 14-8-14.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionManagerTableViewCell.h"
#import "SessionManagerTableViewController.h"

@interface SessionManagerViewController : SessionManagerTableViewController<UIAlertViewDelegate>

@property (nonatomic,retain) NSMutableArray *sessionManagerArray;
@property (nonatomic,retain) NSMutableArray *searchSessionManagerArray;
@property BOOL judgeBack;//判断是否以执行反悔按钮操作
@property BOOL headerRefreshing;//记录当前是否处于刷新状态，如果为刷新状态则无法打开搜索
@property BOOL pageend;//记录上拉加载返回数据是否为最后一夜
@property int fromID;//记录下一次加载数据时传入的Pagenumber

@property BOOL endSearch;//判断是否结束搜索

@property BOOL searchPageend;//记录上拉加载搜索界面的返回数据是否为最后一夜
@property int searchFromID;//记录搜索界面下一次加载数据时传入的Pagenumber

@property (nonatomic,retain) UIButton *menuButton;

@property int ID;//用来记录所点击的按钮的当前行的ID
@property (nonatomic,retain) NSString *sessionid;//用来记录所点击的按钮的当前行的sid
@property (nonatomic,retain) NSString *projectName;//用来记录所点击的按钮的当前行的projectName


@end
