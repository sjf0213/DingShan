//
//  GalleryMenuItem.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/6.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class GalleryMenuItem:UIButton {
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
        self.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.2)
        self.layer.cornerRadius = 3.0;
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 0.5;
        self.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
    }
}