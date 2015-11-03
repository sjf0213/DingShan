//
//  GalleryMenuButton.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/6.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class GalleryMenuButtton:UIButton {
    var titleColorNormal = UIColor(white: 160/255.0, alpha: 1.0)
    var titleColorHighlighted = UIColor(red: 252/255.0, green: 74/255.0, blue: 100/255.0, alpha: 1.0)
    var tailUp = " " + String.fontAwesomeIconStringForIconIdentifier("fa-angle-up")
    var tailDown = " " + String.fontAwesomeIconStringForIconIdentifier("fa-angle-down")
    var btnText = ""
    var keyName = String()
    var curSelected:Bool = false{
        willSet(newCurSelected){
            if (newCurSelected){
                self.setTitle(btnText+tailUp, forState: UIControlState.Normal)
                self.setTitleColor(titleColorHighlighted, forState: UIControlState.Normal)
            }else{
                self.setTitle(btnText+tailDown, forState: UIControlState.Normal)
                self.setTitleColor(titleColorNormal, forState: UIControlState.Normal)
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame aRect: CGRect) {
        super.init(frame: aRect);
        
        self.backgroundColor = UIColor.whiteColor()
        self.titleLabel?.font = UIFont(name: "FontAwesome", size: 13.0)
    }
}