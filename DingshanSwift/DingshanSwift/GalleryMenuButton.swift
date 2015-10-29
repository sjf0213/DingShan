//
//  GalleryMenuButton.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/6.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class GalleryMenuButtton:UIButton {
    var titleColor = UIColor(white: 160/255.0, alpha: 1.0)
    var curSelected:Bool = false{
        willSet(newCurSelected){
            if (newCurSelected){
                
            }else{
                
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame aRect: CGRect) {
        super.init(frame: aRect);
        
        self.backgroundColor = UIColor.whiteColor()
        self.titleLabel?.font = UIFont.systemFontOfSize(13.0)
        self.setTitleColor(titleColor, forState: UIControlState.Normal)
    }
}