//
//  GalleryMenuView.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/6.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class GalleryMenuView: UIView {
    var tapItemHandler : ((config:[NSObject:AnyObject]) -> Void)?// 用户点击处理
    var userSelectConfig:[NSObject:AnyObject]?// 记住用户当前的选择
    var btnBgContainer:UIView?  // 一级按钮容器
    var subItemContainer:UIView?// 二级按钮容器
    // 二级菜单的展开与收起
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
    // 菜单内容的配置
    var menuConfig = [AnyObject](){
        didSet{
            // print("menuConfig = \(menuConfig)")
            self.resetMenu()
            // 生成用于请求的用户选择记录
            var dicOne = [NSObject:AnyObject]()
            for item in menuConfig{
                if let obj = item as? [NSObject:AnyObject]{
                    if let name = obj["name"] as? String{
                        dicOne[name] = 0
                    }
                }
            }
            self.userSelectConfig = dicOne
            // print("-----------userSelectConfig = \(userSelectConfig)")
            
            // 清空一级菜单，并重新生成一级菜单
            for v in self.btnBgContainer!.subviews{
                v.removeFromSuperview()
            }
            let w:CGFloat = self.bounds.width / CGFloat(self.menuConfig.count)
            let h:CGFloat = GalleryMenuBar_H - 0.5
            for (var i = 0; i < self.menuConfig.count; i++){
                let btn = GalleryMenuButtton();
                let offsetX:CGFloat = i == 0 ? 0.0 : 0.5
                btn.frame = CGRect(x: CGFloat(i) * w + offsetX, y: CGFloat(0.0), width: w - offsetX, height: h)
                if let dic  = self.menuConfig[i] as? [NSObject:AnyObject]{
                    if let title = dic["title"] as? String{
                        btn.btnText = title
                        if let key = dic["name"] as? String{
                            btn.keyName = key
                        }
                        btn.curSelected = false
                        self.btnBgContainer?.addSubview(btn);
                    }
                }
                btn.tag = i+1;
                btn.addTarget(self, action: Selector("onTapBtn:"), forControlEvents: UIControlEvents.TouchUpInside)
            }
        }
    }
    // MARK: init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect);
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        self.btnBgContainer = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: GalleryMenuBar_H))
        self.btnBgContainer?.backgroundColor = NAVI_COLOR
        self.addSubview(self.btnBgContainer!)
        
        self.subItemContainer = UIView(frame: CGRectZero)
        self.subItemContainer?.backgroundColor = UIColor.whiteColor()
        self.subItemContainer?.clipsToBounds = true
        self.addSubview(self.subItemContainer!)
        
        let tapRec = UITapGestureRecognizer(target: self, action: Selector("onTapMenu"))
        self.addGestureRecognizer(tapRec)
    }
    
    override func layoutSubviews() {
        self.btnBgContainer?.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: GalleryMenuBar_H)
    }
    
    // 点击一级按钮
    func onTapBtn(sender:GalleryMenuButtton) {
        print(sender, terminator: "")
        let btn = sender
        let index = btn.tag - 1
        self.resetMenu()
        if(false == btn.curSelected){
            // 生成自己的二级菜单
            sender.curSelected = true;
            if let dic = self.menuConfig[index] as? [NSObject:AnyObject]{
                
                if let subItems = dic["items"] as? [AnyObject]{
                    self.generateMenuItems(subItems, keyName: btn.keyName)
                }
                self.isExpanded = true
            }
        }
    }
    
    // 生成所有二级菜单项
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
                if let k = self.userSelectConfig?[keyName] as? Int{
                    if k == i{
                        btn.curSelected = true;
                    }
                }
                self.subItemContainer!.addSubview(btn)
            }
        }
        let rowCount:Int = (data.count-1)/4 + 1
        let offh = GalleryMenuItem_H*CGFloat(rowCount) + GalleryMenuItem_H*50.0/80.0/2.5
        self.subItemContainer?.frame = CGRectMake(0, GalleryMenuBar_H, self.frame.size.width, offh)
    }
    
    // 点击二级菜单项
    func onTapItem(item:GalleryMenuItem) {
        print("----------sub menu items title:\(item.titleLabel?.text), tagIndex:\(item.tag)")
        for v in self.subItemContainer!.subviews{
            if let i = v as? GalleryMenuItem{
                if i != item{
                    i.curSelected = false
                }
            }
        }
        item.curSelected = true
        // 更新设置
        self.userSelectConfig?.updateValue(item.tag, forKey: item.keyName)
        // 更新Btn显示
        for v in self.btnBgContainer!.subviews{
            if let b = v as? GalleryMenuButtton{
                if b.keyName == item.keyName{
                    b.btnText = item.titleForState(UIControlState.Normal)!
                }
            }
        }
        // 点击动作，进入下一个页面
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            
            self.resetMenu()
            if (self.tapItemHandler != nil && self.userSelectConfig != nil) {
                self.tapItemHandler?(config:self.userSelectConfig!)
            }
        })
    }
    
    // 复位所有菜单状态
    func resetMenu(){
        // 收起菜单
        self.isExpanded = false
        // 一级项置灰
        for v in self.btnBgContainer!.subviews{
            if let b = v as? GalleryMenuButtton{
                b.curSelected = false
            }
        }
        // 清空二级项
        for v in self.subItemContainer!.subviews{
            v.removeFromSuperview()
        }
    }
    
    // 点击菜单覆盖的黑色半透明区域，收起菜单
    func onTapMenu(){
        self.resetMenu()
    }
}