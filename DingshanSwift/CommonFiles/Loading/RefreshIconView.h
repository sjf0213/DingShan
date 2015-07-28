//
//  RefreshIconView.h
//  CoreUI
//
//  Created by xiong qi on 14-3-31.
//  Copyright (c) 2014年 xiong qi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshIconView : UIView{

}



- (void)setProgress:(float)progress;
- (void)startAnimating;
- (void)stopAnimating;
@end
