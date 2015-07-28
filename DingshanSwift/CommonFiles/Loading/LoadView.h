//
//  LoadView.h
//  CoreFramework
//
//  Created by yingmin zhu on 13-4-11.
//  Copyright (c) 2013年 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadViewProtocol.h"

#define LoadStringPulling  @"松开即可加载..."
#define LoadStringNormal   @"上拉可以加载..."
#define LoadStringLoading  @"正在加载..."
#define LoadStringFailed    @"加载失败,点击重新加载"
#define LoadAnimationDuration 0.2f

@interface LoadView : UIView

@property(nonatomic,assign)id<LoadViewProtocol> delegate;
@property(nonatomic,assign)BOOL isCanUse;
@property(nonatomic,assign)UIEdgeInsets loadinsets;


- (void)setCurrentState:(LoadState)aState;

- (void)RefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)RefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
- (void)RefreshScrollViewDataSourceDidFinishedLoadingButFailed:(UIScrollView *)scrollView;
@end
