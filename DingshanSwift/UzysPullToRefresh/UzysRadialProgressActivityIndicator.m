//
//  uzysRadialProgressActivityIndicator.m
//  UzysRadialProgressActivityIndicator
//
//  Created by Uzysjung on 13. 10. 22..
//  Copyright (c) 2013년 Uzysjung. All rights reserved.
//

#import "UzysRadialProgressActivityIndicator.h"
#import "UIScrollView+UzysCircularProgressPullToRefresh.h"
#import "DSActivityIndicatorView.h"
#define DEGREES_TO_RADIANS(x) (x)/180.0*M_PI
#define RADIANS_TO_DEGREES(x) (x)/M_PI*180.0

#define cDefaultFloatComparisonEpsilon    0.001
#define cEqualFloats(f1, f2, epsilon)    ( fabs( (f1) - (f2) ) < epsilon )
#define cNotEqualFloats(f1, f2, epsilon)    ( !cEqualFloats(f1, f2, epsilon) )

#define StartPosition 5.0
#define PulltoRefreshThreshold 60.0
@interface UzysRadialProgressActivityIndicatorBackgroundLayer : CALayer

@property (nonatomic,assign) CGFloat outlineWidth;
- (id)initWithBorderWidth:(CGFloat)width;

@end
@implementation UzysRadialProgressActivityIndicatorBackgroundLayer
- (id)init
{
    self = [super init];
    if(self) {
        self.outlineWidth=2.0f;
        self.contentsScale = [UIScreen mainScreen].scale;
        [self setNeedsDisplay];
    }
    return self;
}
- (id)initWithBorderWidth:(CGFloat)width
{
    self = [super init];
    if(self) {
        self.outlineWidth=width;
        self.contentsScale = [UIScreen mainScreen].scale;
        [self setNeedsDisplay];
    }
    return self;
}
- (void)drawInContext:(CGContextRef)ctx
{
    //Draw white circle
    CGContextSetFillColor(ctx, CGColorGetComponents([UIColor colorWithWhite:1.0 alpha:0.8].CGColor));
    CGContextFillEllipseInRect(ctx,CGRectInset(self.bounds, self.outlineWidth, self.outlineWidth));

    //Draw circle outline
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:0.4 alpha:0.9].CGColor);
    CGContextSetLineWidth(ctx, self.outlineWidth);
    CGContextStrokeEllipseInRect(ctx, CGRectInset(self.bounds, self.outlineWidth , self.outlineWidth ));
}
- (void)setOutlineWidth:(CGFloat)outlineWidth
{
    _outlineWidth = outlineWidth;
    [self setNeedsDisplay];
}
@end

/*-----------------------------------------------------------------*/
@interface UzysRadialProgressActivityIndicator()
@property (nonatomic, strong) DSActivityIndicatorView *activityIndicatorView;  //Loading Indicator
@property (nonatomic, strong) UzysRadialProgressActivityIndicatorBackgroundLayer *backgroundLayer;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CALayer *imageLayer;
@property (nonatomic, assign) double progress;

@end
@implementation UzysRadialProgressActivityIndicator

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 25, 25)];
    if(self) {
        [self _commonInit];
    }
    return self;
}
- (id)initWithImage:(UIImage *)image
{
    self = [super initWithFrame:CGRectMake(0, 0, 25, 25)];
    if(self) {
        self.imageIcon =image;
        [self _commonInit];
    }
    return self;
}

- (void)_commonInit
{
    self.borderColor = [UIColor colorWithRed:203/255.0 green:32/255.0 blue:39/255.0 alpha:1];
    self.borderWidth = 2.0f;
    self.contentMode = UIViewContentModeRedraw;
    self.state = UZYSPullToRefreshStateNone;
    self.backgroundColor = [UIColor clearColor];
    self.progressThreshold = PulltoRefreshThreshold;
    //init actitvity indicator
    _activityIndicatorView = [[DSActivityIndicatorView alloc] initWithFrame:self.bounds];
    _activityIndicatorView.image = [UIImage imageNamed:@"refresh_center_icon"];
    [self addSubview:_activityIndicatorView];
    
    //init background layer
    UzysRadialProgressActivityIndicatorBackgroundLayer *backgroundLayer = [[UzysRadialProgressActivityIndicatorBackgroundLayer alloc] initWithBorderWidth:self.borderWidth];
    backgroundLayer.frame = self.bounds;
    [self.layer addSublayer:backgroundLayer];
    self.backgroundLayer = backgroundLayer;
    
    if(!self.imageIcon)
        self.imageIcon = nil;//[UIImage imageNamed:@"centerIcon"];
    
    //init icon layer
    CALayer *imageLayer = [CALayer layer];
    imageLayer.contentsScale = [UIScreen mainScreen].scale;
    imageLayer.frame = CGRectInset(self.bounds, self.borderWidth, self.borderWidth);
    imageLayer.contents = (id)self.imageIcon.CGImage;
    imageLayer.contentsGravity = kCAGravityResizeAspect;
    [self.layer addSublayer:imageLayer];
    self.imageLayer = imageLayer;
    self.imageLayer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(180),0,0,1);

    //init arc draw layer
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = self.bounds;
    shapeLayer.fillColor = nil;
    shapeLayer.strokeColor = self.borderColor.CGColor;
    shapeLayer.strokeEnd = 0;
    shapeLayer.shadowColor = [UIColor colorWithWhite:1 alpha:0.8].CGColor;
    shapeLayer.shadowOpacity = 0.7;
    shapeLayer.shadowRadius = 20;
    shapeLayer.contentsScale = [UIScreen mainScreen].scale;
    shapeLayer.lineWidth = self.borderWidth;
    shapeLayer.lineCap = kCALineCapRound;
    
    [self.layer addSublayer:shapeLayer];
    self.shapeLayer = shapeLayer;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.shapeLayer.frame = self.bounds;
    [self updatePath];

}
- (void)updatePath {
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:(self.bounds.size.width/2 - self.borderWidth)  startAngle:2*M_PI - DEGREES_TO_RADIANS(-90) endAngle:2*M_PI -DEGREES_TO_RADIANS(360-90) clockwise:NO];

    self.shapeLayer.path = bezierPath.CGPath;
}

#pragma mark - ScrollViewInset
- (void)setupScrollViewContentInsetForLoadingIndicator:(actionHandler)handler animation:(BOOL)animation
{
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    
    if (self.posType == indicator_top) {
        float idealOffset = self.originalTopInset + self.bounds.size.height + 20.0;
        NSLog(@"A----idealOffsetA = %f", idealOffset);
        currentInsets.top = idealOffset;
    }else if(self.posType == indicator_bottom) {
        float idealOffset = self.originalBottomInset + self.bounds.size.height + 20.0;
        NSLog(@"B----idealOffsetB = %f", idealOffset);
        currentInsets.bottom = idealOffset;
    }
    [self setScrollViewContentInset:currentInsets handler:handler animation:animation];
}
- (void)resetScrollViewContentInset:(actionHandler)handler animation:(BOOL)animation
{
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    if (self.posType == indicator_top) {
        currentInsets.top = self.originalTopInset;
    }else if (self.posType == indicator_bottom) {
        currentInsets.bottom = self.originalBottomInset;
    }
    [self setScrollViewContentInset:currentInsets handler:handler animation:animation];
}
- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset handler:(actionHandler)handler animation:(BOOL)animation
{
    NSLog(@"AB----set Content Inset = contentInset.top = %f, contentInset.bottom = %f", contentInset.top, contentInset.bottom);
    if(animation)
    {
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.scrollView.contentInset = contentInset;
                             if(self.state == UZYSPullToRefreshStateLoading && self.scrollView.contentOffset.y <10) {
                                 if (self.posType == indicator_top) {
                                     self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, -1*contentInset.top);
                                 }else if (self.posType == indicator_bottom) {
                                     self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, -1*contentInset.bottom);
                                 }
                             }
                         }
                         completion:^(BOOL finished) {
                             if(handler)
                                 handler();
                         }];
    }
    else
    {
        self.scrollView.contentInset = contentInset;
        if(self.state == UZYSPullToRefreshStateLoading && self.scrollView.contentOffset.y <10) {
            if (self.posType == indicator_top) {
                self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, -1*contentInset.top);
            }else if (self.posType == indicator_bottom) {
                self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, -1*contentInset.bottom);
            }
        }
        if(handler)
            handler();
    }
}

#pragma mark - property
- (void)setProgress:(double)progress
{
    static double prevProgressTop;
    static double prevProgressBottom;
    
    if(progress > 1.0)
    {
        progress = 1.0;
    }
    
    self.alpha = 1.0 * progress;
    
    double prev = 0.0;
    if (self.posType == indicator_top) {
        prev = prevProgressTop;
    }else if (self.posType == indicator_bottom) {
        prev = prevProgressBottom;
    }

    if (progress >= 0 && progress <=1.0) {
        //rotation Animation
        CABasicAnimation *animationImage = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        animationImage.fromValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(2*M_PI - 360*prev)];
        animationImage.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(2*M_PI - 360*progress)];
        animationImage.duration = 0.15;
        animationImage.removedOnCompletion = NO;
        animationImage.fillMode = kCAFillModeForwards;
        [self.imageLayer addAnimation:animationImage forKey:@"animation"];

        //strokeAnimation
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = [NSNumber numberWithFloat:((CAShapeLayer *)self.shapeLayer.presentationLayer).strokeEnd];
        animation.toValue = [NSNumber numberWithFloat:progress];
        animation.duration = 0.35 + 0.25*(fabs([animation.fromValue doubleValue] - [animation.toValue doubleValue]));
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//        [self.shapeLayer removeAllAnimations];
        [self.shapeLayer addAnimation:animation forKey:@"animation"];
        
    }
    _progress = progress;
    if (self.posType == indicator_top) {
        prevProgressTop = progress;
    }else if (self.posType == indicator_bottom) {
        prevProgressBottom = progress;
    }
    
}
-(void)setLayerOpacity:(CGFloat)opacity
{
    self.imageLayer.opacity = opacity;
    self.backgroundLayer.opacity = opacity;
    self.shapeLayer.opacity = opacity;
}
-(void)setLayerHidden:(BOOL)hidden
{
    self.imageLayer.hidden = hidden;
    self.shapeLayer.hidden = hidden;
    self.backgroundLayer.hidden = hidden;
}
-(void)setCenter:(CGPoint)center
{
    [super setCenter:center];
}
- (void)setProgressThreshold:(CGFloat)progressThreshold
{
    _progressThreshold = progressThreshold;
    if (self.posType == indicator_top){
        self.frame = CGRectMake(self.frame.origin.x, self.progressThreshold, self.frame.size.width, self.frame.size.height);
        NSLog(@"A_progressThreshold------- self.frame = (%.1f, %.1f)(%.1f, %.1f),", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    }else if (self.posType == indicator_bottom){
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.size.height-self.progressThreshold, self.frame.size.width, self.frame.size.height);
        NSLog(@"B_progressThreshold------- self.frame = (%.1f, %.1f)(%.1f, %.1f),", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    }
}
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentOffset"])
    {
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    }
    else if([keyPath isEqualToString:@"contentSize"])
    {
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
    else if([keyPath isEqualToString:@"frame"])
    {
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
}
- (void)scrollViewDidScroll:(CGPoint)contentOffset
{
    static double prevProgressTop;
    static double prevProgressBottom;
    CGFloat yOffset = contentOffset.y;
    CGFloat ll = self.scrollView.contentSize.height-self.scrollView.frame.size.height;
    if (self.posType == indicator_top){
        self.progress = ((yOffset + self.originalTopInset + StartPosition)/-self.progressThreshold);
        self.center = CGPointMake(self.center.x, (contentOffset.y + self.originalTopInset)/2);
//        NSLog(@"A- - - - yOffset = %.1f,  _state = %zd, self.progress = %.2f, prevProgressTop = %.2f", yOffset, self.state, self.progress, prevProgressTop);
//        NSLog(@"A------yOffset = %.1f, self.frame = (%.1f, %.1f)(%.1f, %.1f),",yOffset, self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        
    }else if (self.posType == indicator_bottom){
        
        self.progress = (MAX((yOffset  - ll - self.originalBottomInset),  StartPosition) / self.progressThreshold);
        CGFloat s =  ll - self.originalBottomInset;
        CGFloat p = (yOffset  - ll - self.originalBottomInset);
        self.progress = (p + s) / s;
//        NSLog(@"B- - - - yOffset = %.1f, ll = %.1f,  _state = %zd, self.progress = %.2f", yOffset, ll, self.state, self.progress);
        self.center = CGPointMake(self.center.x,  self.scrollView.contentSize.height + 20);
//        NSLog(@"B-------yOffset = %.1f, self.frame = (%.1f, %.1f)(%.1f, %.1f),",yOffset, self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        NSLog(@"B-------yOffset = %.1f, p = %f, self.progress  = %f", yOffset, p, self.progress );
    }
    
    switch (_state) {
        case UZYSPullToRefreshStateStopped: //finish
            break;
        case UZYSPullToRefreshStateNone: //detect action
        {
            if (self.posType == indicator_top){
                if(self.scrollView.isDragging && yOffset <0 ){
                    self.state = UZYSPullToRefreshStateTriggering;
                }
            }else if (self.posType == indicator_bottom){
                if (self.scrollView.isDragging && yOffset > ll){
//                    NSLog(@"B-------UZYSPullToRefreshStateTriggering");
                    self.state = UZYSPullToRefreshStateTriggering;
                }
            }
        }
        case UZYSPullToRefreshStateTriggering: //progress
        {
            if(self.progress >= 1.0){
//                NSLog(@"B-------UZYS PullToRefresh State Triggered");
                self.state = UZYSPullToRefreshStateTriggered;
            }
        }
            break;
        case UZYSPullToRefreshStateTriggered: //fire actionhandler
        {
//            NSLog(@"AB-------self.scrollView.dragging = %zd, prevProgressTop = %f, prevProgressBottom = %f", self.scrollView.dragging, prevProgressTop, prevProgressBottom);
            float prev = 0;
            if (self.posType == indicator_top){
                prev = prevProgressTop;
            }else if (self.posType == indicator_bottom){
                prev = prevProgressBottom;
            }
            if(self.scrollView.dragging == NO && prev > 0.99)
            {
                [self actionTriggeredState];
            }
        }
            break;
        case UZYSPullToRefreshStateLoading: //wait until stopIndicatorAnimation
            break;
        case UZYSPullToRefreshStateCanFinish:
            NSLog(@"AB-------self.progress = %f, compare to: %f", self.progress, ((CGFloat)StartPosition/-self.progressThreshold));
            CGFloat std = 0.0;
            if (self.posType == indicator_top){
                std = ((CGFloat)StartPosition/-self.progressThreshold);
            }else if (self.posType == indicator_bottom){
                std = ((CGFloat)StartPosition/self.progressThreshold);
            }
            if(fabs(self.progress - std) < 0.01)
            {
                self.state = UZYSPullToRefreshStateNone;
            }

            break;
        default:
            break;
    }
    if (self.posType == indicator_top){
        prevProgressTop = self.progress;
    }else if (self.posType == indicator_bottom){
        prevProgressBottom = self.progress;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.superview && newSuperview == nil) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (scrollView.showPullToRefresh) {
            if (self.isObserving) {
                [scrollView removeObserver:self forKeyPath:@"contentOffset"];
                [scrollView removeObserver:self forKeyPath:@"contentSize"];
                [scrollView removeObserver:self forKeyPath:@"frame"];
                self.isObserving = NO;
            }
        }
        
        if (scrollView.showPullToLoadMore) {
            if (self.isObserving) {
                [scrollView removeObserver:self forKeyPath:@"contentOffset"];
                [scrollView removeObserver:self forKeyPath:@"contentSize"];
                [scrollView removeObserver:self forKeyPath:@"frame"];
                self.isObserving = NO;
            }
        }
    }
}


-(void)actionStopState
{
    self.state = UZYSPullToRefreshStateCanFinish;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.activityIndicatorView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        self.activityIndicatorView.transform = CGAffineTransformIdentity;
        [self.activityIndicatorView stopAnimating];
        [self resetScrollViewContentInset:^{
            [self setLayerHidden:NO];
            [self setLayerOpacity:1.0];
        } animation:YES];

    }];
}
-(void)actionTriggeredState
{
    self.state = UZYSPullToRefreshStateLoading;
    
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self setLayerOpacity:0.0];
    } completion:^(BOOL finished) {
        [self setLayerHidden:YES];
    }];

    [self.activityIndicatorView startAnimating];
    [self setupScrollViewContentInsetForLoadingIndicator:nil animation:YES];
    if(self.pullToRefreshHandler)
        self.pullToRefreshHandler();
}

- (void)stopIndicatorAnimation
{
    [self actionStopState];
}
- (void)manuallyTriggered
{
    [self setLayerOpacity:0.0];

    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = self.originalTopInset + self.bounds.size.height + 20.0;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, -currentInsets.top);
    } completion:^(BOOL finished) {
        [self actionTriggeredState];
    }];
}
- (void)setSize:(CGSize) size
{
    CGRect rect = CGRectMake((self.scrollView.bounds.size.width - size.width)/2,
                             -size.height, size.width, size.height);

    self.frame=rect;
    self.shapeLayer.frame = self.bounds;
    self.activityIndicatorView.frame = self.bounds;
    self.imageLayer.frame = CGRectInset(self.bounds, self.borderWidth, self.borderWidth);
    
    self.backgroundLayer.frame = self.bounds;
    [self.backgroundLayer setNeedsDisplay];
}
- (void)setImageIcon:(UIImage *)imageIcon
{
    _imageIcon = imageIcon;
    _imageLayer.contents = (id)_imageIcon.CGImage;
    [self setSize:_imageIcon.size];
}
- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    
    _backgroundLayer.outlineWidth = _borderWidth;
    [_backgroundLayer setNeedsDisplay];
    
    _shapeLayer.lineWidth = _borderWidth;
    _imageLayer.frame = CGRectInset(self.bounds, self.borderWidth, self.borderWidth);

}
- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    _shapeLayer.strokeColor = _borderColor.CGColor;
}
@end