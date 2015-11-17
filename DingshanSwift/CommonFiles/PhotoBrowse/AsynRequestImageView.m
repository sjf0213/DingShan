//
//  AsynRequestImageView.m
//  PhotoListBrowseController
//
//  Created by xiong qi on 12-11-14.
//  Copyright (c) 2012年 xiong qi. All rights reserved.
//

#import "AsynRequestImageView.h"
#import "../../SDWebImage/UIImageView+WebCache.h"

#define NEWS_IMAGE_TIMEOUT 15
#define ProgressBarMarginLeft       1.0
#define ProgressBarMarginTop        1.0

@implementation AsynRequestImageView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        defaultView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 100)];
        defaultView.contentMode = UIViewContentModeCenter;
        defaultView.image = [UIImage imageNamed:@"phone_img_default"];
        [self addSubview:defaultView];
        
        borderView = [[UIImageView alloc] init];
        borderView.backgroundColor = [UIColor whiteColor];
        borderView.clipsToBounds = YES;
        [self addSubview:borderView];

        barView = [[UIImageView alloc] init];
        barView.backgroundColor = [UIColor grayColor];
        barView.clipsToBounds = YES;
        [self addSubview:barView];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            borderView.frame = CGRectMake((frame.size.width-180)/2, (frame.size.height+100)/2, 180, 10);
            barView.frame = CGRectMake(borderView.frame.origin.x+ProgressBarMarginLeft,
                                       borderView.frame.origin.y+ProgressBarMarginTop,
                                       0,
                                       borderView.frame.size.height-2*ProgressBarMarginTop);
            borderView.layer.cornerRadius = 5.0;
            barView.layer.cornerRadius = 4.0;
        }
        else
        {
            borderView.frame = CGRectMake((frame.size.width-180)/2, (frame.size.height+100)/2, 180, 10);
            barView.frame = CGRectMake(borderView.frame.origin.x+ProgressBarMarginLeft,
                                       borderView.frame.origin.y+ProgressBarMarginTop,
                                       0,
                                       borderView.frame.size.height-2*ProgressBarMarginTop);
            borderView.layer.cornerRadius = 5.0;
            barView.layer.cornerRadius = 4.0;
        }
    }
    return self;
}

-(void)reset
{
    barView.frame = CGRectMake(barView.frame.origin.x,
                               barView.frame.origin.y,
                               0,
                               barView.frame.size.height);
    barView.hidden = NO;
    borderView.hidden = NO;
    defaultView.hidden = NO;
}

-(void)loadImageFinish
{
    barView.hidden = YES;
    borderView.hidden = YES;
    defaultView.hidden = YES;
}

-(void)setProgress:(double)progress
{
    barView.frame = CGRectMake(barView.frame.origin.x,
                               barView.frame.origin.y,
                               (borderView.frame.size.width-2*ProgressBarMarginLeft)*progress,
                               barView.frame.size.height);
}

-(void)loadImageFromURL:(NSString *)url
{
    __weak typeof(self) weakSelf = self;
    [self sd_setImageWithURL:[NSURL URLWithString:url]
         placeholderImage:nil
                  options:0//TODO: 这个参数还没研究@chenms
                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                     double progress = (double)receivedSize/expectedSize;
                     [weakSelf setProgress:progress];
                 } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL * url) {
                     [weakSelf loadImageFinish];
                 }];
}

-(void)cancel
{
     [self sd_cancelCurrentImageLoad];
}

@end
