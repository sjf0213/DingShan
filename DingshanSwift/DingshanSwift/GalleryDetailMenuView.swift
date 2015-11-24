//
//  GalleryDetailMenuView.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/11/24.
//  Copyright © 2015年 song jufeng. All rights reserved.
//

import Foundation
class GalleryDetailMenuView : UIView{
    
    var tapMenuItemHandler: ((index:Int) -> Void)?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame aRect: CGRect) {
        super.init(frame: aRect);
        self.backgroundColor = UIColor.clearColor()
        
        let ang = UIImageView(frame: CGRect(x: frame.size.width - 18, y: 0, width: 12, height: 6))
        ang.image = UIImage(named:"gallery_more_pop")
        self.addSubview(ang)
        
        let container = UIView(frame: CGRect(x: 0, y: 6, width: frame.size.width, height: frame.size.height))
        container.backgroundColor = UIColor.whiteColor()
        self.addSubview(container)
        
        let titleArr = ["保存","分享"]
        let iconArr  = ["download_btn", "share_btn"]
        let h = container.frame.size.height / 2.0
        for (var i = 0; i < 2; i++){
            let btn = UIButton(frame: CGRect(x: 0, y: CGFloat(i)*h, width: container.frame.size.width, height: h))
            container.addSubview(btn);
            btn.setTitle(titleArr[i], forState: UIControlState.Normal)
            btn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            btn.titleLabel?.font = UIFont.systemFontOfSize(15.0)
            btn.setImage(UIImage(named: iconArr[i]), forState: UIControlState.Normal)
            btn.tag = i;
            btn.addTarget(self, action: Selector("onTapItem:"), forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    func onTapItem(sender:UIButton){
        print("----onTapItem-----, 2 2 2 2, \(sender)")
        self.tapMenuItemHandler?(index: sender.tag)
    }
}