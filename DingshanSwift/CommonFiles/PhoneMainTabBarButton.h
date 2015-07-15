//
//  PhoneMainTabBarButton.h
//  PhoneUIKit
//
//  Created by song jufeng on 13-12-30.
//  Copyright (c) 2013年 song jufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneMainTabBarButton : UIButton
{
    UILabel * lableTitle;
    UIImageView * imageview;
    UIImageView * imageview2;
    BOOL isSelect;
    NSString * backImage;
    NSString * normalImage;
    NSString * highlightImage;
    UIColor * normalTitleColor;
    UIColor * highlightTitleColor;
}
@property(nonatomic,assign) BOOL isSelect;
@property(nonatomic,strong) NSString * backImage;
@property(nonatomic,strong) NSString * normalImage;
@property(nonatomic,strong) NSString * highlightImage;
@property(nonatomic,strong) NSString * highlightImage2;
@property(nonatomic,strong) UIColor * normalTitleColor;
@property(nonatomic,strong) UIColor * highlightTitleColor;

- (id)initWithFrame:(CGRect)frame title:(NSString*)title;
- (void)setIsSelect:(BOOL)value withAnimation:(BOOL)animation;
@end
