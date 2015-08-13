//
//  KASegmentButton.m
//  CoreUI
//
//  Created by yingmin zhu on 14-2-25.
//  Copyright (c) 2014年 xiong qi. All rights reserved.
//

#import "KASegmentButton.h"

@implementation KASegmentButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
}

-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted)
    {
        if (self.selected == NO)
        {
            CGFloat r, g, b, a;
            [_selectedColor getRed:&r green:&g blue:&b alpha:&a];
            [self setTitleColor:_selectedColor forState:UIControlStateNormal];
            self.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:0.2];
        }
    }
    else
    {
        if (self.selected == NO)
        {
            [self setTitleColor:_selectedColor forState:UIControlStateNormal];
            self.backgroundColor = [UIColor whiteColor];
        }
        else
        {
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.backgroundColor = _selectedColor;
        }
    }
}


-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected)
    {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.backgroundColor = _selectedColor;
    }
    else
    {
        [self setTitleColor:_selectedColor forState:UIControlStateNormal];
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
