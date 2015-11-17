//
//  ScrollShowView.m
//  PhotoListBrowseController
//
//  Created by xiong qi on 12-10-25.
//  Copyright (c) 2012年 xiong qi. All rights reserved.
//

#import "ScrollShowView.h"
#import "AsynRequestImageView.h"

@interface ScrollShowView ()<UIScrollViewDelegate>
@property (nonatomic) UIScrollView              *imageScrollView;
@property (nonatomic) AsynRequestImageView      *imageView;
@property (nonatomic) float                     maxScale;
@end

@implementation ScrollShowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        _imageScrollView  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_imageScrollView];
        _imageScrollView.showsHorizontalScrollIndicator = NO;
        _imageScrollView.showsVerticalScrollIndicator   = NO;
        _imageScrollView.delegate = self;
        [_imageScrollView setMinimumZoomScale:1];
        [_imageScrollView setMaximumZoomScale:3];
        _imageScrollView.clipsToBounds = NO;

        _imageView = [[AsynRequestImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _imageView.userInteractionEnabled = YES;
        [_imageScrollView addSubview:_imageView];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_imageView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
        
        _imageScrollView.contentSize = _imageView.bounds.size;
        [_imageScrollView setBackgroundColor:[UIColor clearColor]];
        
        UITapGestureRecognizer * recongizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleClick:)];
        recongizer.numberOfTapsRequired = 2;
        [self addGestureRecognizer:recongizer];
        
    }
    return self;
}

#pragma mark - getter
- (CGPoint)curRelativeTouchPoint {
    if (!self.imageView.image) {
        return CGPointZero;
    }
    
    CGPoint relativePoint = CGPointMake(
                                        self.curTouchPoint.x / CGRectGetWidth(self.imageView.bounds),
                                        self.curTouchPoint.y / CGRectGetHeight(self.imageView.bounds));

    return relativePoint;
}

#pragma mark - 保存图片
-(void)SaveToAlbum {
    if (self.imageView.image == nil) {
        return ;
    }
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError: contextInfo:), nil);
}

-(void)SaveToAlbum:(UIView*)tipView {
    if (self.imageView.image == nil) {
        return ;
    }
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError: contextInfo:), (__bridge void*)tipView);
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo {
    NSString * str;
    if (!error) {
        str = @"收藏到相册成功!";
    }
    else {
        str = @"收藏到相册失败!";
    }
//    UIView* v = (__bridge UIView*)contextInfo;
//    if([v isKindOfClass:[UIView class]]){
//        [MozTopAlertView showDefaultTypeText:str parentView:v];
//    }else{
//        [MozTopAlertView showDefaultTypeText:str parentView:self];
//    }
}

CGFloat ZoomScaleThatFits(CGSize target, CGSize source) {
    CGFloat w_scale = (target.width / source.width);
    CGFloat h_scale = (target.height / source.height);
    return ((w_scale < h_scale) ? w_scale : h_scale);
}

CGSize SizeThatFits(CGSize target, CGSize source) {
    CGFloat w_scale = (target.width / source.width);
    CGFloat h_scale = (target.height / source.height);
    CGSize size;
    //此处为得到图片视图的正确尺寸
    if (w_scale>h_scale) {
        size = CGSizeMake(source.width,source.width*target.height/target.width);
    }
    else {
        size = CGSizeMake(source.height*target.width/target.height,source.height);
    }
    return size;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UIImage *image = [change objectForKey:NSKeyValueChangeNewKey];
    
    if ([image isKindOfClass:[NSNull class]]) {
        self.maxScale = 1;
        return;
    }
    else {
        self.maxScale = ZoomScaleThatFits(image.size, self.imageView.bounds.size);
        if (self.maxScale<2.0) {
            self.maxScale = 2.0;
        }
        CGSize size = SizeThatFits(image.size,self.imageView.bounds.size);
//        self.imageView.frame = CGRectMake((self.imageScrollView.frame.size.width-size.width)/2, (self.imageScrollView.frame.size.height-size.height)/2, size.width, size.height);
        
        //将图片放到(0,0)处，并将滚动视图也设置为同样大小，这样滚动视图放大时将不会有空白
        self.imageView.frame = CGRectMake(0, 0, size.width, size.height);
        self.imageScrollView.bounds = CGRectMake(0, 0, size.width, size.height);
        self.imageScrollView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        self.imageScrollView.contentSize = size;
        
        
//        NSLog(@"%@,%@",self.imageView,self.imageScrollView);
    }
    

    [self.imageScrollView setMaximumZoomScale:self.maxScale];
    
}

#pragma mark - 手势
-(void)onDoubleClick:(UITapGestureRecognizer *)recognizer {
    if (self.imageView.image != nil) {
        [UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3f];
        
        if (self.imageScrollView.zoomScale != 1) {
            [self.imageScrollView setZoomScale:1];
        }
        else {
            [self.imageScrollView setZoomScale:self.maxScale];
            CGPoint point = [self ConvertTouchPointToShowPoint:[recognizer locationInView:self.imageScrollView]];
            self.imageScrollView.contentOffset = point;
        }
        [UIView commitAnimations];
    }
}

-(CGPoint)ConvertTouchPointToShowPoint:(CGPoint)touchpoint {
    
//    CGFloat offsetX = touchpoint.x*self.maxScale-self.imageScrollView.frame.size.width/2;
//    CGFloat offsetY = touchpoint.y*self.maxScale-self.imageScrollView.frame.size.height/2;

    CGFloat offsetX = touchpoint.x-self.imageScrollView.frame.size.width/2;;
    CGFloat offsetY = touchpoint.y-self.imageScrollView.frame.size.height/2;
    
    if (offsetX<0) {
        offsetX = 0;
    }
    if (offsetX>0 && offsetX>self.imageScrollView.contentSize.width-self.imageScrollView.frame.size.width) {
        offsetX=self.imageScrollView.contentSize.width-self.imageScrollView.frame.size.width;
    }
    
    if (offsetY<0) {
        offsetY = 0;
    }
    if (offsetY>0 && offsetY>self.imageScrollView.contentSize.height-self.imageScrollView.frame.size.height) {
        offsetY=self.imageScrollView.contentSize.height-self.imageScrollView.frame.size.height;
    }

    return CGPointMake(offsetX,offsetY);
}

#pragma mark -
- (void)RefreshByData:(NSObject *)obj {
    self.imageScrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.imageScrollView.scrollEnabled = NO;
    self.imageView.frame = self.imageScrollView.frame;
    
    [self.imageView cancel];
    self.imageView.image = nil;
    [self.imageView reset];
    
    _curImageUrlString = [(NSString *)obj copy];
    [self.imageView loadImageFromURL:_curImageUrlString];
//    self.imageOperation = [self.imageView loadImageFromURL:self.curImageUrlString];
}

- (void)ClearView {
    self.imageView.image = nil;
}

- (void)RevertScale {
    [self.imageScrollView setZoomScale:1];
}


#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    //
    CGPoint offset = self.imageScrollView.contentOffset;
    
    CGFloat height = self.imageScrollView.contentSize.height;
    CGFloat width  = self.imageScrollView.contentSize.width;
    if (height>self.frame.size.height) {
        height = self.frame.size.height;
    }
    
    if (width>self.frame.size.width) {
        width = self.frame.size.width;
    }
    
    self.imageScrollView.bounds = CGRectMake(0, 0, width, height);
    
    self.imageScrollView.contentOffset = offset;
    if (self.imageScrollView.zoomScale == 1.0) {
        self.imageView.center = CGPointMake(width/2, height/2);
        self.imageScrollView.contentOffset = CGPointZero;
        self.imageScrollView.scrollEnabled = NO;
//        NSLog(@"%@",self.imageView);
    }
    else {
        self.imageScrollView.scrollEnabled = YES;
    }
//    NSLog(@"self.imageScrollView:%@",self.imageScrollView);
}

#pragma mark - dealloc
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.imageView removeObserver:self forKeyPath:@"image"];
//    [self.imageOperation cancel];
}

@end
