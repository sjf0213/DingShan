//
//  StageMenuView.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/11/30.
//  Copyright © 2015年 song jufeng. All rights reserved.
//

import Foundation
class StageMenuView : UIView{
    var tapItemHandler : ((index:Int) -> Void)?// 用户点击处理
    var userSelectIndex:Int = 0
    var mainBtn = GalleryMenuButtton()
    var subItemContainer:UIView?// 按钮容器
    // 菜单内容的配置
    var menuConfig = [AnyObject]()
    // 菜单的展开与收起
    var isExpanded:Bool = false {
        didSet{
            if isExpanded{
                self.mainBtn.curSelected = true
                self.frame = CGRectMake(0, 20, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height-20)
                self.mainBtn.frame = CGRectMake(50, 0, self.mainBtn.frame.size.width, self.mainBtn.frame.size.height)
            }else{
                self.mainBtn.curSelected = false
                self.frame = CGRectMake(50, 20, UIScreen.mainScreen().bounds.width - 100, TopBar_H - 20)
                self.subItemContainer?.frame = CGRectZero
                self.mainBtn.frame = self.bounds
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
        
        self.mainBtn = GalleryMenuButtton(frame: self.bounds)
        self.mainBtn.backgroundColor = UIColor.clearColor()
        self.mainBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.mainBtn.addTarget(self, action: Selector("onTapMainBtn:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(self.mainBtn)
        
        self.subItemContainer = UIView(frame: CGRectZero)
        self.subItemContainer?.backgroundColor = UIColor.whiteColor()
        self.subItemContainer?.clipsToBounds = true
        self.addSubview(self.subItemContainer!)
        
        let tapRec = UITapGestureRecognizer(target: self, action: Selector("onTapMenu"))
        self.addGestureRecognizer(tapRec)
    }
    
    override func layoutSubviews() {
//        self.btnBgContainer?.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: GalleryMenuBar_H)
    }
    
    // 复位所有菜单状态
    func resetMenu(){
        // 收起菜单
        self.isExpanded = false
        // 清空二级项
        for v in self.subItemContainer!.subviews{
            v.removeFromSuperview()
        }
    }
    
    // 点击按钮
    func onTapMainBtn(sender:UIButton) {
        if(self.isExpanded){
            self.resetMenu()
            return;
        }
        print(sender, terminator: "")
        self.resetMenu()
        // 生成所有菜单项
        let w:CGFloat = UIScreen.mainScreen().bounds.width / 2
        let h:CGFloat = 58
        for (var i = 0; i < self.menuConfig.count; i++){
            if let one = self.menuConfig[i] as? [NSObject:AnyObject]{
                let row:Int = i/2
                let col:Int = i%2
                let rect = CGRect(x: w * CGFloat(col), y: h * CGFloat(row), width: w, height: h)
                let btn = StageMenuItem(frame: rect)
                btn.tag = i
                if let t = one["title"] as? String{
                    btn.setTitle(t, forState: UIControlState.Normal)
                }
                btn.addTarget(self, action: Selector("onTapItem:"), forControlEvents: UIControlEvents.TouchUpInside)
                
                self.subItemContainer!.addSubview(btn)
            }
        }
        let rowCount:Int = (self.menuConfig.count-1)/2 + 1
        let offh = h*CGFloat(rowCount) + 10
        self.subItemContainer?.frame = CGRectMake(0, TopBar_H-20, UIScreen.mainScreen().bounds.width, offh)
        self.isExpanded = true
    }
    
    // 点击二级菜单项
    func onTapItem(item:GalleryMenuItem) {
        print("----------sub menu items title:\(item.titleLabel?.text), tagIndex:\(item.tag)")
        // 低亮其他
        for v in self.subItemContainer!.subviews{
            if let i = v as? GalleryMenuItem{
                if i != item{
                    i.curSelected = false
                }
            }
        }
        // 高亮所选
        item.curSelected = true
        // 更新设置
        userSelectIndex = item.tag
        // 更新Btn显示
        mainBtn.btnText = item.titleForState(UIControlState.Normal)!
        // 点击动作，进入下一个页面
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.resetMenu()
            if (self.tapItemHandler != nil) {
                self.tapItemHandler?(index:self.userSelectIndex)
            }
        })
    }
    
    // 点击菜单覆盖的黑色半透明区域，收起菜单
    func onTapMenu(){
        self.resetMenu()
    }
}