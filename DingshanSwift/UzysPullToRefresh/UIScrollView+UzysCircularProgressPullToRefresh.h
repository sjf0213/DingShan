//
//  UIScrollView+UzysInteractiveIndicator.h
//  UzysRadialProgressActivityIndicator
//
//  Created by Uzysjung on 2013. 11. 12..
//  Copyright (c) 2013년 Uzysjung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UzysRadialProgressActivityIndicator.h"
#import "UzysRadialProgressActivityIndicatorA.h"
#import "UzysRadialProgressActivityIndicatorB.h"

@interface UIScrollView (UzysCircularProgressPullToRefresh)
@property (nonatomic,assign) BOOL showPullToRefresh;
@property (nonatomic,assign) BOOL showPullToLoadMore;
@property (nonatomic,strong,readonly) UzysRadialProgressActivityIndicatorA *pullToRefreshView;
@property (nonatomic,strong,readonly) UzysRadialProgressActivityIndicatorB *pullToLoadMoreView;

- (void)addPullToRefreshActionHandler:(actionHandler)handler;
- (void)addPullToLoadMoreActionHandler:(actionHandler)handler;
- (void)addPullToRefreshActionHandler:(actionHandler)handler portraitContentInsetTop:(CGFloat)pInsetTop landscapeInsetTop:(CGFloat)lInsetTop;
- (void)addPullToLoadMoreActionHandler:(actionHandler)handler portraitContentInsetBottom:(CGFloat)pInsetBottom landscapeInsetBottom:(CGFloat)lInsetBottom;
//For Orientation Changed
- (void)addTopInsetInPortrait:(CGFloat)pInset TopInsetInLandscape:(CGFloat)lInset; // Should have called after addPullToRefreshActionHandler

- (void)triggerPullToRefresh;
- (void)stopRefreshAnimation;
@end
