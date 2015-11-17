//
//  AsynRequestImageView.h
//  PhotoListBrowseController
//
//  Created by xiong qi on 12-11-14.
//  Copyright (c) 2012年 xiong qi. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "../../SDWebImage/SDWebImageManager.h"
@interface AsynRequestImageView : UIImageView
{
    UIImageView    * borderView;
    UIImageView    * barView;
    UIImageView    * defaultView;
}
-(id)initWithFrame:(CGRect)frame;
-(void)reset;
-(void)loadImageFromURL:(NSString *)url;
-(void)cancel;
@end
