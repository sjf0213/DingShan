//
//  DSActivityIndicatorView.h
//  UzysCircularProgressPullToRefresh
//
//  Created by song jufeng on 15/11/10.
//  Copyright © 2015年 Uzysjung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSActivityIndicatorView : UIView

@property(nullable, nonatomic, strong)UIImage* image;

- (nonnull instancetype)initWithFrame:(CGRect)frame;
- (void)startAnimating;
- (void)stopAnimating;

@end
