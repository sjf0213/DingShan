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
        self.backgroundColor = TABBAR_COLOR
        
        var btnArr = [UIButton]()
        
        let btnWidth:CGFloat = CGRectGetWidth(self.frame) / 3.0;
        let btnHeight:CGFloat = CGRectGetHeight(self.frame);
        
        let topline = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 0.5))
        topline.backgroundColor = UIColor.grayColor()
        self.addSubview(topline)
        
        var btn1 = PhoneMainTabBarButton(frame: CGRectMake(0, 0, btnWidth, btnHeight), title: "Home")
//        btn1.backgroundColor = UIColor.orangeColor()
        btn1.normalImage = "tabbar_home1_kuai";
        btn1.highlightImage = "tabbar_home2_kuai";
        btn1.highlightImage2 = "tabbar_home3_kuai";
        btn1.normalTitleColor = TABBAR_GRAY;
        btn1.highlightTitleColor = TABBAR_RED;
        btnArr.append(btn1)
        
        var btn2 = PhoneMainTabBarButton(frame: CGRectMake(btnWidth, 0, btnWidth, btnHeight), title: "Gallery");
//        btn2.backgroundColor = UIColor.orangeColor().colorWithAlphaComponent(0.8)
        btn2.normalImage = "tabbar_hot1_kuai";
        btn2.highlightImage = "tabbar_hot2_kuai";
        btn2.highlightImage2 = "tabbar_hot3_kuai";
        btn2.normalTitleColor = TABBAR_GRAY;
        btn2.highlightTitleColor = TABBAR_RED;
        btnArr.append(btn2)
        
        var btn3 = PhoneMainTabBarButton(frame: CGRectMake(2*btnWidth, 0, btnWidth, btnHeight), title: "Profile");
//        btn3.backgroundColor = UIColor.orangeColor().colorWithAlphaComponent(0.6)
        btn3.normalImage = "tabbar_gift1_kuai";
        btn3.highlightImage = "tabbar_gift2_kuai";
        btn3.highlightImage2 = "tabbar_gift3_kuai";
        btn3.normalTitleColor = TABBAR_GRAY;
        btn3.highlightTitleColor = TABBAR_RED;
        btnArr.append(btn3)
        
        for(var i:Int = 0; i < btnArr.count; i++) {
            var item = btnArr[i]
            item.tag = i + 1000;
            item.addTarget(self, action:Selector("onTapBtn:"), forControlEvents: UIControlEvents.TouchUpInside)
            var w = self.bounds.width / CGFloat(btnArr.count)
            self.addSubview(item)
        }
    }
    
    func onTapBtn(sender:UIButton) {
        print(String(sender.tag))
        let item = sender as? PhoneMainTabBarButton
        item?.setIsSelect(true, withAnimation: true)
        delegate?.didSelectTabButton(sender.tag - 1000)
    }
    
    func setHomeIndex(index:Int) {
        var btn = self.viewWithTag(index + 1000);
        print(" subviews.count = " + String(self.subviews.count))
        for item in self.subviews
        {
            if (item is PhoneMainTabBarButton)
            {
                if (item.isEqual(btn)){
                    item.setIsSelect(true, withAnimation: false)
                    delegate?.didSelectTabButton(item.tag - 1000)
                }else{
                    item.setIsSelect(false, withAnimation: false)
                }
                
            }
        }
        
    }
}