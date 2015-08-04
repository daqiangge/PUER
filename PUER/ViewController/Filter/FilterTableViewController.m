//
//  FilterTableViewController.m
//  PUER
//
//  Created by admin on 14/12/23.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "FilterTableViewController.h"
#import "FilterView.h"

@interface FilterTableViewController ()<FilterViewDelegate>

@property (strong, nonatomic) FilterTableViewCell *cellDisplayingMenuOptions;
@property (strong, nonatomic) FilterView *overlayView;
@property (assign, nonatomic) BOOL customEditing;
@property (assign, nonatomic) BOOL customEditingAnimationInProgress;
@property (strong, nonatomic) UIBarButtonItem *editBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *doneBarButtonItem;

@end

@implementation FilterTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.customEditing = self.customEditingAnimationInProgress = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //    UIView *aa = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 40)];
    //    aa.backgroundColor = [UIColor redColor];
    //    [[[UIApplication sharedApplication].delegate window] addSubview:aa];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    //    [super viewDidAppear:animated];
    
}

#pragma mark - Private

- (void)hideMenuOptionsAnimated:(BOOL)animated
{
    __block FilterTableViewController *weakSelf = self;
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
                _overlayView = [[FilterView alloc] initWithFrame:self.view.bounds];
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

- (void)contextMenuCellModifyOption:(FilterTableViewCell *)cell
{
    NSAssert(NO, @"Should be implemented in subclasses");
}

- (void)contextMenuCellDidSelectDeleteOption:(FilterTableViewCell *)cell
{
    [cell.superview sendSubviewToBack:cell];
    self.customEditing = NO;
}

- (void)contextMenuDidHideInCell:(FilterTableViewCell *)cell
{
    self.customEditing = NO;
    self.customEditingAnimationInProgress = NO;
}

- (void)contextMenuDidShowInCell:(FilterTableViewCell *)cell
{
    self.cellDisplayingMenuOptions = cell;
    self.customEditing = YES;
    self.customEditingAnimationInProgress = NO;
}

- (void)contextMenuWillHideInCell:(FilterTableViewCell *)cell
{
    self.customEditingAnimationInProgress = YES;
}

- (void)contextMenuWillShowInCell:(FilterTableViewCell *)cell
{
    self.customEditingAnimationInProgress = YES;
}

- (BOOL)shouldShowMenuOptionsViewInCell:(FilterTableViewCell *)cell
{
    return self.customEditing && !self.customEditingAnimationInProgress;
}

#pragma mark * DAOverlayView delegate

- (UIView *)overlayView:(FilterView *)view didHitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL shouldIterceptTouches = YES;
    CGPoint location = [self.view convertPoint:point fromView:view];
    CGRect rect = [self.view convertRect:self.cellDisplayingMenuOptions.frame toView:self.view];
    shouldIterceptTouches = CGRectContainsPoint(rect, location);
    if (!shouldIterceptTouches) {
        [self hideMenuOptionsAnimated:YES];
    }
    return (shouldIterceptTouches) ? [self.cellDisplayingMenuOptions hitTest:point withEvent:event] : view;
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

@end
