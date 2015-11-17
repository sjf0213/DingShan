//
//  ScrollShowView.h
//  PhotoListBrowseController
//
//  Created by xiong qi on 12-10-25.
//  Copyright (c) 2012年 xiong qi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollContainerDelegate.h"

#define kSCVContentTextKey          @"kSCVContentTextKey"
#define kSCVContentRelativeXKey     @"kSCVContentRelativeXKey"
#define kSCVContentRelativeYKey     @"kSCVContentRelativeYKey"

@interface ScrollShowView : UIView<ScrollContainerDelegate>
@property (nonatomic, readonly) CGPoint curRelativeTouchPoint;
@property (nonatomic, readonly) NSString *curImageUrlString;
@property (nonatomic, readonly) CGPoint curTouchPoint;
@property (nonatomic, copy) void (^tapShowTextInputHandler)(ScrollShowView *sender);
- (void)RefreshByData:(NSObject *)obj replys:(NSMutableArray *)replys withMaxCount:(NSInteger)maxDicplayCount;
- (void)ClearView;
- (void)RevertScale;
@end
