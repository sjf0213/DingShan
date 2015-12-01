//
//  StageMenuItem.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/11/30.
//  Copyright © 2015年 song jufeng. All rights reserved.
//

import Foundation
class StageMenuItem:UIButton {
    let borderColorNormal = UIColor(white: 151/255.0, alpha: 1.0)
    let titleColorNormal = UIColor(white: 160/255.0, alpha: 1.0)
    let borderColorHighLighted = UIColor(red: 252/255.0, green: 74/255.0, blue: 100/255.0, alpha: 1.0)
    let titleColorHighLighted = UIColor(red: 252/255.0, green: 74/255.0, blue: 100/255.0, alpha: 1.0)
    var container:UIView?
    var keyName = String()
    var curSelected:Bool = false{
        didSet{
            if (curSelected){
                self.setTitleColor(titleColorHighLighted, forState: UIControlState.Normal)
                container?.layer.borderColor = borderColorHighLighted.CGColor
            }else{
                self.setTitleColor(titleColorNormal, forState: UIControlState.Normal)
                container?.layer.borderColor = borderColorNormal.CGColor
            }
        }
    }
    override internal var highlighted:Bool{
        didSet{
            if (highlighted){
                container?.layer.borderColor = borderColorHighLighted.CGColor
            }else{
                container?.layer.borderColor = borderColorNormal.CGColor
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame aRect: CGRect) {
        super.init(frame: aRect);
        container = UIView(frame: CGRect(x: 10.0, y: 10.0, width: frame.size.width-20.0, height: frame.size.height-20.0))
        self.addSubview(container!)
        
        container?.userInteractionEnabled = false
        container?.backgroundColor = UIColor.clearColor()
        container?.layer.cornerRadius = 3.0;
        container?.layer.borderWidth = 0.5;
        self.setTitleColor(titleColorNormal, forState: UIControlState.Normal)
        self.setTitleColor(titleColorHighLighted, forState: UIControlState.Highlighted)
        self.titleLabel?.font = UIFont.systemFontOfSize(13.0)
    }
}