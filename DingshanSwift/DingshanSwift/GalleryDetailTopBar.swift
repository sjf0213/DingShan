//
//  GalleryDetailTopBar.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/11/20.
//  Copyright © 2015年 song jufeng. All rights reserved.
//

import Foundation

class GalleryDetailTopBar : UIView{
    var backBlock: (() -> Void)? // 最简单的闭包，用来navi返回按钮
    // MARK: init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame aRect: CGRect) {
        super.init(frame: aRect);
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5);
        
        let backBtn = UIButton(frame: CGRect(x: 0, y: 20, width: 44, height: 44))
        backBtn.backgroundColor = UIColor.clearColor()
        backBtn.setTitle(String.fontAwesomeIconStringForIconIdentifier("fa-angle-left"), forState: UIControlState.Normal)
        backBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        backBtn.titleLabel?.font = UIFont(name: "FontAwesome", size: 28)
        self.addSubview(backBtn)
        backBtn.addTarget(self, action: Selector("onTapBack"), forControlEvents: UIControlEvents.TouchUpInside)
    
    }
    
    func onTapBack() {
        self.backBlock?()
    }
}