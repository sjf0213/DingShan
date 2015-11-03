//
//  GalleryMenuView.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/6.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class GalleryMenuView: UIView {
    var tapItemHandler : ((keyName:String, index:Int) -> Void)?
    var isExpanded:Bool = false {
        didSet{
            if isExpanded{
                self.frame = CGRectMake(0, TopBar_H, self.bounds.size.width, UIScreen.mainScreen().bounds.height - TopBar_H)
                
            }else{
                self.frame = CGRectMake(0, TopBar_H, self.bounds.size.width, GalleryMenuBar_H)
                self.subItemContainer?.frame = CGRectZero
            }
        }
    }
    var subItemContainer:UIView?
    var menuConfig = [AnyObject](){
        didSet{
            for v in self.subviews{
                if v != subItemContainer{
                    v.removeFromSuperview()
                }
            }
            // print("menuConfig = \(menuConfig)")
            let w:CGFloat = self.bounds.width / CGFloat(self.menuConfig.count)
            let h:CGFloat = GalleryMenuBar_H
            for (var i = 0; i < self.menuConfig.count; i++){
                let btn = GalleryMenuButtton();
                btn.frame = CGRect(x: CGFloat(i) * w, y: CGFloat(0.0), width: w, height: h)
                if let dic  = self.menuConfig[i] as? [NSObject:AnyObject]{
                    if let title = dic["title"] as? String{
                        btn.btnText = title
                        if let key = dic["name"] as? String{
                            btn.keyName = key
                        }
                        btn.curSelected = false
                        self.addSubview(btn);
                    }
                }
                btn.tag = i+1;
                btn.addTarget(self, action: Selector("onTapBtn:"), forControlEvents: UIControlEvents.TouchUpInside)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame aRect: CGRect) {
        super.init(frame: aRect);
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
        
        let topline = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 0.5))
        topline.backgroundColor = UIColor.grayColor()
        self.addSubview(topline)
        
        let buttomline = UIView(frame: CGRect(x: 0, y: self.bounds.size.height - 0.5, width: self.bounds.width, height: 0.5))
        buttomline.backgroundColor = UIColor.grayColor()
        self.addSubview(buttomline)
        
        self.subItemContainer = UIView(frame: CGRectZero)
        self.subItemContainer?.backgroundColor = UIColor.whiteColor()
        self.subItemContainer?.clipsToBounds = true
        self.addSubview(self.subItemContainer!)
    }
    
    func onTapBtn(sender:GalleryMenuButtton) {
        print(sender, terminator: "")
        let btn = sender
        let index = btn.tag - 1
        if(false == btn.curSelected){
            // 把其他菜单按钮复位
            self.resetMenu()
            // 生成自己的二级菜单
            sender.curSelected = true;
            if let dic = self.menuConfig[index] as? [NSObject:AnyObject]{
                self.isExpanded = true
                // 生成所有二级菜单
                if let subItems = dic["items"] as? [AnyObject]{
                    self.generateMenuItems(subItems, keyName: btn.keyName)
                }
            }
        }else{
            // 收起菜单
            sender.curSelected = false;
            self.isExpanded = false
            for v in self.subItemContainer!.subviews{
                v.removeFromSuperview()
            }
        }
    }
    
    // 生成所有二级菜单
    func generateMenuItems(data:[AnyObject], keyName:String){
        let w:CGFloat = self.bounds.width / 4
        let h:CGFloat = GalleryMenuItem_H
        for (var i = 0; i < data.count; i++){
            if let one = data[i] as? [NSObject:AnyObject]{
                let row:Int = i/4
                let col:Int = i%4
                let rect = CGRect(x: w * CGFloat(col), y: h * CGFloat(row), width: w, height: h)
                let btn = GalleryMenuItem(frame: rect)
                btn.tag = i
                btn.keyName = keyName
                btn.addTarget(self, action: Selector("onTapItem:"), forControlEvents: UIControlEvents.TouchUpInside)
                if let t = one["title"] as? String{
                    btn.setTitle(t, forState: UIControlState.Normal)
                }
                self.subItemContainer!.addSubview(btn)
            }
        }
        let rowCount:Int = (data.count-1)/4 + 1
        let offh = GalleryMenuItem_H*CGFloat(rowCount) + GalleryMenuItem_H*50.0/80.0/2.0
        self.subItemContainer?.frame = CGRectMake(0, GalleryMenuBar_H, self.frame.size.width, offh)
    }
    
    // 点击二级菜单项
    func onTapItem(item:GalleryMenuItem) {
        print("----------sub menu items title:\(item.titleLabel?.text), tagIndex:\(item.tag)")
        item.curSelected = true
        UIView.animateWithDuration(0.3, animations: {() -> Void in }, completion: { (flag) -> Void in
            self.resetMenu()
            self.isExpanded = false
            
            if (self.tapItemHandler != nil) {
                self.tapItemHandler?(keyName:item.keyName, index: item.tag)
            }
        })
    }
    
    // 复位所有菜单状态
    func resetMenu(){
        for v in self.subviews{
            if let b = v as? GalleryMenuButtton{
                b.curSelected = false
            }
        }
        for v in self.subItemContainer!.subviews{
            if let b = v as? GalleryMenuItem{
                b.curSelected = false
            }
            v.removeFromSuperview()
        }
    }
}