//
//  GalleryMenuView.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/6.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class GalleryMenuView: UIView {
    var isExpanded:Bool = false {
        didSet{
            if isExpanded{
                self.frame = CGRectMake(0, TopBar_H, self.bounds.size.width, UIScreen.mainScreen().bounds.height - TopBar_H)
            }else{
                self.frame = CGRectMake(0, TopBar_H, self.bounds.size.width, GalleryMenuBar_H)
            }
        }
    }
    var subItemContainer = UIView()
    var menuConfig = [AnyObject](){
        didSet{
            for v in self.subviews{
                v.removeFromSuperview()
            }
            print("menuConfig = \(menuConfig)")
            let w:CGFloat = self.bounds.width / CGFloat(self.menuConfig.count)
            let h:CGFloat = GalleryMenuBar_H
            for (var i = 0; i < self.menuConfig.count; i++){
                let btn = GalleryMenuButtton();
                btn.frame = CGRect(x: CGFloat(i) * w, y: CGFloat(0.0), width: w, height: h)
                if let dic  = self.menuConfig[i] as? [NSObject:AnyObject]{
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
        if(false == btn.curSelected){
            sender.curSelected = true;
            for v in self.subviews{
                v.removeFromSuperview()
            }
            if let dic = self.menuConfig[index] as? [NSObject:AnyObject]{
                print("tap menu btn:\(index) - - - - \(dic)", terminator: "")
//                self.frame = CGRectMake(0, TopBar_H, self.bounds.size.width, UIScreen.mainScreen().bounds.height - TopBar_H)
                self.isExpanded = true
                // 生成所有二级菜单
                if let subItems = dic["items"] as? [String]{
                    print("----------sub menu items", subItems)
                    let w:CGFloat = self.bounds.width / 4
                    let h:CGFloat = GalleryMenuItem_H
                    for (var i = 0; i < subItems.count; i++){
                        let btn = GalleryMenuItem()
                        let row:Int = i/4
                        let col:Int = i%4
                        print("----------row:",row)
                        btn.frame = CGRect(x: w * CGFloat(col), y: h * CGFloat(row) + GalleryMenuBar_H, width: w, height: h)
                        print("----------btn.frame:",btn.frame)
                        let title = subItems[i]
                        btn.setTitle(title, forState: UIControlState.Normal)
                        self.addSubview(btn)
                        btn.tag = i;
                        btn.addTarget(self, action: Selector("onTapItem:"), forControlEvents: UIControlEvents.TouchUpInside)
                    }
                }
            }
        }else{
            sender.curSelected = false;
//            self.frame = CGRectMake(0, TopBar_H, self.bounds.size.width, GalleryMenuBar_H)
            self.isExpanded = false
            for v in self.subviews{
                v.removeFromSuperview()
            }
        }
    }
    
    func onTapItem(item:GalleryMenuItem) {
        print("----------sub menu items title:", item.titleLabel?.text)
        self.isExpanded = false
    }
}