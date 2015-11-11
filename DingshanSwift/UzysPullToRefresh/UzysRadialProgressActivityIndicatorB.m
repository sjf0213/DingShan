//
//  UzysRadialProgressActivityIndicatorB.m
//  UzysCircularProgressPullToRefresh
//
//  Created by song jufeng on 15/11/10.
//  Copyright © 2015年 Uzysjung. All rights reserved.
//

#import "UzysRadialProgressActivityIndicatorB.h"

@implementation UzysRadialProgressActivityIndicatorB


- (void)scrollViewDidScroll:(CGPoint)contentOffset
{
    static double prevProgress;
    CGFloat yOffset = contentOffset.y;
    CGFloat ll = self.scrollView.contentSize.height-self.scrollView.frame.size.height;
    
    self.progress = (MAX((yOffset  - ll), 0) / self.progressThreshold);
    NSLog(@"B- - - - yOffset = %.1f, ll = %.1f,  _state = %zd, self.progress = %.2f", yOffset, ll, self.state, self.progress);
    
    self.center = CGPointMake(self.center.x,  self.scrollView.contentSize.height + self.scrollView.contentInset.top * 0.5);
    NSLog(@"B-------yOffset = %.1f, self.frame = (%.1f, %.1f)(%.1f, %.1f),",yOffset, self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    switch (self.state) {
        case UZYSPullToRefreshStateStopped: //finish
            break;
        case UZYSPullToRefreshStateNone: //detect action
        {
//            NSLog(@"None:yOffset = %.1f, to contentH = %.1f, frameH = %.1f", yOffset, self.scrollView.contentSize.height, self.scrollView.frame.size.height);
            
            if (self.scrollView.isDragging && yOffset > self.scrollView.contentSize.height-self.scrollView.frame.size.height)
            {
                NSLog(@"B-------UZYSPullToRefreshStateTriggering");
                self.state = UZYSPullToRefreshStateTriggering;
            }
        }
        case UZYSPullToRefreshStateTriggering: //progress
        {
            if(self.progress >= 1.0)
                self.state = UZYSPullToRefreshStateTriggered;
        }
            break;
        case UZYSPullToRefreshStateTriggered: //fire actionhandler
            if(self.scrollView.dragging == NO && prevProgress > 0.99)
            {
                [self actionTriggeredState];
            }
            break;
        case UZYSPullToRefreshStateLoading: //wait until stopIndicatorAnimation
            break;
        case UZYSPullToRefreshStateCanFinish:
            if(self.progress < 0.01 + ((CGFloat)StartPosition/-self.progressThreshold) && self.progress > -0.01 +((CGFloat)StartPosition/-self.progressThreshold))
            {
                self.state = UZYSPullToRefreshStateNone;
            }
            
            break;
        default:
            break;
    }
    prevProgress = self.progress;
    
}

- (void)setProgressThreshold:(CGFloat)progressThreshold
{
    [super setProgressThreshold:progressThreshold];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.size.height-self.progressThreshold, self.frame.size.width, self.frame.size.height);
}
@end
