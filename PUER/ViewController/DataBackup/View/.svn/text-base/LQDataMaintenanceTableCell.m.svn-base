//
//  LQDataMaintenanceTableCell.m
//  PUER
//
//  Created by admin on 15/6/2.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "LQDataMaintenanceTableCell.h"

@interface LQDataMaintenanceTableCell()<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *contextMenuView;
@property (strong, nonatomic) UIButton *seeButton;
@property (assign, nonatomic, getter = isContextMenuHidden) BOOL contextMenuHidden;
@property (assign, nonatomic) BOOL shouldDisplayContextMenuView;
@property (assign, nonatomic) CGFloat initialTouchPositionX;

@end

@implementation LQDataMaintenanceTableCell

+ (LQDataMaintenanceTableCell *)dataMaintenanceTableCellWithTableView:(UITableView *)tableView
{
    static NSString *idenifier = @"LQDataMaintenanceTableCell";
    LQDataMaintenanceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    if (cell == nil) {
        cell = [[LQDataMaintenanceTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenifier];
    }
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _actualContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, cellHeight)];
        self.actualContentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.actualContentView];
        
        //背景view下的细线
//        UIView *lineView       = [[UIView alloc] init];
//        lineView.frame         = CGRectMake(0, cellHeight-0.5, SCREEN_WIDTH, 0.5);
//        lineView.backgroundColor = [UIColor grayColor];
//        lineView.alpha           = 0.6;
//        [self.actualContentView addSubview:lineView];
        
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
        
        //创建时间
        CGFloat createdataLableX = CGRectGetMaxX(self.nameLable.frame)+5;
        CGFloat createdataLableY = CGRectGetMinY(self.nameLable.frame)-3;
        CGFloat createdataLableW = SCREEN_WIDTH-CGRectGetMaxX(self.nameLable.frame)-10;
        CGFloat createdataLableH = CGRectGetHeight(self.nameLable.frame);
        CGRect createdataLableF  = CGRectMake(createdataLableX, createdataLableY, createdataLableW, createdataLableH);
        
        UILabel *createdataLable      = [[UILabel alloc] init];
        createdataLable.frame         = createdataLableF;
        createdataLable.textColor     = self.nameLable.textColor;
        createdataLable.textAlignment = NSTextAlignmentLeft;
        createdataLable.font          = [UIFont systemFontOfSize:12];
        [self.actualContentView addSubview:createdataLable];
        self.createdateLable          = createdataLable;
        
        //修改时间
        CGFloat modifydateLableX = CGRectGetMinX(self.createdateLable.frame);
        CGFloat modifydateLableY = CGRectGetMaxY(self.createdateLable.frame);
        CGFloat modifydateLableW = CGRectGetWidth(self.createdateLable.frame);
        CGFloat modifydateLableH = CGRectGetHeight(self.createdateLable.frame);
        CGRect modifydateLableF  = CGRectMake(modifydateLableX, modifydateLableY, modifydateLableW, modifydateLableH);
        
        UILabel *modifydateLable      = [[UILabel alloc] init];
        modifydateLable.frame         = modifydateLableF;
        modifydateLable.textColor     = self.createdateLable.textColor;
        modifydateLable.textAlignment = self.createdateLable.textAlignment;
        modifydateLable.font          = self.createdateLable.font;
        [self.actualContentView addSubview:modifydateLable];
        self.modifydateLable          = modifydateLable;
        
        
        //用于遮盖view
        _coverView                     = [[UIView alloc] init];
        self.coverView.frame           = CGRectMake(0, 0, self.actualContentView.frame.size.width, self.actualContentView.frame.size.height);
        self.coverView.backgroundColor = [UIColor whiteColor];
        self.coverView.alpha           = 0.0;
        
        //将控件添加到cell上
        [self.actualContentView addSubview:self.IDLable];
        [self.actualContentView addSubview:self.nameLable];
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
    return CGRectGetWidth(self.seeButton.frame);
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
    self.seeButton.frame = CGRectMake(width - menuOptionButtonWidth, 0., menuOptionButtonWidth, height);
}

- (CGFloat)menuOptionButtonWidth
{
    return cellHeight;
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
    if ([self.delegate respondsToSelector:@selector(contextMenuCellDidSee:)]) {
        [self.delegate contextMenuCellDidSee:self];
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self setMenuOptionsViewHidden:YES animated:NO completionHandler:nil];
}

#pragma mark * Lazy getters
- (UIButton *)seeButton
{
        if (_seeButton == nil) {
            CGRect frame = CGRectMake(0., 0., cellHeight, CGRectGetHeight(self.actualContentView.frame));
            _seeButton = [[UIButton alloc] initWithFrame:frame];
            [_seeButton setImage:[UIImage imageNamed:@"chaxun"] forState:UIControlStateNormal];
            [self.contextMenuView addSubview:_seeButton];
            [_seeButton addTarget:self action:@selector(deleteButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        }
        return _seeButton;
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
