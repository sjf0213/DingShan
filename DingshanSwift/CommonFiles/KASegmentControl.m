//
//  KASegmentControl.m
//  CoreUI
//
//  Created by yingmin zhu on 14-2-25.
//  Copyright (c) 2014年 xiong qi. All rights reserved.
//

#import "KASegmentControl.h"


@interface KASegmentControl ()
@property (nonatomic) NSMutableArray *buttons;
@end

@implementation KASegmentControl

- (id)initWithFrame:(CGRect)frame withItems:(NSArray *)items withLightedColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = color;
        self.layer.cornerRadius = 3;
        self.clipsToBounds = YES;
        
        self.buttons = [NSMutableArray array];
        
        itemArray = items;
        UIView* innerView = [[UIView alloc] initWithFrame:CGRectMake(1, 1,
                                                                     self.frame.size.width-2, self.frame.size.height-2)];
        innerView.clipsToBounds = YES;
        innerView.layer.cornerRadius = 3;
        innerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:innerView];
        
        if (items.count > 0)
        {
            _numberOfSegments = items.count;
            if ([items[0] isKindOfClass:[NSString class]])
            {
                for (int i = 0; i < _numberOfSegments; i++)
                {
                    NSString* itemText = items[i];
                    KASegmentButton* btn = [[KASegmentButton alloc] initWithFrame:CGRectMake(i * innerView.frame.size.width/_numberOfSegments,
                                                                                                   0,
                                                                                                   innerView.frame.size.width/_numberOfSegments,
                                                                                                   innerView.frame.size.height)];
                    btn.selectedColor = color;
                    [btn setTitle:itemText forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:12];
                    btn.tag = i;
                    [btn addTarget:self action:@selector(onButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
                    [self.buttons addObject:btn];
                    [innerView addSubview:btn];
                }
                for (int i = 0; i < _numberOfSegments - 1; i++)
                {
                    
                    UIView* seperationLine = [[UIView alloc] initWithFrame:CGRectMake((i+1) * (innerView.frame.size.width/_numberOfSegments)-1, 0,
                                                                                      1, innerView.frame.size.height)];
                    seperationLine.backgroundColor = color;
                    [innerView addSubview:seperationLine];
                    
                }
            }
        }
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self layoutSubviews];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
}

-(void)onButtonSelected:(id)sender
{
    KASegmentButton* btn = (KASegmentButton*)sender;
    [self setIndex:btn.tag];
    self.selectedSegmentIndex = btn.tag;
    if (self.tapSegmentItemHandler) {
        self.tapSegmentItemHandler(self.selectedSegmentIndex);
    }
}

-(void)setSelectedSegmentIndex:(NSInteger)index
{
    _selectedSegmentIndex = index;
    [self setIndex:index];
}

-(void)setIndex:(NSInteger)index
{
    if (index >= 0)
    {
        if (self.subviews.count > 0)
        {
            UIView* container = self.subviews[0];
            for (int i = 0; i < container.subviews.count; i++)
            {
                UIView* v = container.subviews[i];
                if ([v isKindOfClass:[KASegmentButton class]])
                {
                    if (v.tag == index)
                    {
                        [(KASegmentButton*)v setSelected:YES];
                    }
                    else
                    {
                        [(KASegmentButton*)v setSelected:NO];
                    }
                }
            }
        }
    }
    else // 如果 index < 0 则全部取消选中
    {
        if (self.subviews.count > 0)
        {
            UIView* container = self.subviews[0];
            for (int i = 0; i < container.subviews.count; i++)
            {
                UIView* v = container.subviews[i];
                if ([v isKindOfClass:[KASegmentButton class]])
                {
                    [(KASegmentButton*)v setSelected:NO];
                }
            }
        }
    }
}

#pragma mark -
- (void)setTitle:(NSString *)title forIndex:(NSInteger)index {
    if (index < [self.buttons count]) {
        KASegmentButton *button = [self.buttons objectAtIndex:index];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateSelected];
    }
}

@end
