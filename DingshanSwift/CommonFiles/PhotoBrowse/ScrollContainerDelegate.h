//
//  ScrollContainerDelegate.h
//  CustomScrollView
//
//  Created by xiong qi on 12-7-3.
//  Copyright (c) 2012年 AppFactory. All rights reserved.
//

#import <Foundation/Foundation.h>

//视图需要实现的委托
@protocol ScrollContainerDelegate <NSObject>

@optional
- (void)AddShowCount;
- (void)SaveToAlbum;
- (void)SaveToAlbum:(UIView*)tipView;
@required
- (void)RefreshByData:(NSObject *)obj;
- (void)ClearView;
- (void)RevertScale;

@end
