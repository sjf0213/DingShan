//
//  ScrollContainerView.h
//  CoreUI
//
//  Created by song jufeng on 14-3-13.
//  Copyright (c) 2014年 xiong qi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScrollShowView.h"

typedef enum {
    NoRequest       = 1,//没有发出数据请求
    LoadRequest     = 2,//已经发出请求，正在等待响应
    RequestError    = 3,//请求数据错误，下次继续请求
    NoData          = 4,//已经没有数据了，以后不再请求
}RequestState;

@interface ScrollContainerView : UIView<UIScrollViewDelegate>
{
    UIScrollView * scrollview;//添加进来的视图必须实现ScrollContainerDelegate委托
    
    BOOL isFirstEnter;//是否第一次进入程序
    NSUInteger width;//视口宽
    NSUInteger height;//视口高
    NSUInteger viewwidth;//视图宽
    NSUInteger viewheight;//视图宽
    NSUInteger viewCount;//总视图个数
    
    CGPoint waitForMovePoint;//视图等待移动到的位置
    ScrollShowView * waitForMoveView;//等待移动的视图
}
@property(nonatomic, readwrite)NSInteger totalShowCount;
@property(nonatomic, readwrite)NSInteger currentShowNumber;
@property (atomic, readonly) NSMutableArray    *datasource;
@property(nonatomic, copy) void (^tapSubmitHandler)(NSString *imageUrlString, NSInteger articleid, CGPoint relativeTouchPoint, NSString *commentText);

- (UIView*)getCurrentShowView;
- (id)initWithFrame:(CGRect)frame commentEnabeld:(BOOL)commentEnabeld;
- (void)AddDataSourceByArray:(NSArray *)array replyInfo:(NSArray *)replyInfo;
- (void)AddDataSourceByArray:(NSArray *)array replyInfo:(NSArray *)replyInfo articleId:(NSInteger)article_id withMaxCommentCount:(NSInteger)max;
- (void)UpdateDataSourceByArray:(NSArray *)array;
- (void)MoveViewByOffset:(NSInteger)offset;
@end
