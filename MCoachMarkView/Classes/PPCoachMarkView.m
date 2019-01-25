//
//  PPCoachMarkView.m
//  PatPat
//
//  Created by patpat on 15/4/22.
//  Copyright (c) 2015年 http://www.patpat.com. All rights reserved.
//

#import "PPCoachMarkView.h"
#import <QuartzCore/QuartzCore.h>
#import "MFStoreHelper.h"
#import "UIView+Extensions.h"

static CGFloat const kMarkViewMaxWidth = 300.0f;
static CGFloat const kArrowImageViewHeight = 18.0f;
static CGFloat const kArrowImageViewWidth = 5.0f;
static CGFloat const kSpace               = 63.0f;
static CGFloat const kOkBtnWidth          = 22.0f;
#define kMarkAnimationDuration 0.35

#define MViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES] // View 圆角


@interface PPCoachMarkView()
{
    UIView* _markView;
    UIView* _contentView;
    UILabel* _messageLbl;
    UILabel* _lineLbl;
    UIButton* _okBtn;
}

@end

@implementation PPCoachMarkView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _isShowed = NO;
        self.alpha = 1.0f;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTapGesture:)]];
        
        UISwipeGestureRecognizer *upswipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upSwipeAction:)];
        upswipe.direction = UISwipeGestureRecognizerDirectionUp;
        [self addGestureRecognizer:upswipe];
        
        UISwipeGestureRecognizer *downswipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downSwipeAction:)];
        downswipe.direction = UISwipeGestureRecognizerDirectionDown;
        [self addGestureRecognizer:downswipe];
        
        _markView = [[UIView alloc]init];
        _markView.backgroundColor = [UIColor clearColor];
        _markView.alpha = 0.0f;
        [self addSubview:_markView];
        
        _contentView = [[UIView alloc]initWithFrame:CGRectZero];
        [_markView addSubview:_contentView];
        _contentView.backgroundColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0];
        MViewRadius(_contentView, 5);
        
        _messageLbl = [[UILabel alloc]init];
        _messageLbl.textColor = [UIColor whiteColor];
        _messageLbl.numberOfLines = 0;
        _messageLbl.font = [UIFont fontWithName:@"Avenir-Light" size:14];
        _messageLbl.textAlignment = NSTextAlignmentLeft;
        _messageLbl.lineBreakMode = NSLineBreakByWordWrapping;
        [_contentView addSubview:_messageLbl];
        
        _lineLbl = [[UILabel alloc]init];
        _lineLbl.backgroundColor = [UIColor whiteColor];
        _lineLbl.textColor = [UIColor whiteColor];
        [_contentView addSubview:_lineLbl];
        
        _okBtn = [[UIButton alloc]init];
        _okBtn.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:14];
        [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_okBtn setTitle:@"OK" forState:UIControlStateNormal];
        [_okBtn addTarget:self action:@selector(okBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_okBtn sizeToFit];
        [_contentView addSubview:_okBtn];
        
        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kArrowImageViewWidth, kArrowImageViewHeight)];
        [_markView addSubview:_arrowImageView];
    }
    return self;
}

+ (PPCoachMarkView *)showInView:(UIView *)superView
{
    PPCoachMarkView *view = [[PPCoachMarkView alloc]initWithFrame:CGRectZero];
    [superView addSubview:view];
    return view;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.frame =[UIApplication sharedApplication].keyWindow.rootViewController.view.bounds;
}

- (void)okBtnAction:(UIButton *)btn
{
    [self dismiss];
}

- (void)animationWithMarkView
{
    [UIView animateWithDuration:kMarkAnimationDuration animations:^{
        self->_markView.alpha = 1.0f;
      } completion:^(BOOL finished) {
      }];
}

- (void)showMessage:(NSString *)msg
            atPoint:(CGPoint)point
           position:(CoachArrowImageViewPosition)position
{
    [self animationWithMarkView];
    _isShowed = YES;
    _messageLbl.text = msg;
    [_messageLbl sizeToFit];
    //判断显示的行数
    if (_messageLbl.width+kSpace >=kMarkViewMaxWidth) {
        //显示两行
        _messageLbl.frame = CGRectMake(15, 0, kMarkViewMaxWidth- kSpace, MAXFLOAT);
        [_messageLbl sizeToFit];
        _messageLbl.y = 10;
        _lineLbl.width = 1;
        _lineLbl.height = 30;
        _lineLbl.x = _messageLbl.width+20;
        _lineLbl.centerY = _messageLbl.centerY;
        
    }else {
        //显示一行
        _messageLbl.x = _messageLbl.y = 10;
        _lineLbl.width = 1.0;
        _lineLbl.height = 15;
        _lineLbl.x = CGRectGetMaxX(_messageLbl.frame)+10;
        _lineLbl.centerY = _messageLbl.centerY;
    }
    
    _okBtn.width = kOkBtnWidth;
    _okBtn.x = CGRectGetMaxX(_lineLbl.frame)+10;
    _okBtn.centerY = _messageLbl.centerY;
    _contentView.width = CGRectGetMaxX(_okBtn.frame)+10;
    _contentView.height = 20+_messageLbl.height;
    _markView.width = _contentView.width;
    _markView.height = _contentView.height+kArrowImageViewHeight;
    _contentView.x = 0.0;
    _arrowImageView.image = [UIImage imageNamed:@"coachmark_discount"];
    
    if (position ==ArrowImageViewCenter) {
        _arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
        _arrowImageView.y = CGRectGetMaxY(_contentView.frame);
        _arrowImageView.x = (_markView.width-_arrowImageView.width)/2.0;
        _contentView.y = 0.0;
        _markView.frame = CGRectMake(point.x-_markView.width/2.0, point.y-_contentView.height-10, _markView.width, _markView.height);
        
    }else if (position ==ArrowImageViewLeft){
        _lineLbl.height = 30;
        _lineLbl.y = (_contentView.height -_lineLbl.height)/2.0;
        _arrowImageView.y = 0;
        _arrowImageView.x = 15;
        _markView.frame = CGRectMake(point.x-7, point.y + 5, _markView.width, _markView.height);
        _contentView.y = _markView.height- _contentView.height;
        
    }else if (position == ArrowImageViewRight){
        _arrowImageView.y = 0.0f;
        _arrowImageView.x = _markView.width-10;
        _contentView.y = _markView.height- _contentView.height;
        _markView.frame = CGRectMake(point.x-_markView.width-1, point.y+5, _markView.width, _markView.height);
    }
}

- (void)setContentViewBackGroundColor:(UIColor*)color
{
    self.backgroundColor = color;
    _markView.backgroundColor = [UIColor clearColor];
}


- (void)dismiss
{
    [self dismiss:nil];
}

- (void)upSwipeAction:(UISwipeGestureRecognizer*)tap
{
    [self dismiss:nil];
}

- (void)downSwipeAction:(UISwipeGestureRecognizer*)tap
{
    [self dismiss:nil];
}

- (void)dismiss:(void(^)(BOOL finished))block
{
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.33 animations:^{
        self->_markView.alpha = 0.0f;
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        self->_isShowed = NO;
        self.hidden = YES;
        [self removeFromSuperview];
        [self.layer removeAnimationForKey:@"animateLayer"];
        if (block) {
            block(YES);
        }
    }];
}

- (void)clickTapGesture:(UITapGestureRecognizer*)tap
{
    [self dismiss:^(BOOL finished) {
    }];
}


@end

