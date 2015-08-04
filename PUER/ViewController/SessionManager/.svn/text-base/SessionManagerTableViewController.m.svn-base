//
//  NetworkTableViewController.m
//  PUER
//
//  Created by admin on 14-9-3.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "SessionManagerTableViewController.h"
#import "SessionManagerView.h"

@interface SessionManagerTableViewController ()<SessionManagerViewDelegate>

@property (strong, nonatomic) SessionManagerTableViewCell *cellDisplayingMenuOptions;
@property (strong, nonatomic) SessionManagerView *overlayView;
@property (assign, nonatomic) BOOL customEditing;
@property (assign, nonatomic) BOOL customEditingAnimationInProgress;
@property (strong, nonatomic) UIBarButtonItem *editBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *doneBarButtonItem;@end

@implementation SessionManagerTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    _tableView = [[UITableView alloc]init];
//    self.tableView.frame = CGRectMake(0, 0, 320, 568);
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    [self.view addSubview:self.tableView]
    
    self.searchBar = [[UISearchBar alloc] init];
    [self.searchBar sizeToFit];
    self.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchBar;
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate   = self;
    self.searchController.delegate = self;
    
    _judgeSelfTableViewOrSearchResultsTableView = NO;
    
    self.customEditing = self.customEditingAnimationInProgress = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

#pragma mark - Private

- (void)hideMenuOptionsAnimated:(BOOL)animated
{
    __block SessionManagerTableViewController *weakSelf = self;
    [self.cellDisplayingMenuOptions setMenuOptionsViewHidden:YES animated:animated completionHandler:^{
        weakSelf.customEditing = NO;
    }];
}

- (void)setCustomEditing:(BOOL)customEditing
{
    if (_customEditing != customEditing) {
        _customEditing = customEditing;
        self.tableView.scrollEnabled = !customEditing;
        if (customEditing) {
            if (!_overlayView) {
                _overlayView = [[SessionManagerView alloc] initWithFrame:self.view.bounds];
                _overlayView.backgroundColor = [UIColor clearColor];
                _overlayView.delegate = self;
            }
            self.overlayView.frame = self.view.bounds;
            [self.view addSubview:_overlayView];
            if (self.shouldDisableUserInteractionWhileEditing) {
                for (UIView *view in self.tableView.subviews) {
                    if ((view.gestureRecognizers.count == 0) && view != self.cellDisplayingMenuOptions && view != self.overlayView) {
                        view.userInteractionEnabled = NO;
                    }
                }
            }
        } else {
            self.cellDisplayingMenuOptions = nil;
            [self.overlayView removeFromSuperview];
            for (UIView *view in self.tableView.subviews) {
                if ((view.gestureRecognizers.count == 0) && view != self.cellDisplayingMenuOptions && view != self.overlayView) {
                    view.userInteractionEnabled = YES;
                }
            }
        }
    }
}

#pragma mark * DAContextMenuCell delegate

- (void)contextMenuCellDidSelectMoreOption:(SessionManagerTableViewCell *)cell
{
    NSAssert(NO, @"Should be implemented in subclasses");
}

- (void)contextMenuCellDidSelectDeleteOption:(SessionManagerTableViewCell *)cell
{
    [cell.superview sendSubviewToBack:cell];
    self.customEditing = NO;
}

- (void)contextMenuDidHideInCell:(SessionManagerTableViewCell *)cell
{
    self.customEditing = NO;
    self.customEditingAnimationInProgress = NO;
}

- (void)contextMenuDidShowInCell:(SessionManagerTableViewCell *)cell
{
    self.cellDisplayingMenuOptions = cell;
    self.customEditing = YES;
    self.customEditingAnimationInProgress = NO;
}

- (void)contextMenuWillHideInCell:(SessionManagerTableViewCell *)cell
{
    self.customEditingAnimationInProgress = YES;
}

- (void)contextMenuWillShowInCell:(SessionManagerTableViewCell *)cell
{
    self.customEditingAnimationInProgress = YES;
}

- (BOOL)shouldShowMenuOptionsViewInCell:(SessionManagerTableViewCell *)cell
{
    return self.customEditing && !self.customEditingAnimationInProgress;
}

#pragma mark * DAOverlayView delegate

- (UIView *)overlayView:(SessionManagerView *)view didHitTest:(CGPoint)point withEvent:(UIEvent *)event
{
//    NSLog(@"--%d",_judgeSelfTableViewOrSearchResultsTableView);
    if (_judgeSelfTableViewOrSearchResultsTableView) {
        BOOL shouldIterceptTouches = YES;
        CGPoint location = [self.searchController.searchResultsTableView convertPoint:point fromView:view];
        CGRect rect = [self.searchController.searchResultsTableView convertRect:self.cellDisplayingMenuOptions.frame toView:self.searchController.searchResultsTableView];
        shouldIterceptTouches = CGRectContainsPoint(rect, location);
        if (!shouldIterceptTouches) {
            [self hideMenuOptionsAnimated:YES];
        }
        return (shouldIterceptTouches) ? [self.cellDisplayingMenuOptions hitTest:point withEvent:event] : view;
    }else {
        BOOL shouldIterceptTouches = YES;
        CGPoint location = [self.tableView convertPoint:point fromView:view];
        CGRect rect = [self.tableView convertRect:self.cellDisplayingMenuOptions.frame toView:self.tableView];
        shouldIterceptTouches = CGRectContainsPoint(rect, location);
        if (!shouldIterceptTouches) {
            [self hideMenuOptionsAnimated:YES];
        }
        return (shouldIterceptTouches) ? [self.cellDisplayingMenuOptions hitTest:point withEvent:event] : view;
    }
}

#pragma mark * UITableView delegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView cellForRowAtIndexPath:indexPath] == self.cellDisplayingMenuOptions) {
        [self hideMenuOptionsAnimated:YES];
        return NO;
    }
    return YES;
}

#pragma mark - UISearchDisplayDelegate
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    self.searchBar.placeholder = @"会话ID、工程名、IP地址、最后动作时间";
    [self.tableView headerEndRefreshing];
    [self hideMenuOptionsAnimated:YES];
    
    _judgeSelfTableViewOrSearchResultsTableView = YES;
}

@end
