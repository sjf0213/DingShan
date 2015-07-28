//
//  LoadViewProtocol.h
//  CoreFramework
//
//  Created by yingmin zhu on 13-4-11.
//  Copyright (c) 2013年 appfactory. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
	LoadPulling = 0,
	LoadNormal,
	LoadLoading,
    LoadFailed,
}LoadState;

@protocol LoadViewProtocol <NSObject>

@optional

-(UIScrollView*)scrollView;
//开始刷新数据
-(void)BeginRefreshData:(UIView *)view;
//开始加载数据
-(void)BeginLoadingData:(UIView *)view;
//得到加载数据完成，但是加载失败了
-(void)FinishedLoadingDataButFailed;
@end
