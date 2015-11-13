//
//  UIScrollView+UzysInteractiveIndicator.h
//  UzysRadialProgressActivityIndicator
//
//  Created by Uzysjung on 2013. 11. 12..
//  Copyright (c) 2013년 Uzysjung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UzysRadialProgressActivityIndicator.h"

@interface UIScrollView (UzysCircularProgressPullToRefresh)
@property (nonatomic,assign) BOOL showPullToRefresh;
@property (nonatomic,assign) BOOL showPullToLoadMore;
@property (nonatomic,strong,readonly) UzysRadialProgressActivityIndicator *pullToRefreshView;
@property (nonatomic,strong,readonly) UzysRadialProgressActivityIndicator *pullToLoadMoreView;

- (void)addPullToRefreshActionHandler:(actionHandler)handler;
- (void)addPullToLoadMoreActionHandler:(actionHandler)handler;
//For Orientation Changed
- (void)addTopInsetInPortrait:(CGFloat)pInset; // Should have called after addPullToRefreshActionHandler
- (void)addBottomInsetInPortrait:(CGFloat)pInset;

- (void)triggerPullToRefresh;
- (void)triggerPullToLoadMore;
- (void)stopRefreshAnimation;
- (void)stopLoadMoreAnimation;
@end
