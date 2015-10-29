//
//  GalleryMenuItem.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/6.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class GalleryMenuItem:UIButton {
    var borderColor = UIColor(white: 151/255.0, alpha: 1.0)
    var titleColor = UIColor(white: 160/255.0, alpha: 1.0)
    var curSelected:Bool = false{
        didSet(newCurSelected){
            if (newCurSelected){
                borderColor = UIColor(white: 151/255.0, alpha: 1.0)
                titleColor = UIColor(white: 160/255.0, alpha: 1.0)
            }else{
                borderColor = UIColor(red: 252/255.0, green: 74/255.0, blue: 100/255.0, alpha: 1.0)
                titleColor = UIColor(red: 252/255.0, green: 74/255.0, blue: 100/255.0, alpha: 1.0)
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame aRect: CGRect) {
        super.init(frame: aRect);
        let container = UIView(frame: CGRect(x: (frame.size.width-frame.size.width*96.0/160.0)/2.0, y: frame.size.height*(1.0 - 50.0/80.0)/2.0, width: frame.size.width*96.0/160.0, height: frame.size.height*50.0/80.0))
        container.userInteractionEnabled = false
        self.addSubview(container)
        container.backgroundColor = UIColor.clearColor()
        container.layer.borderColor = borderColor.CGColor
        container.layer.cornerRadius = 3.0;
        container.layer.borderWidth = 0.5;
        self.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        self.titleLabel?.font = UIFont.systemFontOfSize(13.0)
    }
}