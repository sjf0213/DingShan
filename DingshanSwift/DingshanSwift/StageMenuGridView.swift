//
//  StageMenuGridView.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/12/23.
//  Copyright © 2015年 song jufeng. All rights reserved.
//

import Foundation
class StageMenuGridView : UIView{
    var tapItemHandler : ((index:Int, title:String) -> Void)?// 用户点击处理
    var userSelectIndex:Int = 0
    var container_h:CGFloat = 0.0
    var subItemContainer = UIView()// 按钮容器
    // MARK: init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect)
        self.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.3)
        self.clipsToBounds = true
        
        self.subItemContainer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 0))
        self.subItemContainer.backgroundColor = UIColor.whiteColor()
        self.subItemContainer.clipsToBounds = true
        self.addSubview(self.subItemContainer)
    }
    
    func loadMenuItems(arr:[AnyObject]){
        // 生成所有菜单项
        let w:CGFloat = UIScreen.mainScreen().bounds.width / 2
        let h:CGFloat = 58
        for (var i = 0; i < arr.count; i++){
            if let one = arr[i] as? [NSObject:AnyObject]{
                let row:Int = i/2
                let col:Int = i%2
                let rect = CGRect(x: w * CGFloat(col), y: h * CGFloat(row), width: w, height: h)
                let btn = StageMenuItem(frame: rect)
                self.subItemContainer.addSubview(btn)
                btn.tag = i
                if let t = one["title"] as? String{
                    btn.setTitle(t, forState: UIControlState.Normal)
                }
                // 显示当前正在选中的项目
                if userSelectIndex == i{
                    btn.curSelected = true
                }
                btn.addTarget(self, action: Selector("onTapItem:"), forControlEvents: UIControlEvents.TouchUpInside)
            }
        }
        let rowCount:Int = (arr.count-1)/2 + 1
        self.container_h = h*CGFloat(rowCount) + 10
        self.subItemContainer.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: container_h)
        
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
        
        self.setNeedsDisplay()
        let t = item.titleForState(UIControlState.Normal)
        if (self.tapItemHandler != nil && t != nil) {
            self.tapItemHandler?(index:self.userSelectIndex, title:t!)
        }
    }
}