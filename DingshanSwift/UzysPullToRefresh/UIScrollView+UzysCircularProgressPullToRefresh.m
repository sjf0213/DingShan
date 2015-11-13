//
//  UIScrollView+UzysInteractiveIndicator.m
//  UzysRadialProgressActivityIndicator
//
//  Created by Uzysjung on 2013. 11. 12..
//  Copyright (c) 2013년 Uzysjung. All rights reserved.
//

#import "UIScrollView+UzysCircularProgressPullToRefresh.h"
#import <objc/runtime.h>
#define IS_IOS7 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 && floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1)
#define IS_IOS8  ([[[UIDevice currentDevice] systemVersion] compare:@"8" options:NSNumericSearch] != NSOrderedAscending)
#define IS_IPHONE6PLUS ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && [[UIScreen mainScreen] nativeScale] == 3.0f)

#define cDefaultFloatComparisonEpsilon    0.001
#define cEqualFloats(f1, f2, epsilon)    ( fabs( (f1) - (f2) ) < epsilon )
#define cNotEqualFloats(f1, f2, epsilon)    ( !cEqualFloats(f1, f2, epsilon) )

static char UIScrollViewPullToRefreshView;
static char UIScrollViewPullToLoadMoreView;

@implementation UIScrollView (UzysCircularProgressPullToRefresh)
@dynamic pullToRefreshView, pullToLoadMoreView, showPullToRefresh, showPullToLoadMore;

- (void)addPullToRefreshActionHandler:(actionHandler)handler
{
    if(self.pullToRefreshView == nil)
    {
        [self addPullToRefreshActionHandler:handler portraitContentInsetTop:CGFLOAT_MAX landscapeInsetTop:CGFLOAT_MAX];
    }
}

- (void)addPullToRefreshActionHandler:(actionHandler)handler portraitContentInsetTop:(CGFloat)pInsetTop landscapeInsetTop:(CGFloat)lInsetTop
{
    if(self.pullToRefreshView == nil)
    {
        UzysRadialProgressActivityIndicator *view = [[UzysRadialProgressActivityIndicator alloc] initWithImage:[UIImage imageNamed:@"refresh_center_icon"]];
        view.pullToRefreshHandler = handler;
        view.posType = indicator_top;
        view.scrollView = self;
        view.frame = CGRectMake((self.bounds.size.width - view.frame.size.width)/2,
                                -view.frame.size.height, view.frame.size.width, view.frame.size.height);
        view.originalTopInset = self.contentInset.top;
        
        if(cEqualFloats(pInsetTop, CGFLOAT_MAX, cDefaultFloatComparisonEpsilon) && cEqualFloats(lInsetTop, CGFLOAT_MAX, cDefaultFloatComparisonEpsilon)) //NOT DEFINE LANDSCAPE , PORTRAIT INSET
        {
            if(IS_IOS7)
            {
                if(cEqualFloats(self.contentInset.top, 64.00, cDefaultFloatComparisonEpsilon) && cEqualFloats(self.frame.origin.y, 0.0, cDefaultFloatComparisonEpsilon))
                {
                    view.portraitTopInset = 64.0;
                    view.landscapeTopInset = 52.0;
                }
            }
            else if(IS_IOS8)
            {
                if(cEqualFloats(self.contentInset.top, 0.00, cDefaultFloatComparisonEpsilon) &&cEqualFloats(self.frame.origin.y, 0.0, cDefaultFloatComparisonEpsilon))
                {
                    view.portraitTopInset = 64.0;
                    view.originalTopInset = 64.0;
                    
                    if(IS_IPHONE6PLUS)
                        view.landscapeTopInset = 44.0;
                    else
                        view.landscapeTopInset = 32.0;
                    
                }
            }
        }else{
            view.portraitTopInset = pInsetTop;
            view.landscapeTopInset = lInsetTop;
        }
        
        [self addSubview:view];
        [self sendSubviewToBack:view];
        self.pullToRefreshView = view;
        self.showPullToRefresh = YES;
    }
}

- (void)addPullToLoadMoreActionHandler:(actionHandler)handler
{
    if(self.pullToLoadMoreView == nil)
    {
        [self addPullToLoadMoreActionHandler:handler portraitContentInsetBottom:CGFLOAT_MAX landscapeInsetBottom:CGFLOAT_MAX];
    }
}

- (void)addPullToLoadMoreActionHandler:(actionHandler)handler portraitContentInsetBottom:(CGFloat)pInsetBottom landscapeInsetBottom:(CGFloat)lInsetBottom
{
    if(self.pullToLoadMoreView == nil)
    {
        UzysRadialProgressActivityIndicator *view = [[UzysRadialProgressActivityIndicator alloc] initWithImage:[UIImage imageNamed:@"refresh_center_icon"]];
        view.posType = indicator_bottom;
        view.pullToRefreshHandler = handler;
        view.scrollView = self;
        view.frame = CGRectMake((self.bounds.size.width - view.bounds.size.width)/2,
                                -view.bounds.size.height, view.bounds.size.width, view.bounds.size.height);
        view.originalBottomInset = self.contentInset.bottom;
        
        if(cEqualFloats(pInsetBottom, CGFLOAT_MAX, cDefaultFloatComparisonEpsilon) && cEqualFloats(lInsetBottom, CGFLOAT_MAX, cDefaultFloatComparisonEpsilon)) //NOT DEFINE LANDSCAPE , PORTRAIT INSET
        {
            if(IS_IOS7)
            {
                if(cEqualFloats(self.contentInset.top, 64.00, cDefaultFloatComparisonEpsilon) && cEqualFloats(self.frame.origin.y, 0.0, cDefaultFloatComparisonEpsilon))
                {
                    view.portraitBottomInset = 64.0;
                    view.landscapeBottomInset = 52.0;
                }
            }
            else if(IS_IOS8)
            {
                if(cEqualFloats(self.contentInset.top, 0.00, cDefaultFloatComparisonEpsilon) &&cEqualFloats(self.frame.origin.y, 0.0, cDefaultFloatComparisonEpsilon))
                {
                    view.portraitBottomInset = 64.0;
                    view.originalBottomInset = 0.0;
                    
                    if(IS_IPHONE6PLUS)
                        view.landscapeBottomInset = 44.0;
                    else
                        view.landscapeBottomInset = 32.0;
                    
                }
            }
        }else{
            view.portraitBottomInset = pInsetBottom;
            view.landscapeBottomInset = lInsetBottom;
        }
        [self addSubview:view];
        [self sendSubviewToBack:view];
        self.pullToLoadMoreView = view;
        self.showPullToLoadMore = YES;
    }
}

- (void)triggerPullToRefresh
{
    [self.pullToRefreshView manuallyTriggered];
}

- (void)triggerPullToLoadMore
{
    [self.pullToLoadMoreView manuallyTriggered];
}

- (void)stopRefreshAnimation
{
    [self.pullToRefreshView stopIndicatorAnimation];
}

- (void)stopLoadMoreAnimation
{
    [self.pullToLoadMoreView stopIndicatorAnimation];
}
#pragma mark - property
- (void)addTopInsetInPortrait:(CGFloat)pInset TopInsetInLandscape:(CGFloat)lInset
{
    self.pullToRefreshView.portraitTopInset = pInset;
    self.pullToRefreshView.landscapeTopInset = lInset;
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if(orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown)
    {
        self.pullToRefreshView.originalTopInset = self.pullToRefreshView.portraitTopInset;
    }
    else
    {
        self.pullToRefreshView.originalTopInset = self.pullToRefreshView.landscapeTopInset;
    }
    
}

- (void)addBottomInsetInPortrait:(CGFloat)pInset BottomInsetInLandscape:(CGFloat)lInset
{
    self.pullToLoadMoreView.portraitBottomInset = pInset;
    self.pullToLoadMoreView.landscapeBottomInset = lInset;
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if(orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown)
    {
        self.pullToLoadMoreView.originalBottomInset = self.pullToLoadMoreView.portraitBottomInset;
    }
    else
    {
        self.pullToLoadMoreView.originalBottomInset = self.pullToLoadMoreView.landscapeBottomInset;
    }
    
}

- (void)setPullToRefreshView:(UzysRadialProgressActivityIndicator *)pullToRefreshView
{
    [self willChangeValueForKey:@"UzysRadialProgressActivityIndicatorA"];
    objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView, pullToRefreshView, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"UzysRadialProgressActivityIndicatorA"];
}

- (void)setPullToLoadMoreView:(UzysRadialProgressActivityIndicator *)pullToLoadMoreView
{
    [self willChangeValueForKey:@"UzysRadialProgressActivityIndicatorB"];
    objc_setAssociatedObject(self, &UIScrollViewPullToLoadMoreView, pullToLoadMoreView, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"UzysRadialProgressActivityIndicatorB"];
}

- (UzysRadialProgressActivityIndicator *)pullToRefreshView
{
    return objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView);
}

- (UzysRadialProgressActivityIndicator *)pullToLoadMoreView
{
    return objc_getAssociatedObject(self, &UIScrollViewPullToLoadMoreView);
}

- (void)setShowPullToRefresh:(BOOL)showPullToRefresh {
    self.pullToRefreshView.hidden = !showPullToRefresh;
    
    if(showPullToRefresh)
    {
        if(!self.pullToRefreshView.isObserving)
        {
            [self addObserver:self.pullToRefreshView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToRefreshView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToRefreshView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];

            self.pullToRefreshView.isObserving = YES;
        }
    }
    else
    {
        if(self.pullToRefreshView.isObserving)
        {
            [self removeObserver:self.pullToRefreshView forKeyPath:@"contentOffset"];
            [self removeObserver:self.pullToRefreshView forKeyPath:@"contentSize"];
            [self removeObserver:self.pullToRefreshView forKeyPath:@"frame"];
            [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];

            self.pullToRefreshView.isObserving = NO;
        }
    }
}

- (void)setShowPullToLoadMore:(BOOL)showPullToLoadMore {
    self.pullToLoadMoreView.hidden = !showPullToLoadMore;
    
    if(showPullToLoadMore)
    {
        if(!self.pullToLoadMoreView.isObserving)
        {
            [self addObserver:self.pullToLoadMoreView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToLoadMoreView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToLoadMoreView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
            
            self.pullToLoadMoreView.isObserving = YES;
        }
    }
    else
    {
        if(self.pullToLoadMoreView.isObserving)
        {
            [self removeObserver:self.pullToLoadMoreView forKeyPath:@"contentOffset"];
            [self removeObserver:self.pullToLoadMoreView forKeyPath:@"contentSize"];
            [self removeObserver:self.pullToLoadMoreView forKeyPath:@"frame"];
            [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
            
            self.pullToLoadMoreView.isObserving = NO;
        }
    }
}

- (BOOL)showPullToRefresh
{
    return !self.pullToRefreshView.hidden;
}

- (BOOL)showPullToLoadMore
{
    return !self.pullToLoadMoreView.hidden;
}

- (void) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pullToRefreshView orientationChange:device.orientation];
     });
}

@end
