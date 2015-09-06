//
//  GalleryMenuView.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/6.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class GalleryMenuView: UIView {
    
    var menuTitleArr = [String](){
        didSet{
            var w:CGFloat = self.bounds.width / CGFloat(self.menuTitleArr.count)
            for (var i = 0; i < self.menuTitleArr.count; i++){
                var btn = GalleryMenuButtton();
                
                btn.frame = CGRect(x: CGFloat(i) * w, y: CGFloat(0.0), width: w, height: self.bounds.height)
                btn.setTitle(self.menuTitleArr[i], forState: UIControlState.Normal)
                self.addSubview(btn);
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame aRect: CGRect) {
        super.init(frame: aRect);
        self.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.1)
        
        let topline = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 0.5))
        topline.backgroundColor = UIColor.grayColor()
        self.addSubview(topline)
        
        let buttomline = UIView(frame: CGRect(x: 0, y: self.bounds.size.height - 0.5, width: self.bounds.width, height: 0.5))
        buttomline.backgroundColor = UIColor.grayColor()
        self.addSubview(buttomline)
    }
}