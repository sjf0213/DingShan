//
//  GalleryMenuButton.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/6.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class GalleryMenuButtton:UIButton {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame aRect: CGRect) {
        super.init(frame: aRect);
        self.backgroundColor = UIColor.cyanColor().colorWithAlphaComponent(0.1)
        self.layer.cornerRadius = 3.0;
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 0.5;
        
        self.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
    }
}