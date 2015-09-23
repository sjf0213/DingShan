//
//  TopBarView.swift
//  DingshanSwift
//
//  Created by 宋炬峰 on 15/8/29.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class TopBarView:UIView
{
    var title = ""{
        didSet{
            self.titleLabel.text = title
        }
    }
    var backBtnHidden = false{
        didSet{
            self.backBtn.hidden = backBtnHidden
        }
    }
    
    var backBlock: (() -> Void)? // 最简单的闭包，用来navi返回按钮
    
    private var titleLabel = UILabel()
    private var backBtn = UIButton()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame aRect: CGRect) {
        super.init(frame: aRect);
        self.backgroundColor = NAVI_COLOR
        let topline = UIView(frame: CGRect(x: 0, y: TopBar_H - 0.5, width: self.bounds.width, height: 0.5))
        topline.backgroundColor = UIColor.grayColor()
        self.addSubview(topline)
        
        titleLabel = UILabel(frame: CGRect(x:44, y:20, width:self.bounds.size.width - 88, height:self.bounds.size.height - 20))
        titleLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(titleLabel)
        
        backBtn.frame = CGRect(x: 0, y: 20, width: 44, height: 44)
        backBtn.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.5)
        self.addSubview(backBtn)
        backBtn.addTarget(self, action: Selector("onTapBack"), forControlEvents: UIControlEvents.TouchUpInside)

    }
    
    func onTapBack() {
        self.backBlock?()
    }
}