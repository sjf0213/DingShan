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
    var subItemContainer = UIView()// 按钮容器
    var mask:UIView?// 黑色半透明背景，相应点击收起
    var container_h:CGFloat = 0.0
    // 菜单内容的配置
    var menuConfig = [AnyObject](){
        didSet{
            if menuConfig.count > 0{
                if let one = menuConfig[0] as? [NSObject:AnyObject]{
                    if let title = one["title"] as? String{
                        self.mainBtn.btnText = title
                    }
                }
            }
            self.mainBtn.curSelected = false
        }
    }
    // 菜单的展开与收起
    var isExpanded:Bool = false {
        didSet{
            if isExpanded{
                
                self.frame = CGRectMake(0, 20, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height-20)
                self.mainBtn.frame = CGRect(x: 50, y: 0, width: UIScreen.mainScreen().bounds.width - 100, height: TopBar_H - 21)
                print("-- - ****2222 self.mainBtn.frame = \(self.mainBtn.frame)")
                self.mainBtn.curSelected = true
                // 点击菜单覆盖的黑色半透明区域，收起菜单
                self.mask = UIView(frame: CGRect(x: 0, y: TopBar_H-20, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height-TopBar_H+20))
                self.mask?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
                self.mask?.alpha = 0.0
                let tapRec = UITapGestureRecognizer(target: self, action: Selector("resetMenu"))
                self.mask?.addGestureRecognizer(tapRec)
                self.insertSubview(self.mask!, belowSubview: self.subItemContainer)
                
                
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options:UIViewAnimationOptions([.AllowUserInteraction, .BeginFromCurrentState]), animations: { () -> Void in
                    self.subItemContainer.frame = CGRectMake(0, TopBar_H-20, UIScreen.mainScreen().bounds.width, self.container_h)
                    self.mask?.alpha = 1.0
                    }, completion: { (finished) -> Void in
                        print("self.mainBtn.frame = \(self.mainBtn.frame)")
                })
                
            }else{
                self.frame = CGRectMake(50, 20, UIScreen.mainScreen().bounds.width - 100, TopBar_H - 20)
                self.mainBtn.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width - 100, height: TopBar_H - 21)
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options:UIViewAnimationOptions([.AllowUserInteraction, .BeginFromCurrentState]), animations: { () -> Void in
                    self.subItemContainer.frame = CGRect(x: 0, y: TopBar_H-20, width: UIScreen.mainScreen().bounds.width, height: 0)
                    }, completion: { (finished) -> Void in
                        self.mainBtn.curSelected = false
                        self.mask?.removeFromSuperview()
                        self.mask = nil
                })
            }
        }
    }
    
    // MARK: init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect);
        self.backgroundColor = UIColor.clearColor()
        self.clipsToBounds = true
        
        self.subItemContainer = UIView(frame: CGRect(x: 0, y: TopBar_H-20, width: UIScreen.mainScreen().bounds.width, height: 0))
        self.subItemContainer.backgroundColor = UIColor.whiteColor()
        self.subItemContainer.clipsToBounds = true
        self.addSubview(self.subItemContainer)
        
        self.mainBtn = GalleryMenuButtton(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width - 100, height: TopBar_H - 21))
        self.mainBtn.backgroundColor = NAVI_COLOR
        self.mainBtn.setTitleColor(UIColor.blackColor(), forState:.Normal)
        self.mainBtn.addTarget(self, action: Selector("onTapMainBtn:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(self.mainBtn)
        
        self.isExpanded = false
    }
    
    override func layoutSubviews() {
//        self.btnBgContainer?.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: GalleryMenuBar_H)
    }
    
    // 复位所有菜单状态
    func resetMenu(){
        // 收起菜单
        self.isExpanded = false
        // 清空二级项
        for v in self.subItemContainer.subviews{
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
                // 显示当前正在选中的项目
                if userSelectIndex == i{
                    btn.curSelected = true
                }
                btn.addTarget(self, action: Selector("onTapItem:"), forControlEvents: UIControlEvents.TouchUpInside)
                self.subItemContainer.addSubview(btn)
            }
        }
        let rowCount:Int = (self.menuConfig.count-1)/2 + 1
        self.container_h = h*CGFloat(rowCount) + 10
        self.isExpanded = true
        
    }
    
    // 点击二级菜单项
    func onTapItem(item:GalleryMenuItem) {
        print("----------sub menu items title:\(item.titleLabel?.text), tagIndex:\(item.tag)")
        // 低亮其他
        for v in self.subItemContainer.subviews{
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
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.resetMenu()
            if (self.tapItemHandler != nil) {
                self.tapItemHandler?(index:self.userSelectIndex)
            }
//        })
    }
}