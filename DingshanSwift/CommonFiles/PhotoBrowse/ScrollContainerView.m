//
//  ScrollContainerView.m
//  CoreUI
//
//  Created by song jufeng on 14-3-13.
//  Copyright (c) 2014年 xiong qi. All rights reserved.
//

#import "ScrollContainerView.h"
#import "ScrollShowView.h"

#define spacetop  0//10
#define spaceleft 0//12

@interface ScrollContainerView ()<UITextFieldDelegate>
@property (atomic) NSMutableArray    *views;
@property (atomic) NSMutableArray    *datasource;
@property (nonatomic) NSInteger         currentPageNumber;
@property (nonatomic) NSInteger         RequestSpace;
@property (nonatomic) RequestState      state;
@property (nonatomic) UIView            *coverView;
@property (nonatomic) CGRect            keyboardFrame;
@property (nonatomic) NSTimeInterval    keyboardAnimationDuration;
@property (nonatomic) ScrollShowView    *curScrollShowView;
@property (nonatomic) BOOL              isShowingCover;
@property (nonatomic) NSMutableArray    *replyDicts;
@property (nonatomic) NSInteger photoAlbumArticleId;
@end

@implementation ScrollContainerView
{
    NSInteger maxCommentDisplayCount;
}
- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame commentEnabeld:NO];
}
- (id)initWithFrame:(CGRect)frame commentEnabeld:(BOOL)commentEnabeld {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;
        
        _views = [NSMutableArray new];
        _datasource = [NSMutableArray array];
    
        __weak typeof(self) weakSelf = self;
        
        
        
        
        // 图片区
        for (int i=0; i<3;i++)
        {
            ScrollShowView * tempview = [[ScrollShowView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
            tempview.tapShowTextInputHandler = ^(ScrollShowView *sender){
                weakSelf.curScrollShowView = sender;
            };
            [self.views addObject:tempview];
        }
        
        self.currentPageNumber = 0;
        isFirstEnter = YES;
        waitForMoveView = nil;
        self.state = NoRequest;
        
        width = frame.size.width;
        height = frame.size.height;
        viewwidth = frame.size.width-2*spaceleft;
        viewheight = frame.size.height-2*spacetop;
        viewCount = [self.views count];
        
        
        scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [self addSubview:scrollview];
        scrollview.backgroundColor = [UIColor blackColor];
        scrollview.pagingEnabled = YES;
        scrollview.exclusiveTouch = YES;
        scrollview.showsHorizontalScrollIndicator = NO;
        scrollview.showsVerticalScrollIndicator   = NO;
        scrollview.delegate = self;
        
        for (int i=0; i<viewCount;i++) {
            UIView * tempview = (UIView *)[self.views objectAtIndex:i];
            tempview.tag = i+100;
            tempview.frame = CGRectMake(width * (i-viewCount/2) + spaceleft, spacetop, viewwidth, viewheight);
            [scrollview addSubview:tempview];
        }
        
        // 图片评论相关
        if (commentEnabeld) {
            // 遮罩
            _coverView = [[UIView alloc] initWithFrame:self.bounds];
            _coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
            _coverView.hidden = YES;
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapCover)];
            [_coverView addGestureRecognizer:tapRecognizer];
            [self addSubview:_coverView];
            
            // 调整view次序
            [self bringSubviewToFront:scrollview];
            [self bringSubviewToFront:_coverView];
            

        }
    }
    
    return self;
}

-(void)MoveViewByOffset:(NSInteger)offset
{
    //需要移动到第几个视图
    self.currentPageNumber = offset;
    scrollview.contentOffset = CGPointMake(offset*scrollview.frame.size.width, 0);
    for (int i=0; i<viewCount; i++) {
        ScrollShowView * tempview = [self.views objectAtIndex:i];
        NSInteger index =i+offset-viewCount/2;
        tempview.frame = CGRectMake(width * index + spaceleft, spacetop, viewwidth, viewheight);
        if (index<0) {
            tempview.hidden = YES;
        }
        else if(index>=[self.datasource count])
        {
            tempview.hidden = YES;
        }
        else {
            tempview.hidden = NO;
            if (index < self.datasource.count) {
                NSString *imageUrlString = [self.datasource objectAtIndex:index];
                NSMutableArray *replys = [self imageReplysForImageUrlString:imageUrlString replyDicts:self.replyDicts];
                [tempview RefreshByData:imageUrlString replys:replys withMaxCount:maxCommentDisplayCount];
            }
        }
    }
    self.currentShowNumber = self.currentPageNumber + 1;
}

#pragma mark - 加载数据
//
- (void)AddDataSourceByArray:(NSArray *)array replyInfo:(NSArray *)replyInfo
{
    [self AddDataSourceByArray:array replyInfo:replyInfo articleId:0 withMaxCommentCount:NSIntegerMax];
}
// 只有美图加评论功能需要在展示图片时候传给article_id
- (void)AddDataSourceByArray:(NSArray *)array replyInfo:(NSArray *)replyInfo articleId:(NSInteger)article_id withMaxCommentCount:(NSInteger)max
{
    NSLog(@"AddDataSourceByArray-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+replyCount = %zd, dispalyMax = %zd", replyInfo.count, max);
    maxCommentDisplayCount = max;
    self.photoAlbumArticleId = article_id;
    if (array != nil && [array count]>0) {
        //第一次进入页面时刷新各视图
        if (isFirstEnter) {
            isFirstEnter = NO;
            
            // 将评论数据模型处理为可写，为之后添加评论做准备
            [self.replyDicts removeAllObjects];
            [replyInfo enumerateObjectsUsingBlock:^(NSDictionary *srcReplyListDict, NSUInteger idx, BOOL *stop) {
                NSMutableDictionary *mutableReplyListDict = [NSMutableDictionary dictionaryWithDictionary:srcReplyListDict];
                NSArray *replyList = [mutableReplyListDict objectForKey:@"reply_list"];
                NSMutableArray *mutableReplyList = [NSMutableArray array];
                [replyList enumerateObjectsUsingBlock:^(NSDictionary *reply, NSUInteger idx, BOOL *stop) {
                    if ([reply isKindOfClass:[NSDictionary class]] && reply.count > 0) {
                        NSMutableDictionary *mutableReplyDict = [NSMutableDictionary dictionaryWithDictionary:reply];
                        NSString *jsonString = [mutableReplyDict objectForKey:@"reply_content"];
                        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
                        if (dict) {
                            [mutableReplyDict setObject:dict forKey:@"reply_content"];
                        } else {
                            [mutableReplyDict removeObjectForKey:@"reply_content"];
                        }
                        [mutableReplyList addObject:mutableReplyDict];
                    }
                }];
                [mutableReplyListDict setObject:mutableReplyList forKey:@"reply_list"];
                [self.replyDicts addObject:mutableReplyListDict];
            }];
            
            //刷新所有页面
            for (int i=0; i<viewCount;i++) {
                ScrollShowView * tempview = [self.views objectAtIndex:i];
                NSInteger index = i-viewCount/2;
                if(index<0||index>=[array count])
                {
                    tempview.hidden = YES;
                    continue;
                }
                
                if (index < array.count) {
//                    int index = i-viewCount/2;
                    NSString *imageUrlString = [array objectAtIndex:index];
                    NSMutableArray *imageReplys = [self imageReplysForImageUrlString:imageUrlString replyDicts:self.replyDicts];
//                    DLog(@"+++++++++++++++++++++++++++imageReplys = %zd", imageReplys.count);
                    [tempview RefreshByData:[array objectAtIndex:index] replys:imageReplys withMaxCount:max];
                }
            }
        }
        
        
        // 重新赋值图片集合
        [self.datasource removeAllObjects];
        [self.datasource addObjectsFromArray:array];
        
        self.totalShowCount = [self.datasource count];
    }
    
    self.state = NoData;
    scrollview.contentSize = CGSizeMake(self.datasource.count * width, height);
    //pagelabel.text =[NSString stringWithFormat:@"%d / %d",currentPageNumber+1,datasource.count];
    self.currentShowNumber = self.currentPageNumber + 1;
}

-(void)UpdateDataSourceByArray:(NSArray *)array
{
    if (array != nil && [array count]>0) {
        NSString* currentImgURL = [self.datasource objectAtIndex:self.currentPageNumber];
        // 重新赋值图片集合
        [self.datasource removeAllObjects];
        [self.datasource addObjectsFromArray:array];
        
        self.totalShowCount = [self.datasource count];
        self.state = NoData;
        scrollview.contentSize = CGSizeMake(self.datasource.count * width, height);
        
        // 取得当前显示图片的URL, 并查找其在新图片集中的index
        NSInteger newindex = -1;
        if (self.datasource.count > 0 && self.currentPageNumber >= 0)
        {
            for (int i = 0; i < array.count; i++)
            {
                NSString* item = array[i];
                if ([item isKindOfClass:[NSString class]]) {
                    if ([item isEqualToString:currentImgURL])
                    {
                        newindex = i;
                        [self MoveViewByOffset:newindex];
                        break;
                    }
                }
            }
        }
    }
    
    
}


#pragma mark -
-(void)RefreshView:(int)type
{
    //DLog(@"RefreshView-+-+-+");
    if (self.currentPageNumber<0||self.currentPageNumber>[self.datasource count]) {
        return;
    }
    
    NSInteger index = 0;
    ScrollShowView * scaleview;
    switch (type) {
        case 1:
            //需要将视图移动到哪个索引位置
            index = self.currentPageNumber+viewCount/2;
            
            if (self.views.count > 0)
            {
                waitForMoveView = [self.views objectAtIndex:0];
                [self.views addObject:waitForMoveView];
                [self.views removeObjectAtIndex:0];
                if (index>=[self.datasource count]) {
                    waitForMoveView.hidden = YES;
                    [waitForMoveView ClearView];
                }
                else {
                    if (index < self.datasource.count) {
                        waitForMoveView.hidden = NO;
                        NSString *imageUrlString = [self.datasource objectAtIndex:index];
                        NSMutableArray *imageReplys = [self imageReplysForImageUrlString:imageUrlString replyDicts:self.replyDicts];
                        [waitForMoveView RefreshByData:[self.datasource objectAtIndex:index] replys:imageReplys withMaxCount:maxCommentDisplayCount];
                    }
                }
                scaleview = [self.views objectAtIndex:0];
                [scaleview RevertScale];
            }
            break;
        case -1:
            index = self.currentPageNumber-1;
            
            waitForMoveView = [self.views objectAtIndex:viewCount-1];
            [self.views insertObject:waitForMoveView atIndex:0];
            [self.views removeLastObject];
            
            if (index<0) {
                waitForMoveView.hidden = YES;
                [waitForMoveView ClearView];
            }
            else {
                if (index < self.datasource.count) {
                    waitForMoveView.hidden = NO;
                    NSString *imageUrlString = [self.datasource objectAtIndex:index];
                    NSMutableArray *imageReplys = [self imageReplysForImageUrlString:imageUrlString replyDicts:self.replyDicts];
                    [waitForMoveView RefreshByData:imageUrlString replys:imageReplys withMaxCount:maxCommentDisplayCount];
                }
            }
            scaleview = [self.views objectAtIndex:(viewCount -1)];
            [scaleview RevertScale];
            break;
        default:
            break;
    }
    waitForMovePoint = CGPointMake(width * index +width/2, height/2);
    waitForMoveView.center = waitForMovePoint;
    self.currentShowNumber = self.currentPageNumber + 1;
}

- (UIView*)getCurrentShowView
{
    return [self.views objectAtIndex:viewCount/2];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    //当前是第几页
    int _page = (scrollview.contentOffset.x+width/2)/width;
    
    if (_page == self.currentPageNumber+1) {
        //右移
        self.currentPageNumber = _page;
        [self RefreshView:1];
    }
    else if(_page == self.currentPageNumber-1)
    {
        //左移
        self.currentPageNumber = _page;
        [self RefreshView:-1];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate) {
        scrollview.scrollEnabled = NO;
    }
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    scrollview.scrollEnabled = YES;
    UIView * currentview = [self.views objectAtIndex:((int)viewCount/2)];
    //容错处理，产生原因可能是当内存消耗过大时，导致某些方法没调用，视图显示不正确。
    if ((width * self.currentPageNumber +width/2) != currentview.center.x) {
        [self MoveViewByOffset:self.currentPageNumber];
    }
    
}

#pragma mark - 输入时遮罩
- (void)showCover {
    if (self.isShowingCover) {
        return;
    }
    self.isShowingCover = YES;
    self.coverView.alpha = 0;
    self.coverView.hidden = NO;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25
                     animations:^{
                         weakSelf.coverView.alpha = 1;
                     }];
}
- (void)hideCover {
    if (!self.isShowingCover) {
        return;
    }
    self.isShowingCover = NO;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25
                     animations:^{
                         weakSelf.coverView.alpha = 0;
                     } completion:^(BOOL finished) {
                         weakSelf.coverView.hidden = YES;
                     }];
}
// 点击遮罩
- (void)onTapCover {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - tools
- (NSMutableArray *)imageReplysForImageUrlString:(NSString *)imageUrlString replyDicts:(NSArray *)replyDicts {
    __block NSMutableArray *imageReplys = nil;
    [replyDicts enumerateObjectsUsingBlock:^(NSDictionary *replyDict, NSUInteger idx, BOOL *stop) {
        if ([imageUrlString isEqualToString:[replyDict objectForKey:@"reply_image_url"]]) {
            NSMutableArray *arr = [replyDict objectForKey:@"reply_list"];
            if ([arr count] >= 1) {
                imageReplys = arr;
                *stop = YES;
            }
        }
    }];
    return imageReplys;
}

#pragma mark - dealloc
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
