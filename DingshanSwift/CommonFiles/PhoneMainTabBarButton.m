//
//  PhoneMainTabBarButton.m
//  PhoneUIKit
//
//  Created by song jufeng on 13-12-30.
//  Copyright (c) 2013年 song jufeng. All rights reserved.
//

#import "PhoneMainTabBarButton.h"
@interface PhoneMainTabBarButton()
{
    UILabel * lableTitle;
    UIImageView * imageview;
    UIImageView * imageview2;
}
@end

@implementation PhoneMainTabBarButton

- (id)initWithFrame:(CGRect)frame title:(NSString*)title
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        self.adjustsImageWhenHighlighted = NO;
        self.exclusiveTouch = YES;
        
        imageview = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(frame)-42)/2, 0, 42, 32)];
        [self addSubview:imageview];
        imageview.backgroundColor = [UIColor clearColor];
        
        imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(frame) - 64) / 2, 0, 64, 49)];
        imageview2.alpha = 0;
        [self addSubview:imageview2];
        
        if(title)
        {
            lableTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 29, self.bounds.size.width, 20)];
            lableTitle.backgroundColor = [UIColor clearColor];
            lableTitle.textAlignment = NSTextAlignmentCenter;
            lableTitle.font = [UIFont fontWithName:@"Arial" size:12];
            lableTitle.text = title;
            [self addSubview:lableTitle];
        }
    }
    return self;
}
//为防止初始化时候动画效果结束不同步导致多次设置home index 时候UI效果混乱，增加无动画的设置接口
-(void)setIsSelect:(BOOL)value withAnimation:(BOOL)animation
{
    if (animation) {
        [self setIsSelect:value];
    }
    else
    {
        _isSelect = value;
        if (_isSelect)
        {
            imageview.image = [UIImage imageNamed:_highlightImage];
            [self BecomeHighLight];
            imageview.frame = CGRectMake((CGRectGetWidth(self.bounds) - 64) / 2, 0, 64, 49);
            lableTitle.center = CGPointMake(lableTitle.center.x, self.frame.size.height + 10);
            imageview.alpha = 0;
            imageview2.alpha = 1;
        }else {
            [self BecomeNormal];
            imageview.alpha = 1;
            imageview2.alpha = 0;
            [imageview setFrame:CGRectMake((CGRectGetWidth(self.frame)-42)/2, 0, 42, 32)];
            imageview.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(imageview.frame)/2);
            [lableTitle setFrame:CGRectMake(0, 29, self.bounds.size.width, 20)];
        }
    }
}

-(void)setIsSelect:(BOOL)value
{
    _isSelect = value;
    if (_isSelect)
    {
        imageview.image = [UIImage imageNamed:_highlightImage];
        
        //这里只做了简单的重置，复杂情况以后再考虑
        for (PhoneMainTabBarButton * item in [self superview].subviews)
        {
            if ([item isKindOfClass:[PhoneMainTabBarButton class]] && item != self)
            {
                item.isSelect = NO;
            }
            else if(item == self)
            {
                //本按钮被点击
                [self BecomeHighLight];
                [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
                [UIView animateWithDuration:0.2 animations:^(){
                    //DLog(@"放大动画...%@",self->lableTitle.text);
                    imageview.frame = CGRectMake((CGRectGetWidth(self.bounds) - 64) / 2, 0, 64, 49);
                    lableTitle.center = CGPointMake(lableTitle.center.x, self.frame.size.height + 10);
                    
                } completion:^(BOOL finish){
                    [UIView animateWithDuration:0.2 animations:^(){
                        imageview.alpha = 0;
                        imageview2.alpha = 1;
                    }
                    completion:^(BOOL finish){
                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                    }];
                }];
            }
        }
    }
    else
    {
        [self BecomeNormal];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView animateWithDuration:0.2 animations:^(){
            imageview.alpha = 1;
            imageview2.alpha = 0;
            
        } completion:^(BOOL finish){
            [UIView animateWithDuration:0.2 animations:^(){
                //DLog(@"缩小动画...%@",self->lableTitle.text);
                [imageview setFrame:CGRectMake((CGRectGetWidth(self.frame)-42)/2, 0, 42, 32)];
                imageview.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(imageview.frame)/2);
                [lableTitle setFrame:CGRectMake(0, 29, self.bounds.size.width, 20)];
            }
            completion:^(BOOL finish){
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }];
        }];
        
    }
}

-(void)BecomeNormal
{
    if (_normalImage) {
        imageview.image = [UIImage imageNamed:_normalImage];
        [self setBackgroundImage:nil forState:UIControlStateNormal];
        if (_normalTitleColor) {
            lableTitle.textColor = _normalTitleColor;
        }
    }
}

-(void)BecomeHighLight
{
    //在不存在高亮图片时就显示普通图片
    if (_highlightImage)
    {
        imageview.image = [UIImage imageNamed:_highlightImage];
        imageview2.image = [UIImage imageNamed:_highlightImage2];
        [self setBackgroundImage:[UIImage imageNamed:_backImage] forState:UIControlStateNormal];
        if (_highlightTitleColor)
        {
            lableTitle.textColor = _highlightTitleColor;
        }
    }
    else
    {
        [self BecomeNormal];
    }
}

-(void)dealloc
{
    self.normalImage = nil;
    self.highlightImage = nil;
    self.backImage = nil;
    self.normalTitleColor = nil;
    self.highlightTitleColor = nil;
}
@end
