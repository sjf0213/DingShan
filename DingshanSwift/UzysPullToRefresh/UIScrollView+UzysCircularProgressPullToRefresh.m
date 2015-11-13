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

- (void)addPullToRefreshActionHandler:(actionHandler)handler{
    if(self.pullToRefreshView == nil){
        UzysRadialProgressActivityIndicator *view = [[UzysRadialProgressActivityIndicator alloc] initWithImage:[UIImage imageNamed:@"refresh_center_icon"]];
        view.pullToRefreshHandler = handler;
        view.posType = indicator_top;
        view.backgroundColor = [[UIColor cyanColor] colorWithAlphaComponent:0.5];
        view.scrollView = self;
        view.frame = CGRectMake((self.bounds.size.width - view.frame.size.width)/2,
                                -view.frame.size.height, view.frame.size.width, view.frame.size.height);
        view.originalTopInset = self.contentInset.top;
        view.originalTopInset = 0.0;
        
        [self addSubview:view];
        [self sendSubviewToBack:view];
        self.pullToRefreshView = view;
        self.showPullToRefresh = YES;
        NSLog(@"A_DONE------- self.frame = (%.1f, %.1f)(%.1f, %.1f),", view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    }
}

- (void)addPullToLoadMoreActionHandler:(actionHandler)handler{
    if(self.pullToLoadMoreView == nil){
        UzysRadialProgressActivityIndicator *view = [[UzysRadialProgressActivityIndicator alloc] initWithImage:[UIImage imageNamed:@"refresh_center_icon"]];
        view.posType = indicator_bottom;
        view.pullToRefreshHandler = handler;
        view.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.5];
        view.scrollView = self;
        view.frame = CGRectMake((self.bounds.size.width - view.bounds.size.width)/2,
                                -view.bounds.size.height, view.bounds.size.width, view.bounds.size.height);
        view.originalBottomInset = self.contentInset.bottom;
        view.originalBottomInset = 0.0;
        
        [self addSubview:view];
        [self sendSubviewToBack:view];
        self.pullToLoadMoreView = view;
        self.showPullToLoadMore = YES;
        NSLog(@"B_DONE------- self.frame = (%.1f, %.1f)(%.1f, %.1f),", view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);

    }
}

- (void)triggerPullToRefresh{
    [self.pullToRefreshView manuallyTriggered];
}

- (void)triggerPullToLoadMore{
    [self.pullToLoadMoreView manuallyTriggered];
}

- (void)stopRefreshAnimation{
    [self.pullToRefreshView stopIndicatorAnimation];
}

- (void)stopLoadMoreAnimation{
    [self.pullToLoadMoreView stopIndicatorAnimation];
}
#pragma mark - property
- (void)addTopInsetInPortrait:(CGFloat)pInset{
    self.pullToRefreshView.originalTopInset = pInset;
}

- (void)addBottomInsetInPortrait:(CGFloat)pInset{
    self.pullToLoadMoreView.originalBottomInset = pInset;
}

- (void)setPullToRefreshView:(UzysRadialProgressActivityIndicator *)pullToRefreshView{
    [self willChangeValueForKey:@"UzysRadialProgressActivityIndicatorTop"];
    objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView, pullToRefreshView, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"UzysRadialProgressActivityIndicatorTop"];
}

- (void)setPullToLoadMoreView:(UzysRadialProgressActivityIndicator *)pullToLoadMoreView{
    [self willChangeValueForKey:@"UzysRadialProgressActivityIndicatorBottom"];
    objc_setAssociatedObject(self, &UIScrollViewPullToLoadMoreView, pullToLoadMoreView, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"UzysRadialProgressActivityIndicatorBottom"];
}

- (UzysRadialProgressActivityIndicator *)pullToRefreshView{
    return objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView);
}

- (UzysRadialProgressActivityIndicator *)pullToLoadMoreView{
    return objc_getAssociatedObject(self, &UIScrollViewPullToLoadMoreView);
}

- (void)setShowPullToRefresh:(BOOL)showPullToRefresh {
    self.pullToRefreshView.hidden = !showPullToRefresh;
    
    if(showPullToRefresh){
        if(!self.pullToRefreshView.isObserving){
            [self addObserver:self.pullToRefreshView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToRefreshView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToRefreshView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
            self.pullToRefreshView.isObserving = YES;
        }
    }else{
        if(self.pullToRefreshView.isObserving){
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
    
    if(showPullToLoadMore){
        if(!self.pullToLoadMoreView.isObserving){
            [self addObserver:self.pullToLoadMoreView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToLoadMoreView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToLoadMoreView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
            
            self.pullToLoadMoreView.isObserving = YES;
        }
    }else{
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

- (BOOL)showPullToRefresh{
    return !self.pullToRefreshView.hidden;
}

- (BOOL)showPullToLoadMore{
    return !self.pullToLoadMoreView.hidden;
}

@end
