//
//  MainTabBar.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/7/14.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import UIKit

protocol MainTabBarDelegate
{
    func didSelectTabButton(tag:Int)
}

class MainTabBar:UIView
{
    var delegate: MainTabBarDelegate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame aRect: CGRect) {
        super.init(frame: aRect);
        self.backgroundColor = UIColor.yellowColor()
        
        var btnArr = [UIButton]()
        
        var btn1 = UIButton();
        btn1.backgroundColor = UIColor.orangeColor()
        btn1.setTitle("tab1", forState: UIControlState.Normal)
        btnArr.append(btn1)
        
        var btn2 = UIButton();
        btn2.backgroundColor = UIColor.orangeColor().colorWithAlphaComponent(0.8)
        btn2.setTitle("tab2", forState: UIControlState.Normal)
        btnArr.append(btn2)
        
        var btn3 = UIButton();
        btn3.backgroundColor = UIColor.orangeColor().colorWithAlphaComponent(0.6)
        btn3.setTitle("tab3", forState: UIControlState.Normal)
        btnArr.append(btn3)
        
        for(var i:Int = 0; i < btnArr.count; i++)
        {
            var item = btnArr[i]
            item.tag = i;
            item.addTarget(self, action:Selector("onTapBtn:"), forControlEvents: UIControlEvents.TouchUpInside)
            var w = self.bounds.width / CGFloat(btnArr.count)
            item.frame = CGRect(x: w * CGFloat(i), y: 0, width: w, height: self.bounds.height)
            self.addSubview(item)
        }
    }
    
    func onTapBtn(sender:UIButton) {
        print(String(sender.tag))
        delegate?.didSelectTabButton(sender.tag)
    }
}