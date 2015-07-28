//
//  RefurbishView.m
//  CoreFramework
//
//  Created by yingmin zhu on 13-4-11.
//  Copyright (c) 2013年 appfactory. All rights reserved.
//

#import "RefreshView.h"
#import "RefreshIconView.h"

@interface RefreshView ()

@property(nonatomic,strong)UILabel * labelTitle;
@property(nonatomic,strong)UILabel * labelTime;
@property(nonatomic,strong)RefreshIconView * activityView;

@end

@implementation RefreshView
@synthesize delegate,isCanUse;
@synthesize labelTitle,labelTime,activityView,isLoading;

#define  TextStart  30
#define  FillStartOffset  30.0f
#define  FillEndOffset    60.0f

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    
        labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2-TextStart, frame.size.height/2-15,frame.size.width/2+TextStart, 15)];
		[labelTitle setBackgroundColor:[UIColor clearColor]];
		[labelTitle setText:StringNormal];
        [labelTitle setTextAlignment:NSTextAlignmentLeft];
		[self addSubview:labelTitle];
        
        labelTime = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2-TextStart, frame.size.height/2,frame.size.width/2+TextStart, 15)];
        labelTime.center = CGPointMake(labelTitle.center.x, labelTitle.center.y+17);
		[labelTime setBackgroundColor:[UIColor clearColor]];
		[labelTime setText:[NSString stringWithFormat:@"%@ 未知",LastUpdataTime]];
        [labelTime setTextAlignment:NSTextAlignmentLeft];
		[self addSubview:labelTime];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            [labelTitle setFont:[UIFont systemFontOfSize:12]];
            [labelTitle setTextColor:[UIColor colorWithRed:0.671 green:0.671 blue:0.671 alpha:1.0]];
            
            [labelTime setFont:[UIFont systemFontOfSize:10]];
            [labelTime setTextColor:[UIColor colorWithRed:0.671 green:0.671 blue:0.671 alpha:1.0]];
        }
        else
        {
            [labelTitle setFont:[UIFont systemFontOfSize:14]];
            [labelTitle setTextColor:[UIColor blackColor]];
            
            [labelTime setFont:[UIFont systemFontOfSize:12]];
            [labelTime setTextColor:[UIColor blackColor]];
        }
        
		//加载动画
        CGFloat activityViewSize= 22;
		activityView = [[RefreshIconView alloc]initWithFrame:CGRectMake(frame.size.width/2-TextStart-10-activityViewSize,(frame.size.height - activityViewSize)/2, activityViewSize, activityViewSize)];
		[self addSubview:activityView];
        
        self.loadinsets = UIEdgeInsetsMake(0, 0, 0, 0);
        isLoading = NO;
        isCanUse = YES;
    }
    return self;
}

-(void)setDelegate:(NSObject<LoadViewProtocol> *)del
{
    delegate = del;
}

- (void)showRefreshWithScrollView:(UIScrollView *)scrollView
{
    if(delegate==nil)
        return;
    if(isLoading)
        return;
    
    isLoading = YES;
    [labelTitle setText:StringLoading];
    
    if(scrollView)
    {
        scrollView.contentInset = UIEdgeInsetsMake(self.loadinsets.top+self.frame.size.height,self.loadinsets.left,self.loadinsets.bottom,self.loadinsets.right);
        scrollView.contentOffset = CGPointMake(0, -(self.loadinsets.top+self.frame.size.height));
        [activityView startAnimating];
    }
    
    if([delegate respondsToSelector:@selector(BeginRefreshData:)])
    {
        [delegate performSelector:@selector(BeginRefreshData:) withObject:self afterDelay:0];
    }
}


- (void)RefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentInset.top + scrollView.contentOffset.y;
    if (!self.isCanUse||offset>0||isLoading)
    {
		return;
	}
    
    CGFloat progress = (fabs(offset)-FillStartOffset)/(FillEndOffset-FillStartOffset);
    [activityView setProgress:progress];
    [labelTitle setText:progress>=1.0?StringPulling:StringNormal];
}

- (void)RefreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentInset.top + scrollView.contentOffset.y;
    if (!self.isCanUse||offset>0||isLoading)
    {
		return;
	}

    CGFloat progress = (fabs(offset)-FillStartOffset)/(FillEndOffset-FillStartOffset);
    if(progress>=1.0)
    {
        isLoading = YES;
        [labelTitle setText:StringLoading];
        
        [UIView animateWithDuration:0.2f animations:^
        {
            scrollView.contentInset = UIEdgeInsetsMake(self.loadinsets.top+self.frame.size.height,self.loadinsets.left,self.loadinsets.bottom, self.loadinsets.right);
            
        } completion:^(BOOL completion)
        {
            [activityView startAnimating];
        }];
        
        if(delegate&& [delegate respondsToSelector:@selector(BeginRefreshData:)])
        {
            [delegate performSelector:@selector(BeginRefreshData:) withObject:self afterDelay:0.1];
        }
    }
}

- (void)RefreshScrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

}

- (void)RefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
    //只有加载数据以后，以下操作才生效
    if (!isLoading) {
        return;
    }
    
    isLoading = NO;
    
    [UIView animateWithDuration:.2f animations:^
     {
         scrollView.contentInset = self.loadinsets;
     }
         completion:^(BOOL completion)
     {
         [activityView stopAnimating];
         [labelTitle setText:StringNormal];
         [activityView setProgress:0];
         [self refreshLastUpdatedDate];
     }];
}

- (void)refreshLastUpdatedDate
{	
	NSDate *date = [NSDate date];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:@"HH:mm"];
	labelTime.text = [NSString stringWithFormat:@"%@ %@",LastUpdataTime,[formatter stringFromDate:date]];
}

@end
