//
//  RefreshIconView.m
//  CoreUI
//
//  Created by xiong qi on 14-3-31.
//  Copyright (c) 2014年 xiong qi. All rights reserved.
//

#import "RefreshIconView.h"

@interface RefreshIconView()
@property(nonatomic,strong) UIImageView * icon1;
@property(nonatomic,strong) UIImageView * icon2;
@property(nonatomic,strong) UIImageView * icon3;
@property(nonatomic,strong) dispatch_source_t   timer;
@property(nonatomic,assign) int showindex;
@property(nonatomic,assign) BOOL animationing;
@end

@implementation RefreshIconView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _icon1 = [[UIImageView alloc] initWithFrame:CGRectMake(2, 0, 10, 10)];
        [self addSubview:_icon1];
        _icon1.image = [UIImage imageNamed:@"Refresh_Icon1_0"];
        
        _icon2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 12, 12)];
        [self addSubview:_icon2];
        _icon2.image = [UIImage imageNamed:@"Refresh_Icon2_0"];
        
        _icon3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 12, 12)];
        [self addSubview:_icon3];
        _icon3.image = [UIImage imageNamed:@"Refresh_Icon3_0"];
        
        
        __weak RefreshIconView * weakself = self;
        uint64_t interval = 0.2 * NSEC_PER_SEC;
        dispatch_queue_t timequeue = dispatch_queue_create("RefreshWatchQueue", 0);

        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, timequeue);
        
        dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
        
        dispatch_source_set_event_handler(_timer, ^()
        {
            if (weakself) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    [weakself showAnimation];
                });
            }
        });
    }
    return self;
}

-(void)showAnimation
{
    switch (self.showindex) {
        case 0:
            self.icon1.image = [UIImage imageNamed:@"Refresh_Icon1_1"];
            self.icon2.image = [UIImage imageNamed:@"Refresh_Icon2_0"];
            self.icon3.image = [UIImage imageNamed:@"Refresh_Icon3_0"];
            break;
        case 1:
            self.icon1.image = [UIImage imageNamed:@"Refresh_Icon1_0"];
            self.icon2.image = [UIImage imageNamed:@"Refresh_Icon2_1"];
            self.icon3.image = [UIImage imageNamed:@"Refresh_Icon3_0"];
            break;
        case 2:
            self.icon1.image = [UIImage imageNamed:@"Refresh_Icon1_0"];
            self.icon2.image = [UIImage imageNamed:@"Refresh_Icon2_0"];
            self.icon3.image = [UIImage imageNamed:@"Refresh_Icon3_1"];
            break;
        default:
            break;
    }
    self.showindex = (self.showindex+1)%3;
}

- (void)setProgress:(float)progress
{
    
    _icon1.hidden = YES;
    _icon2.hidden = YES;
    _icon3.hidden = YES;
    
    if (progress > 0) {
        _icon1.hidden = NO;
    }
    
    if (progress >= 0.5) {
        _icon2.hidden = NO;
    }
    
    if (progress >= 1) {
        _icon3.hidden = NO;
    }
}

- (void)startAnimating
{
    _icon1.hidden = NO;
    _icon2.hidden = NO;
    _icon3.hidden = NO;
    self.showindex = 0;
    
    if(!self.animationing)
    {
        dispatch_resume(_timer);
        self.animationing = YES;
    }
    
}

- (void)stopAnimating
{
    _icon1.hidden = YES;
    _icon2.hidden = YES;
    _icon3.hidden = YES;
    if (self.animationing) {
        dispatch_suspend(_timer);
        self.animationing = NO;
    }
    
    self.icon1.image = [UIImage imageNamed:@"Refresh_Icon1_0"];
    self.icon2.image = [UIImage imageNamed:@"Refresh_Icon2_0"];
    self.icon3.image = [UIImage imageNamed:@"Refresh_Icon3_0"];
}

-(void)dealloc
{
    if (!self.animationing) {
        dispatch_resume(_timer);
    }
    
    self.timer = nil;
}

@end
