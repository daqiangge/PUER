//
//  MainViewController.h
//  PUER
//
//  Created by admin on 14-8-14.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : BaseViewController<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIWebViewDelegate,UIAlertViewDelegate>

@property (nonatomic,retain) UIScrollView *scrollView;//网页背景的scrollview
@property (nonatomic,retain) UIActivityIndicatorView *webActivityOne;//网页的加载等待指示器
@property (nonatomic,retain) UIActivityIndicatorView *webActivityTwo;//网页的加载等待指示器
@property (nonatomic,retain) UIButton *stateButton;//运行状态按钮
@property (nonatomic,retain) UIButton *logButton;//日志按钮
@property (nonatomic,retain) UITableView *stateTableView;//运行状态列表
@property (nonatomic,retain) UITableView *logTableView;//日志列表
@property (nonatomic,retain) UIView *lineViewOne;
@property (nonatomic,retain) UIView *lineViewTwo;
@property (nonatomic,retain) NSMutableDictionary *stateDic;
@property (nonatomic,retain) NSMutableArray *logArray;
@property BOOL judgeBack;//判断是否以执行返回按钮操作

@property (nonatomic,retain) UIWebView *memoryWebview;
@property (nonatomic,retain) UIWebView *CPUWebVIew;

-(void)reloadTableViewDataSource;
-(void)doneLoadingTableViewData;

@end
