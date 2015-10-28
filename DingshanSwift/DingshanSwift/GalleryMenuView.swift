//
//  GalleryMenuView.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/6.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class GalleryMenuView: UIView {
    
    var menuTitleArr = [AnyObject](){
        didSet{
            let w:CGFloat = self.bounds.width / CGFloat(self.menuTitleArr.count)
            for (var i = 0; i < self.menuTitleArr.count; i++){
                let btn = GalleryMenuButtton();
                
                btn.frame = CGRect(x: CGFloat(i) * w, y: CGFloat(0.0), width: w, height: self.bounds.height)
                if let dic  = self.menuTitleArr[i] as? [NSObject:AnyObject]{
                    if let title = dic["title"] as? String{
                        btn.setTitle(title, forState: UIControlState.Normal)
                        self.addSubview(btn);
                    }
                }
                btn.tag = i;
                btn.addTarget(self, action: Selector("onTapBtn:"), forControlEvents: UIControlEvents.TouchUpInside)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
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
    
    func onTapBtn(sender:GalleryMenuButtton) {
        print(sender, terminator: "")
        let btn = sender
        let index = btn.tag
        if(btn.curSelected){
            sender.curSelected = false;
            if let dic = self.menuTitleArr[index] as? [NSObject:AnyObject]{
                print("tap menu btn:\(index) - - - - \(dic)", terminator: "")
                self.frame = CGRectMake(0, TopBar_H, self.bounds.size.width, UIScreen.mainScreen().bounds.height - TopBar_H)
            }
        }else{
            sender.curSelected = true;
            self.frame = CGRectMake(0, TopBar_H, self.bounds.size.width, 40)
        }
        
        
        
        
        
    }
}