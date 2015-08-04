//
//  DataBackupTableViewCell.m
//  PUER
//
//  Created by admin on 14-9-12.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "DataBackupTableViewCell.h"

@interface DataBackupTableViewCell () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *contextMenuView;
@property (strong, nonatomic) UIButton *moreOptionsButton;
@property (strong, nonatomic) UIButton *deleteButton;
@property (strong, nonatomic) UIButton *fullBackupButton;
@property (assign, nonatomic, getter = isContextMenuHidden) BOOL contextMenuHidden;
@property (assign, nonatomic) BOOL shouldDisplayContextMenuView;
@property (assign, nonatomic) CGFloat initialTouchPositionX;

@end

@implementation DataBackupTableViewCell

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _actualContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        self.actualContentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.actualContentView];
        
        //背景view下的细线
        UIView *lineView       = [[UIView alloc] init];
        lineView.frame         = CGRectMake(0, 44.5, SCREEN_WIDTH, 0.5);
        lineView.backgroundColor = [UIColor grayColor];
        lineView.alpha           = 0.6;
        [self.actualContentView addSubview:lineView];
        
        //ID
        _IDLable = [[UILabel alloc] init];
        self.IDLable.frame    = CGRectMake(6, 15, 24, 16);
        self.IDLable.textColor = [UIColor blackColor];
        self.IDLable.textAlignment = NSTextAlignmentCenter;
        self.IDLable.font          = [UIFont systemFontOfSize:15];
        
        //名称
        _nameLable      = [[UILabel alloc] init];
        self.nameLable.frame         = CGRectMake(self.IDLable.frame.origin.x+self.IDLable.frame.size.width+5, self.IDLable.frame.origin.y, 145, self.IDLable.frame.size.height);
        self.nameLable.textColor     = [UIColor blackColor];
        self.nameLable.textAlignment = NSTextAlignmentLeft;
        self.nameLable.font          = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        
        //备份路径
        _backupPathLable = [[UILabel alloc] init];
        self.backupPathLable.frame    = CGRectMake(self.nameLable.frame.origin.x+self.nameLable.frame.size.width+5, self.nameLable.frame.origin.y, SCREEN_WIDTH-(self.nameLable.frame.origin.x+self.nameLable.frame.size.width+5)-25, self.nameLable.frame.size.height);
        self.backupPathLable.textColor     = [UIColor blackColor];
        self.backupPathLable.textAlignment = NSTextAlignmentLeft;
        self.backupPathLable.font          = [UIFont systemFontOfSize:14];
        
        //等待指示器
        _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        [self.activity setCenter:CGPointMake(SCREEN_WIDTH-20, 45/2)];//指定进度轮中心点
        [self.activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
        //        self.webActivity.backgroundColor = [UIColor grayColor];
        [self.activity stopAnimating];
        self.activity.hidden = YES;
        
        //用于遮盖view
        _coverView                     = [[UIView alloc] init];
        self.coverView.frame           = CGRectMake(0, 0, self.actualContentView.frame.size.width, self.actualContentView.frame.size.height);
        self.coverView.backgroundColor = [UIColor whiteColor];
        self.coverView.alpha           = 0.0;
        
        //将控件添加到cell上
        [self.actualContentView addSubview:self.IDLable];
        [self.actualContentView addSubview:self.nameLable];
        [self.actualContentView addSubview:self.backupPathLable];
        [self.actualContentView addSubview:self.activity];
        [self.actualContentView addSubview:self.coverView];
        
        
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUp];
}

- (void)setUp
{
    self.contextMenuView = [[UIView alloc] initWithFrame:self.actualContentView.bounds];
    self.contextMenuView.backgroundColor = self.contentView.backgroundColor;
    [self.contentView insertSubview:self.contextMenuView belowSubview:self.actualContentView];
    self.contextMenuHidden = self.contextMenuView.hidden = YES;
    self.shouldDisplayContextMenuView = NO;
    self.editable = YES;
    self.moreOptionsButtonTitle = @"差异备份";
    self.deleteButtonTitle = @"数据收缩";
    self.fullBackupButtonTitle = @"完全备份";
    self.menuOptionButtonTitlePadding = 25.;
    self.menuOptionsAnimationDuration = 0.3;
    self.bounceValue = 30.;
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panRecognizer.delegate = self;
    [self addGestureRecognizer:panRecognizer];
    [self setNeedsLayout];
}

#pragma mark - Public

- (CGFloat)contextMenuWidth
{
    return CGRectGetWidth(self.deleteButton.frame) + CGRectGetWidth(self.moreOptionsButton.frame)+ CGRectGetWidth(self.fullBackupButton.frame);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contextMenuView.frame = self.actualContentView.bounds;
    [self.contentView sendSubviewToBack:self.contextMenuView];
    [self.contentView bringSubviewToFront:self.actualContentView];
    
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat menuOptionButtonWidth = [self menuOptionButtonWidth];
    self.fullBackupButton.frame = CGRectMake(width - menuOptionButtonWidth - CGRectGetWidth(self.deleteButton.frame)-CGRectGetWidth(self.moreOptionsButton.frame), 0., menuOptionButtonWidth, height);
    self.moreOptionsButton.frame = CGRectMake(width - menuOptionButtonWidth - CGRectGetWidth(self.deleteButton.frame), 0., menuOptionButtonWidth, height);
    self.deleteButton.frame = CGRectMake(width - menuOptionButtonWidth, 0., menuOptionButtonWidth, height);
    
    UIView *lineViewOne = [[UIView alloc] init];
    lineViewOne.frame = CGRectMake(SCREEN_WIDTH-60.5, 15, 1, 15);
    lineViewOne.backgroundColor = [UIColor whiteColor];
    [self.contextMenuView addSubview:lineViewOne];
    
    UIView *lineViewTwo = [[UIView alloc] init];
    lineViewTwo.frame = CGRectMake(SCREEN_WIDTH-120.5, 15, 1, 15);
    lineViewTwo.backgroundColor = [UIColor whiteColor];
    [self.contextMenuView addSubview:lineViewTwo];
}

- (CGFloat)menuOptionButtonWidth
{
    return 60;
}

- (void)setDeleteButtonTitle:(NSString *)deleteButtonTitle
{
    _deleteButtonTitle = deleteButtonTitle;
    [self.deleteButton setTitle:deleteButtonTitle forState:UIControlStateNormal];
    [self setNeedsLayout];
}

- (void)setEditable:(BOOL)editable
{
    if (_editable != editable) {
        _editable = editable;
        [self setNeedsLayout];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (self.contextMenuHidden) {
        self.contextMenuView.hidden = YES;
        [super setHighlighted:highlighted animated:animated];
    }
}

- (void)setMenuOptionButtonTitlePadding:(CGFloat)menuOptionButtonTitlePadding
{
    if (_menuOptionButtonTitlePadding != menuOptionButtonTitlePadding) {
        _menuOptionButtonTitlePadding = menuOptionButtonTitlePadding;
        [self setNeedsLayout];
    }
}

- (void)setMenuOptionsViewHidden:(BOOL)hidden animated:(BOOL)animated completionHandler:(void (^)(void))completionHandler
{
    if (!hidden) {
        self.coverView.alpha   = 0.5;
    }else {
        self.coverView.alpha   = 0.0;
    }
    
    if (self.selected) {
        [self setSelected:NO animated:NO];
    }
    CGRect frame = CGRectMake((hidden) ? 0 : -[self contextMenuWidth], 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    [UIView animateWithDuration:(animated) ? self.menuOptionsAnimationDuration : 0.
                          delay:0.
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self.actualContentView.frame = frame;
     } completion:^(BOOL finished) {
         self.contextMenuHidden = hidden;
         self.shouldDisplayContextMenuView = !hidden;
         if (!hidden) {
             [self.delegate contextMenuDidShowInCell:self];
         } else {
             [self.delegate contextMenuDidHideInCell:self];
         }
         if (completionHandler) {
             completionHandler();
         }
     }];
}

- (void)setMoreOptionsButtonTitle:(NSString *)moreOptionsButtonTitle
{
    _moreOptionsButtonTitle = moreOptionsButtonTitle;
    [self.moreOptionsButton setTitle:self.moreOptionsButtonTitle forState:UIControlStateNormal];
    [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.contextMenuHidden) {
        self.contextMenuView.hidden = YES;
        [super setSelected:selected animated:animated];
    }
}

#pragma mark - Private

- (void)handlePan:(UIPanGestureRecognizer *)recognizer;
{
    if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *panRecognizer = (UIPanGestureRecognizer *)recognizer;
        
        CGPoint currentTouchPoint = [panRecognizer locationInView:self.contentView];
        CGFloat currentTouchPositionX = currentTouchPoint.x;
        CGPoint velocity = [recognizer velocityInView:self.contentView];
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            self.initialTouchPositionX = currentTouchPositionX;
            if (velocity.x > 0) {
                [self.delegate contextMenuWillHideInCell:self];
            } else {
                [self.delegate contextMenuDidShowInCell:self];
            }
        } else if (recognizer.state == UIGestureRecognizerStateChanged) {
            CGPoint velocity = [recognizer velocityInView:self.contentView];
            if (!self.contextMenuHidden || (velocity.x > 0. || [self.delegate shouldShowMenuOptionsViewInCell:self])) {
                if (self.selected) {
                    [self setSelected:NO animated:NO];
                }
                self.contextMenuView.hidden = NO;
                CGFloat panAmount = currentTouchPositionX - self.initialTouchPositionX;
                self.initialTouchPositionX = currentTouchPositionX;
                CGFloat minOriginX = -[self contextMenuWidth] - self.bounceValue;
                CGFloat maxOriginX = 0.;
                CGFloat originX = CGRectGetMinX(self.actualContentView.frame) + panAmount;
                originX = MIN(maxOriginX, originX);
                originX = MAX(minOriginX, originX);
                
                
                if ((originX < -0.5 * [self contextMenuWidth] && velocity.x < 0.) || velocity.x < -100) {
                    self.shouldDisplayContextMenuView = YES;
                } else if ((originX > -0.3 * [self contextMenuWidth] && velocity.x > 0.) || velocity.x > 100) {
                    self.shouldDisplayContextMenuView = NO;
                }
                self.actualContentView.frame = CGRectMake(originX, 0., CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
            }
        } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
            [self setMenuOptionsViewHidden:!self.shouldDisplayContextMenuView animated:YES completionHandler:nil];
        }
    }
}

- (void)deleteButtonTapped
{
    if ([self.delegate respondsToSelector:@selector(contextMenuCellDidSelectDeleteOption:)]) {
        [self.delegate contextMenuCellDidSelectDeleteOption:self];
    }
}

- (void)moreButtonTapped
{
    [self.delegate contextMenuCellDidSelectMoreOption:self];
}

- (void)fullBackupTapped
{
    [self.delegate contextMenuCellDidFullBackup:self];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self setMenuOptionsViewHidden:YES animated:NO completionHandler:nil];
}

#pragma mark * Lazy getters
- (UIButton *)fullBackupButton
{
    if (!_fullBackupButton) {
        CGRect frame = CGRectMake(0., 0., 60., CGRectGetHeight(self.actualContentView.frame));
        _fullBackupButton = [[UIButton alloc] initWithFrame:frame];
        [self.fullBackupButton setTitle:self.fullBackupButtonTitle forState:UIControlStateNormal];
        self.fullBackupButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contextMenuView addSubview:_fullBackupButton];
        _fullBackupButton.backgroundColor = [UIColor colorWithRed:75/255. green:105/255. blue:136/255. alpha:1.];
        [_fullBackupButton addTarget:self action:@selector(fullBackupTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullBackupButton;
}

- (UIButton *)moreOptionsButton
{
    if (!_moreOptionsButton) {
        CGRect frame = CGRectMake(0., 0., 60., CGRectGetHeight(self.actualContentView.frame));
        _moreOptionsButton = [[UIButton alloc] initWithFrame:frame];
        self.moreOptionsButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _moreOptionsButton.backgroundColor = [UIColor colorWithRed:75/255. green:105/255. blue:136/255. alpha:1.];
        [self.contextMenuView addSubview:_moreOptionsButton];
        [_moreOptionsButton addTarget:self action:@selector(moreButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreOptionsButton;
}

- (UIButton *)deleteButton
{
    if (self.editable) {
        if (!_deleteButton) {
            CGRect frame = CGRectMake(0., 0., 60., CGRectGetHeight(self.actualContentView.frame));
            _deleteButton = [[UIButton alloc] initWithFrame:frame];
            self.deleteButton.titleLabel.font = [UIFont systemFontOfSize:12];
            _deleteButton.backgroundColor = [UIColor colorWithRed:75/255. green:105/255. blue:136/255. alpha:1.];
            [self.contextMenuView addSubview:_deleteButton];
            [_deleteButton addTarget:self action:@selector(deleteButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        }
        return _deleteButton;
    }
    return nil;
}

#pragma mark * UIPanGestureRecognizer delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
        return fabs(translation.x) > fabs(translation.y);
    }
    return YES;
}


@end
