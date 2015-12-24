//
//  StageMenuToggleBtn.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/12/23.
//  Copyright © 2015年 song jufeng. All rights reserved.
//

import Foundation
class StageMenuToggleBtn : UIButton{
    var mainBtn : GalleryMenuButtton?
    var expandHandler : (() -> Void)?// 用户点击处理
    // MARK: init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect)
        self.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.3)
        self.clipsToBounds = true
        
        self.mainBtn = GalleryMenuButtton(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width - 100, height: TopBar_H - 21))
        self.mainBtn?.backgroundColor = NAVI_COLOR
        self.mainBtn?.setTitleColor(UIColor.blackColor(), forState:.Normal)
        self.mainBtn?.addTarget(self, action: Selector("onTapMainBtn:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(self.mainBtn!)
    }
    
    // 点击按钮
    func onTapMainBtn(sender:UIButton) {
        if(self.expandHandler != nil){
            self.expandHandler?()
        }
    }
}