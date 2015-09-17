//
//  TabBarView.swift
//  DingshanSwift
//
//  Created by 宋炬峰 on 15/8/29.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation

protocol TabBarViewDelegate
{
    func didSelectTabButton(tag:Int)
}

class TabBarView:UIView
{
    var delegate: TabBarViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame aRect: CGRect) {
        super.init(frame: aRect);
        self.backgroundColor = TABBAR_COLOR
        
        let btnWidth:CGFloat = CGRectGetWidth(self.frame) / 3.0;
        let btnHeight:CGFloat = CGRectGetHeight(self.frame);
        
        let topline = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 0.5))
        topline.backgroundColor = UIColor(white: 151/255.0, alpha: 1.0)
        self.addSubview(topline)
        
        var btnArr = [UIControl]()
        
        let btn1 = TabBarToggleBtn(frame: CGRectMake(0, 0, btnWidth, btnHeight));
        btn1.img0 = UIImage(named: "tabbar_forum0")!;
        btn1.img1 = UIImage(named: "tabbar_forum1")!;
        btn1.title = "装吧"
        btnArr.append(btn1)
        let btn2 = TabBarToggleBtn(frame: CGRectMake(btnWidth, 0, btnWidth, btnHeight));
        btn2.img0 = UIImage(named: "tabbar_gallery0")!;
        btn2.img1 = UIImage(named: "tabbar_gallery1")!;
        btn2.title = "怦然心动"
        btnArr.append(btn2)
        let btn3 = TabBarToggleBtn(frame: CGRectMake(btnWidth*2, 0, btnWidth, btnHeight));
        btn3.img0 = UIImage(named: "tabbar_profile0")!;
        btn3.img1 = UIImage(named: "tabbar_profile1")!;
        btn3.title = "我的"
        btnArr.append(btn3)
        
        for(var i:Int = 0; i < btnArr.count; i++) {
            let item = btnArr[i]
            item.tag = i + 1000;
            item.addTarget(self, action:Selector("onTapBtn:"), forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(item)
        }
    }
    
    func setHomeIndex(index:Int) {
        print(" subviews.count = " + String(self.subviews.count), terminator: "")
        for obj in self.subviews{
            if let item = obj as? TabBarToggleBtn{
                if (item.tag == index + 1000){
                    item.curSelected = true;
                }else{
                    item.curSelected = false;
                }
            }
        }
        self.delegate?.didSelectTabButton(index)
    }
    
    func onTapBtn(sender:UIControl) {
        print(String(sender.tag), terminator: "")
        if let item = sender as? TabBarToggleBtn{
            item.curSelected = true;
            for obj in self.subviews{
                if let sub = obj as? TabBarToggleBtn{
                    if (sub.tag == item.tag){
                        sub.curSelected = true;
                    }else{
                        sub.curSelected = false;
                    }
                }
            }
        }
        delegate?.didSelectTabButton(sender.tag - 1000)
    }
}