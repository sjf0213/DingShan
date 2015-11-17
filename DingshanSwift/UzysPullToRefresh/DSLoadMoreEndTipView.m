//
//  DSLoadMoreEndTipView.m
//  UzysCircularProgressPullToRefresh
//
//  Created by song jufeng on 15/11/17.
//  Copyright © 2015年 Uzysjung. All rights reserved.
//

#import "DSLoadMoreEndTipView.h"
@interface DSLoadMoreEndTipView()
@property(nonatomic, strong)UILabel* title;
@end
@implementation DSLoadMoreEndTipView


-(nonnull instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.title = [[UILabel alloc] initWithFrame:self.bounds];
        self.title.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        self.title.text = @"End";
        [self addSubview:self.title];
    }
    return self;
}

-(void)setTipSize:(CGSize)sz
{
    self.title.frame = CGRectMake(0, 0, sz.width, sz.height);
    self.title.center = self.center;
}

-(void)layoutSubviews{
    
}
@end
