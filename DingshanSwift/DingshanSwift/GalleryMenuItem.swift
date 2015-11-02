//
//  GalleryMenuItem.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/6.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class GalleryMenuItem:UIButton {
    let borderColorNormal = UIColor(white: 151/255.0, alpha: 1.0)
    let titleColorNormal = UIColor(white: 160/255.0, alpha: 1.0)
    let borderColorHighLighted = UIColor(red: 252/255.0, green: 74/255.0, blue: 100/255.0, alpha: 1.0)
    let titleColorHighLighted = UIColor(red: 252/255.0, green: 74/255.0, blue: 100/255.0, alpha: 1.0)
    var container:UIView?
    var curSelected:Bool = false{
        didSet(newCurSelected){
            if (newCurSelected){
                self.setTitleColor(titleColorHighLighted, forState: UIControlState.Normal)
                container?.layer.borderColor = borderColorHighLighted.CGColor
            }else{
                self.setTitleColor(titleColorNormal, forState: UIControlState.Normal)
                container?.layer.borderColor = borderColorNormal.CGColor
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame aRect: CGRect) {
        super.init(frame: aRect);
        container = UIView(frame: CGRect(x: (frame.size.width-frame.size.width*96.0/160.0)/2.0, y: frame.size.height*(1.0 - 50.0/80.0)/2.0, width: frame.size.width*96.0/160.0, height: frame.size.height*50.0/80.0))
        self.addSubview(container!)
        
        container?.userInteractionEnabled = false
        container?.backgroundColor = UIColor.clearColor()
        container?.layer.cornerRadius = 3.0;
        container?.layer.borderWidth = 0.5;
        self.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        self.titleLabel?.font = UIFont.systemFontOfSize(13.0)
    }
}