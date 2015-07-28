//
//  RefurbishView.h
//  CoreFramework
//
//  Created by yingmin zhu on 13-4-11.
//  Copyright (c) 2013年 appfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadViewProtocol.h"

#define StringPulling  @"松开即可刷新"
#define StringNormal   @"下拉可以刷新"
#define StringLoading  @"努力加载中"
#define AnimationDuration 0.2f
#define LastUpdataTime @"上次刷新:"

@interface RefreshView : UIView

@property(nonatomic,weak)NSObject<LoadViewProtocol> * delegate;
@property(nonatomic,assign)BOOL isCanUse;
@property(nonatomic,assign)BOOL isLoading;
@property(nonatomic,assign)UIEdgeInsets loadinsets;

- (void)RefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)RefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)RefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
- (void)RefreshScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

- (void)refreshLastUpdatedDate;
- (void)showRefreshWithScrollView:(UIScrollView *)scrollView;

@end
