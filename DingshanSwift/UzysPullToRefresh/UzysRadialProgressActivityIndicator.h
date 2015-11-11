//
//  uzysRadialProgressActivityIndicator.h
//  UzysRadialProgressActivityIndicator
//
//  Created by Uzysjung on 13. 10. 22..
//  Copyright (c) 2013년 Uzysjung. All rights reserved.
//

#import <UIKit/UIKit.h>

#define StartPosition 5.0
#define PulltoRefreshThreshold 60.0

typedef void (^actionHandler)(void);
typedef NS_ENUM(NSUInteger, UZYSPullToRefreshState) {
    UZYSPullToRefreshStateNone =0,
    UZYSPullToRefreshStateStopped,
    UZYSPullToRefreshStateTriggering,
    UZYSPullToRefreshStateTriggered,
    UZYSPullToRefreshStateLoading,
    UZYSPullToRefreshStateCanFinish,
};


@interface UzysRadialProgressActivityIndicator : UIView

@property (nonatomic,assign) BOOL isObserving;

@property (nonatomic,assign) CGFloat originalTopInset;
@property (nonatomic,assign) CGFloat landscapeTopInset;
@property (nonatomic,assign) CGFloat portraitTopInset;

@property (nonatomic,assign) CGFloat originalBottomInset;
@property (nonatomic,assign) CGFloat landscapeBottomInset;
@property (nonatomic,assign) CGFloat portraitBottomInset;

@property (nonatomic,assign) UZYSPullToRefreshState state;
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,copy) actionHandler pullToRefreshHandler;

@property (nonatomic,strong) UIImage *imageIcon;
@property (nonatomic,strong) UIColor *borderColor;
@property (nonatomic,assign) CGFloat borderWidth;
@property (nonatomic,assign) CGFloat progressThreshold;

@property (nonatomic, assign) double progress;
- (void)stopIndicatorAnimation;
- (void)manuallyTriggered;

- (id)initWithImage:(UIImage *)image;
- (void)setSize:(CGSize) size;

- (void)orientationChange:(UIDeviceOrientation)orientation;
-(void)actionTriggeredState;
@end
