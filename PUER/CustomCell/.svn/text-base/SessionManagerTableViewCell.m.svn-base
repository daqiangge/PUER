//
//  SessionManagerTableViewCell.m
//  PUER
//
//  Created by admin on 14-9-5.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "SessionManagerTableViewCell.h"

#define CellHeight_IPhone4S 55
#define CellHeight_IPhone5  58


@interface SessionManagerTableViewCell () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *contextMenuView;
@property (strong, nonatomic) UIButton *moreOptionsButton;
@property (strong, nonatomic) UIButton *deleteButton;
@property (assign, nonatomic, getter = isContextMenuHidden) BOOL contextMenuHidden;
@property (assign, nonatomic) BOOL shouldDisplayContextMenuView;
@property (assign, nonatomic) CGFloat initialTouchPositionX;

@end

@implementation SessionManagerTableViewCell

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _actualContentView = [[UIView alloc] init];
        if (iPhone5) {
            _actualContentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CellHeight_IPhone5);
        }else {
            _actualContentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CellHeight_IPhone4S);
        }
        self.actualContentView.backgroundColor = [UIColor whiteColor];
        self.actualContentView.hidden = NO;
        [self addSubview:self.actualContentView];
        
        //ID
        _IDLable = [[UILabel alloc] init];
        self.IDLable.frame    = CGRectMake(6, 15, 24, 16);
        self.IDLable.textColor = [UIColor blackColor];
        self.IDLable.textAlignment = NSTextAlignmentCenter;
        self.IDLable.font          = [UIFont fontWithName:@"Helvetica" size:14];
        
        //用户名
        _userNameLable      = [[UILabel alloc] init];
        self.userNameLable.frame         = CGRectMake(self.IDLable.frame.origin.x+self.IDLable.frame.size.width+5, self.IDLable.frame.origin.y, 115, self.IDLable.frame.size.height);
        self.userNameLable.textColor     = [UIColor blackColor];
        self.userNameLable.textAlignment = NSTextAlignmentLeft;
        self.userNameLable.font          = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        
        //IP地址
        _IPLable = [[UILabel alloc] init];
        self.IPLable.frame    = CGRectMake(self.userNameLable.frame.origin.x+self.userNameLable.frame.size.width+15, self.userNameLable.frame.origin.y, SCREEN_WIDTH-(self.userNameLable.frame.origin.x+self.userNameLable.frame.size.width+5)-10, self.userNameLable.frame.size.height);
        self.IPLable.textColor     = [UIColor blackColor];
        self.IPLable.textAlignment = NSTextAlignmentLeft;
        self.IPLable.font          = [UIFont fontWithName:@"Helvetica" size:14];
        
        //工程名称
        _nameLable           = [[UILabel alloc] init];
        self.nameLable.frame               = CGRectMake(self.userNameLable.frame.origin.x, self.userNameLable.frame.origin.y+self.userNameLable.frame.size.height+3, self.userNameLable.frame.size.width, 14);
        self.nameLable.textColor     = [UIColor blackColor];
        self.nameLable.textAlignment = NSTextAlignmentLeft;
        self.nameLable.font          = [UIFont fontWithName:@"Helvetica" size:12];
        
        //最近动作时间
        _timeLable            = [[UILabel alloc] init];
        self.timeLable.frame               = CGRectMake(self.IPLable.frame.origin.x, self.nameLable.frame.origin.y, self.nameLable.frame.size.width, self.nameLable.frame.size.height);
        self.timeLable.textColor     = [UIColor blackColor];
        self.timeLable.textAlignment = NSTextAlignmentLeft;
        self.timeLable.font          = [UIFont fontWithName:@"Helvetica" size:12];
        
        //网络状态的图标
        _networkStateImageView = [[UIImageView alloc] init];
        self.networkStateImageView.frame = CGRectMake(SCREEN_WIDTH-30, self.IDLable.frame.origin.y+2, 12, 12);
        
        //sid
        _sessionidLable = [[UILabel alloc] init];
        self.sessionidLable.frame               = CGRectMake(self.IPLable.frame.origin.x, self.nameLable.frame.origin.y, self.nameLable.frame.size.width, self.nameLable.frame.size.height);
        self.sessionidLable.textColor     = [UIColor blackColor];
        self.sessionidLable.textAlignment = NSTextAlignmentLeft;
        self.sessionidLable.font          = [UIFont fontWithName:@"Helvetica" size:12];
        self.sessionidLable.hidden = YES;
        
        //用于遮盖view
        _coverView                     = [[UIView alloc] init];
        self.coverView.frame           = CGRectMake(0, 0, self.actualContentView.frame.size.width, self.actualContentView.frame.size.height);
        self.coverView.backgroundColor = [UIColor whiteColor];
        self.coverView.alpha           = 0.0;
        
        //将控件添加到cell上
        [self.actualContentView addSubview:self.IDLable];
        [self.actualContentView addSubview:self.nameLable];
        [self.actualContentView addSubview:self.IPLable];
        [self.actualContentView addSubview:self.userNameLable];
        [self.actualContentView addSubview:self.timeLable];
        [self.actualContentView addSubview:self.networkStateImageView];
        [self.actualContentView addSubview:self.sessionidLable];
        [self.actualContentView addSubview:self.coverView];
        [self addSubview:[self NoContentLable]];
        
        [self setUp];
    }
    return self;
}

- (UILabel *)NoContentLable
{
    _noContentLable      = [[UILabel alloc] init];
    _noContentLable.frame         = CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height);
    _noContentLable.alpha         = 0.5;
    _noContentLable.font          = [UIFont systemFontOfSize:17];
    _noContentLable.textAlignment = NSTextAlignmentCenter;
    _noContentLable.hidden        = YES;
    
    return _noContentLable;
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
    //    self.moreOptionsButtonTitle = @"More";
    //    self.deleteButtonTitle = @"Delete";
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
    return CGRectGetWidth(self.deleteButton.frame) + CGRectGetWidth(self.moreOptionsButton.frame);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contextMenuView.frame = self.actualContentView.bounds;
    [self.contentView sendSubviewToBack:self.contextMenuView];
    [self.contentView bringSubviewToFront:self.actualContentView];
    
    //    CGFloat height = CGRectGetHeight(self.bounds);
    //    CGFloat width = CGRectGetWidth(self.bounds);
    //    CGFloat menuOptionButtonWidth = [self menuOptionButtonWidth];
    if (iPhone5) {
        self.moreOptionsButton.frame = CGRectMake(SCREEN_WIDTH-CellHeight_IPhone5*2, 0., CellHeight_IPhone5, CellHeight_IPhone5);
        self.deleteButton.frame = CGRectMake(SCREEN_WIDTH-CellHeight_IPhone5, 0., CellHeight_IPhone5, CellHeight_IPhone5);
    }else {
        self.moreOptionsButton.frame = CGRectMake(SCREEN_WIDTH-CellHeight_IPhone4S*2, 0., CellHeight_IPhone4S, CellHeight_IPhone4S);
        self.deleteButton.frame = CGRectMake(SCREEN_WIDTH-CellHeight_IPhone4S, 0., CellHeight_IPhone4S, CellHeight_IPhone4S);
    }
}

- (CGFloat)menuOptionButtonWidth
{
    return 57.0;
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

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self setMenuOptionsViewHidden:YES animated:NO completionHandler:nil];
}

#pragma mark * Lazy getters

- (UIButton *)moreOptionsButton
{
    if (!_moreOptionsButton) {
        CGRect frame;
        if (iPhone5) {
            frame = CGRectMake(0., 0., CellHeight_IPhone5, CGRectGetHeight(self.actualContentView.frame));
        }else {
            frame = CGRectMake(0., 0., CellHeight_IPhone4S, CGRectGetHeight(self.actualContentView.frame));
        }
        _moreOptionsButton = [[UIButton alloc] initWithFrame:frame];
        [_moreOptionsButton setBackgroundImage:[UIImage imageNamed:@"chaxun"] forState:UIControlStateNormal];
        //        _moreOptionsButton.backgroundColor = [UIColor lightGrayColor];
        [self.contextMenuView addSubview:_moreOptionsButton];
        [_moreOptionsButton addTarget:self action:@selector(moreButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreOptionsButton;
}

- (UIButton *)deleteButton
{
    if (self.editable) {
        if (!_deleteButton) {
            CGRect frame;
            if (iPhone5) {
                frame = CGRectMake(0., 0., CellHeight_IPhone5, CGRectGetHeight(self.actualContentView.frame));
            }else {
                frame = CGRectMake(0., 0., CellHeight_IPhone4S, CGRectGetHeight(self.actualContentView.frame));
            }
            _deleteButton = [[UIButton alloc] initWithFrame:frame];
            [_deleteButton setBackgroundImage:[UIImage imageNamed:@"dele"] forState:UIControlStateNormal];
            //            _deleteButton.backgroundColor = [UIColor colorWithRed:251./255. green:34./255. blue:38./255. alpha:1.];
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
