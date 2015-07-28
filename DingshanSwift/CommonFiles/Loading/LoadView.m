//
//  LoadView.m
//  CoreFramework
//
//  Created by yingmin zhu on 13-4-11.
//  Copyright (c) 2013年 appfactory. All rights reserved.
//

#import "LoadView.h"

@interface LoadView ()
@property(nonatomic,strong)UILabel * labelTitle;
@property(nonatomic,strong)UIActivityIndicatorView * activityView;
@property(nonatomic,assign)LoadState CurrentState;

@property(nonatomic,assign)BOOL isLoading;//是否正在加载数据
@end

@implementation LoadView
@synthesize delegate,isCanUse;
@synthesize labelTitle,activityView,CurrentState,isLoading;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.isCanUse = NO;
        self.userInteractionEnabled = NO;
        
        labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, (frame.size.height-20)/2,frame.size.width-15, 20)];
		[labelTitle setBackgroundColor:[UIColor clearColor]];
		[labelTitle setText:LoadStringLoading];
        [labelTitle setTextAlignment:NSTextAlignmentCenter];
		[self addSubview:labelTitle];
        
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            [labelTitle setFont:[UIFont systemFontOfSize:12]];
            [labelTitle setTextColor:[UIColor colorWithRed:0.671 green:0.671 blue:0.671 alpha:1.0]];
            
        }
        else
        {
            [labelTitle setFont:[UIFont systemFontOfSize:14]];
            [labelTitle setTextColor:[UIColor blackColor]];
        }
		
		//加载动画
		activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.frame = CGRectMake((frame.size.width/2)-55,(frame.size.height - 20)/2, 20, 20);
		[self addSubview:activityView];
        
        [self setCurrentState:LoadLoading];
        isLoading = NO;
        self.loadinsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}

- (void)setCurrentState:(LoadState)aState{
    switch (aState) {
        case LoadPulling:
            self.userInteractionEnabled = NO;
            CurrentState = LoadPulling;
            [labelTitle setText:LoadStringPulling];
            break;
        case LoadNormal:
            self.userInteractionEnabled = NO;
            CurrentState = LoadNormal;
            [labelTitle setText:LoadStringNormal];
            [activityView stopAnimating];
            break;
        case LoadLoading:
            self.userInteractionEnabled = NO;
            CurrentState = LoadLoading;
            [labelTitle setText:LoadStringLoading];
            [activityView startAnimating];
            break;
        case LoadFailed:
            self.userInteractionEnabled = YES;
            CurrentState = LoadFailed;
            [labelTitle setText:LoadStringFailed];
            [activityView stopAnimating];
            break;
        default:
            break;
    }
}

- (void)RefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.isCanUse)
    {
		return;
	}
    
	//提前100个像素加载数据
    if (scrollView.contentOffset.y<scrollView.contentSize.height-scrollView.frame.size.height-100||
        scrollView.contentSize.height-scrollView.frame.size.height<0)
    {
        self.center = CGPointMake(self.center.x, -1000);
        return;
    }
    
    scrollView.contentInset = UIEdgeInsetsMake(self.loadinsets.top, self.loadinsets.left,self.loadinsets.bottom + self.frame.size.height, self.loadinsets.right);
    
    self.center= CGPointMake(self.center.x,scrollView.contentSize.height+self.frame.size.height/2);
    
    if (!isLoading)
    {
        if ([delegate respondsToSelector:@selector(BeginLoadingData:)])
        {
			[delegate BeginLoadingData:self];
            isLoading = YES;
		}
    }
}

- (void)RefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
    isLoading = NO;
    self.center = CGPointMake(self.center.x, -1000);
    scrollView.contentInset = self.loadinsets;
}

- (void)RefreshScrollViewDataSourceDidFinishedLoadingButFailed:(UIScrollView *)scrollView
{
    //加载失败时默认是不再执行滚动加载的
    self.isCanUse = NO;
    isLoading = NO;
    [self setCurrentState:LoadFailed];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.delegate != nil && [delegate respondsToSelector:@selector(FinishedLoadingDataButFailed)]) {
        [self setCurrentState:LoadLoading];
        [delegate FinishedLoadingDataButFailed];
    }
}


@end
