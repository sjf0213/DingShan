//
//  TabBarToggleBtn.swift
//  DingshanSwift
//
//  Created by 宋炬峰 on 15/8/29.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class TabBarToggleBtn : UIControl
{
    var img1:UIImage = UIImage();
    var img0:UIImage = UIImage();
    var mainImg = UIImageView();
    var curSelected:Bool = false{
        willSet(newCurSelected){
            if (newCurSelected){
                self.mainImg.image = img1;
            }else{
                self.mainImg.image = img0;
            }
        }
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect)
        self.backgroundColor = TABBAR_COLOR
        mainImg.frame = self.bounds
        mainImg.contentMode = UIViewContentMode.Center
        self.addSubview(mainImg)
    }
}