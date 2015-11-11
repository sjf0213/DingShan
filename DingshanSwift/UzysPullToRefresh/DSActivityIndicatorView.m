//
//  DSActivityIndicatorView.m
//  UzysCircularProgressPullToRefresh
//
//  Created by song jufeng on 15/11/10.
//  Copyright © 2015年 Uzysjung. All rights reserved.
//

#import "DSActivityIndicatorView.h"

@implementation DSActivityIndicatorView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)startAnimating{
    self.alpha = 1.0;
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI];
    rotationAnimation.duration = 0.55;
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.cumulative = YES;
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
- (void)stopAnimating{
    [self.layer removeAnimationForKey:@"rotationAnimation"];
    self.alpha = 0.0;
}
- (BOOL)isAnimating{
    return NO;
}

-(void)setImage:(UIImage *)image
{
    _image = image;
    for (UIImageView* imgView in self.subviews) {
        [imgView removeFromSuperview];
    }
    UIImageView* imgView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:imgView];
}
@end
