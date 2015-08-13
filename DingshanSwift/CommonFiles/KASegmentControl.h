//
//  KASegmentControl.h
//  CoreUI
//
//  Created by yingmin zhu on 14-2-25.
//  Copyright (c) 2014年 xiong qi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KASegmentButton.h"

@interface KASegmentControl : UIControl
{
    NSArray* itemArray;
}

@property(nonatomic) NSInteger selectedSegmentIndex;// 如果 index < 0 则全部取消选中
@property(nonatomic,readonly) NSUInteger numberOfSegments;
@property(nonatomic, copy) void(^tapSegmentItemHandler)(NSInteger selectedIndex);

- (id)initWithFrame:(CGRect)frame withItems:(NSArray *)items withLightedColor:(UIColor*)color;
- (void)setTitle:(NSString *)title forIndex:(NSInteger)index;
@end
