//
//  TopBarView.swift
//  DingshanSwift
//
//  Created by 宋炬峰 on 15/8/29.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class TopBarView:UIView
{
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame aRect: CGRect) {
        super.init(frame: aRect);
        let topline = UIView(frame: CGRect(x: 0, y: TopBar_H - 0.5, width: self.bounds.width, height: 0.5))
        topline.backgroundColor = UIColor.grayColor()
        self.addSubview(topline)
    }
    
}