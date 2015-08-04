//
//  FilterTableViewCell.m
//  PUER
//
//  Created by admin on 14/12/23.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "FilterTableViewCell.h"

@interface FilterTableViewCell ()<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *contextMenuView;
@property (assign, nonatomic, getter = isContextMenuHidden) BOOL contextMenuHidden;
@property (assign, nonatomic) BOOL shouldDisplayContextMenuView;
@property (assign, nonatomic) CGFloat initialTouchPositionX;

@end

@implementation FilterTableViewCell

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _actualContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        self.actualContentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.actualContentView];
        
        //ID
        _IDLable = [[UILabel alloc] init];
        self.IDLable.frame    = CGRectMake(6, 0, 24, 45);
        self.IDLable.textColor = [UIColor blackColor];
        self.IDLable.textAlignment = NSTextAlignmentCenter;
        self.IDLable.font          = [UIFont fontWithName:TextFont_name size:15];
        
        _filterImagerView = [[UIImageView alloc] init];
        _filterImagerView.frame = CGRectMake(_IDLable.frame.origin.x+_IDLable.frame.size.width+5, (45-20)/2, 20, 20);
        
        //过滤器名称
        _filterNameLable      = [[UILabel alloc] init];
        _filterNameLable.frame         = CGRectMake(_filterImagerView.frame.origin.x+_filterImagerView.frame.size.width, self.IDLable.frame.origin.y, SCREEN_WIDTH-80-50-(_filterImagerView.frame.origin.x+_filterImagerView.frame.size.width+5), self.IDLable.frame.size.height);
        _filterNameLable.textColor     = [UIColor blackColor];
        _filterNameLable.textAlignment = NSTextAlignmentLeft;
        _filterNameLable.font          = [UIFont fontWithName:TextFont_name size:15];
        
        //默认
        _defaultLable = [[UILabel alloc] init];
        _defaultLable.frame    = CGRectMake(SCREEN_WIDTH-80-50, _filterNameLable.frame.origin.y, 50, _filterNameLable.frame.size.height);
       _defaultLable.textColor     = [UIColor blackColor];
        _defaultLable.textAlignment = NSTextAlignmentCenter;
        _defaultLable.font          = [UIFont fontWithName:TextFont_name size:15];
        
        //检查会话
        _checkSessionLable = [[UILabel alloc] init];
        _checkSessionLable.frame    = CGRectMake(SCREEN_WIDTH-80, _defaultLable.frame.origin.y, 80, _defaultLable.frame.size.height);
        _checkSessionLable.textColor     = [UIColor blackColor];
        _checkSessionLable.textAlignment = NSTextAlignmentCenter;
        _checkSessionLable.font          = [UIFont fontWithName:TextFont_name size:15];
        
        //用于遮盖view
        _coverView                     = [[UIView alloc] init];
        self.coverView.frame           = CGRectMake(0, 0, self.actualContentView.frame.size.width, self.actualContentView.frame.size.height);
        self.coverView.backgroundColor = [UIColor whiteColor];
        self.coverView.alpha           = 0.0;
        
        //将控件添加到cell上
        [self.actualContentView addSubview:_IDLable];
        [self.actualContentView addSubview:_filterImagerView];
        [self.actualContentView addSubview:_filterNameLable];
        [self.actualContentView addSubview:_defaultLable];
        [self.actualContentView addSubview:_checkSessionLable];
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
    return CGRectGetWidth(self.modifyButton.frame)+CGRectGetWidth(self.deleteButton.frame);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contextMenuView.frame = self.actualContentView.bounds;
    [self.contentView sendSubviewToBack:self.contextMenuView];
    [self.contentView bringSubviewToFront:self.actualContentView];
    self.modifyButton.frame = CGRectMake(SCREEN_WIDTH-45*2, 0., 45, 45);
    self.deleteButton.frame = CGRectMake(SCREEN_WIDTH-45, 0., 45, 45);

}

- (CGFloat)menuOptionButtonWidth
{
    return 45.0;
}

- (void)setDeleteButtonTitle:(NSString *)modifyButtonTitle
{
    _modifyButtonTitle = modifyButtonTitle;
    [self.modifyButton setTitle:modifyButtonTitle forState:UIControlStateNormal];
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

//- (void)setMoreOptionsButtonTitle:(NSString *)moreOptionsButtonTitle
//{
//    _moreOptionsButtonTitle = moreOptionsButtonTitle;
//    [self setNeedsLayout];
//}

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

- (void)modifyButtonTapped
{
    if ([self.delegate respondsToSelector:@selector(contextMenuCellModifyOption:)]) {
        [self.delegate contextMenuCellModifyOption:self];
    }
}

- (void)deleteButtonTapped
{
    if ([self.delegate respondsToSelector:@selector(contextMenuCellDidSelectDeleteOption:)]) {
        [self.delegate contextMenuCellDidSelectDeleteOption:self];
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self setMenuOptionsViewHidden:YES animated:NO completionHandler:nil];
}

#pragma mark * Lazy getters
- (UIButton *)modifyButton
{
    if (self.editable) {
        if (!_modifyButton) {
            CGRect frame = CGRectMake(0., 0., 45.0, 45.0);
            _modifyButton = [[UIButton alloc] initWithFrame:frame];
            [_modifyButton setBackgroundImage:[UIImage imageNamed:@"datalink2"] forState:UIControlStateNormal];
            [self.contextMenuView addSubview:_modifyButton];
            [_modifyButton addTarget:self action:@selector(modifyButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        }
        return _modifyButton;
    }
    return nil;
}

- (UIButton *)deleteButton
{
    if (self.editable) {
        if (!_deleteButton) {
            CGRect frame = CGRectMake(0., 0., 45.0, 45.0);
            _deleteButton = [[UIButton alloc] initWithFrame:frame];
            [_deleteButton setBackgroundImage:[UIImage imageNamed:@"dele"] forState:UIControlStateNormal];
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
