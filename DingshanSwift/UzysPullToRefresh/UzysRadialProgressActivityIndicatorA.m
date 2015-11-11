//
//  UzysRadialProgressActivityIndicatorA.m
//  UzysCircularProgressPullToRefresh
//
//  Created by song jufeng on 15/11/10.
//  Copyright © 2015年 Uzysjung. All rights reserved.
//

#import "UzysRadialProgressActivityIndicatorA.h"

@implementation UzysRadialProgressActivityIndicatorA

- (void)scrollViewDidScroll:(CGPoint)contentOffset
{
    static double prevProgress;
    CGFloat yOffset = contentOffset.y;
//    NSLog(@"A- - - - yOffset = %.1f, _state = %zd", yOffset, self.state);
    self.progress = ((yOffset + self.originalTopInset + StartPosition)/-self.progressThreshold);
    self.center = CGPointMake(self.center.x, (contentOffset.y+ self.originalTopInset)/2);
//    self.center = CGPointMake(self.center.x, self.scrollView.contentSize.height);
    NSLog(@"A-------yOffset = %.1f,self.frame = (%.1f, %.1f)(%.1f, %.1f)",yOffset, self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    
    switch (self.state) {
        case UZYSPullToRefreshStateStopped: //finish
            break;
        case UZYSPullToRefreshStateNone: //detect action
        {
            if(self.scrollView.isDragging && yOffset <0 )
            {
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
    self.frame = CGRectMake(self.frame.origin.x, self.progressThreshold, self.frame.size.width, self.frame.size.height);
}
@end
