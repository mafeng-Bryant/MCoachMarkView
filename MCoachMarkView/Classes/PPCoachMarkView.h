//
//  PPCoachMarkView.h
//  PatPat
//
//  Created by patpat on 15/4/22.
//  Copyright (c) 2015年 http://www.patpat.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPCoachMarkView;

typedef enum {
    ArrowImageViewRight, // right
    ArrowImageViewLeft,  // left
    ArrowImageViewCenter // center
}CoachArrowImageViewPosition;


@interface PPCoachMarkView : UIView
@property(nonatomic,assign,readonly)BOOL isShowed;
@property(nonatomic,strong) UIImageView *arrowImageView;
@property(nonatomic,assign) CoachArrowImageViewPosition position;

+ (PPCoachMarkView *)showInView:(UIView *)v;

- (void)showMessage:(NSString *)msg
            atPoint:(CGPoint)point
           position:(CoachArrowImageViewPosition)position;

- (void)dismiss;

- (void)dismiss:(void(^)(BOOL finished))block;

- (void)setContentViewBackGroundColor:(UIColor*)color;


@end
