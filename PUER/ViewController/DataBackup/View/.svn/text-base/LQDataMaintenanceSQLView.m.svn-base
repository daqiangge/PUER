//
//  LQDataMaintenanceSQLView.m
//  PUER
//
//  Created by admin on 15/6/11.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "LQDataMaintenanceSQLView.h"

@interface LQDataMaintenanceSQLView()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIWebViewDelegate>

@end

@implementation LQDataMaintenanceSQLView

+ (instancetype)dataMaintenanceSQLView
{
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NavgationBarAndStareBar_height);
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.dataArray = [NSMutableArray array];
        
        [self loadingView];
    }
    
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    
    [self.pulldownTableView reloadData];
}

- (void)loadingView
{
    LQExecutiveSQLHeaderView *headerView = [LQExecutiveSQLHeaderView executiveSQLHeaderView];
    [self addSubview:headerView];
    self.headerView = headerView;
    
    //SQL输入框
    CGFloat textViewX = 10;
    CGFloat textViewY = CGRectGetMaxY(headerView.frame)+8;
    CGFloat textViewW = SCREEN_WIDTH - 20;
    CGFloat textViewH = 150;
    CGRect  textViewF  = CGRectMake(textViewX, textViewY, textViewW, textViewH);
    
    UITextView *textView = [[UITextView alloc] init];
    textView.frame = textViewF;
    textView.backgroundColor = HearderViewBackgroundColor;
    textView.font = [UIFont systemFontOfSize:14];
    textView.layer.borderColor  = layer_borderColor;
    textView.layer.borderWidth  = layer_borderWidth;
    textView.layer.cornerRadius = layer_cornerRadius;
    [self addSubview:textView];
    self.textView = textView;
    
    CGFloat pulldownTableViewX = 10;
    CGFloat pulldownTableViewY = CGRectGetMaxY(headerView.frame) +5;
    CGFloat pulldownTableViewW = 200;
    CGFloat pulldownTableViewH = 150;
    CGRect pulldownTableViewF  = CGRectMake(pulldownTableViewX, pulldownTableViewY, pulldownTableViewW, pulldownTableViewH);
    
    UITableView *pulldownTableView = [[UITableView alloc] init];
    pulldownTableView.frame        = pulldownTableViewF;
    pulldownTableView.delegate     = self;
    pulldownTableView.dataSource   = self;
    pulldownTableView.hidden       = YES;
    pulldownTableView.layer.borderColor  = layer_borderColor;
    pulldownTableView.layer.borderWidth  = layer_borderWidth;
    pulldownTableView.layer.cornerRadius = layer_cornerRadius;
    [self addSubview:pulldownTableView];
    self.pulldownTableView = pulldownTableView;
    
    //表格统计图
    CGFloat webviewX = 0;
    CGFloat webviewY = CGRectGetMaxY(self.textView.frame) +5;
    CGFloat webviewW = SCREEN_WIDTH;
    CGFloat webviewH = SCREEN_HEIGHT - webviewY;
    CGRect webviewF = CGRectMake(webviewX, webviewY, webviewW, webviewH);
    
    UIWebView *webview            = [[UIWebView alloc] init];
    webview.frame                 = webviewF;
    webview.layer.borderColor  = layer_borderColor;
    webview.layer.borderWidth  = layer_borderWidth;
    webview.layer.cornerRadius = layer_cornerRadius;
//    webview.scalesPageToFit       = NO;
//    webview.scrollView.bounces    = NO;
    [self addSubview:webview];
    self.webview = webview;
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"indexxx.html" withExtension:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:request];
    
    //点击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [self addGestureRecognizer:tap];

}

/**
 *  webview加载数据
 */
- (void)webViewLoadDataWithDataStr:(NSString *)dataStr
{
    [self.webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"showResult(%@);",dataStr]];
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idenifier = @"executiveCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenifier];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.pulldownTableView.hidden = YES;
    
    if ([self.delegate respondsToSelector:@selector(dataMaintenanceSQLViewGetCommonSqlTextWithIndexPath:sqlView:)]) {
        [self.delegate dataMaintenanceSQLViewGetCommonSqlTextWithIndexPath:indexPath sqlView:self];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint touchPoint = [touch locationInView:self];
    CGRect pullDownTableViewF = self.pulldownTableView.frame;
    CGRect headerViewF = self.headerView.pullDownBtn.frame;
    CGPoint touchpoint = [touch locationInView:self.headerView];
    
    if (CGRectContainsPoint(headerViewF, touchpoint)) {
        return NO;
    }
    
    if (!CGRectContainsPoint(pullDownTableViewF, touchPoint) &&!self.pulldownTableView.hidden) {
        self.pulldownTableView.hidden = YES;
    }
    
    if (!self.pulldownTableView.hidden && CGRectContainsPoint(pullDownTableViewF, touchPoint)) {
        return NO;
    }
    
    return YES;
}

- (void)tap
{
    [self endEditing:YES];
}


@end
