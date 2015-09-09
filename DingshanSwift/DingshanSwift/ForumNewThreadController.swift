//
//  ForumNewThreadController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/9.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class ForumNewThreadController : DSViewController{
    
    private var sendBtn = UIButton()
    override func loadView()
    {
        super.loadView()
        self.view.backgroundColor = UIColor.lightGrayColor()
        self.topTitle = "新话题"
        
        
        sendBtn = UIButton(frame: CGRect(x: self.view.bounds.size.width - 44, y: 20, width: 44, height: 44))
        sendBtn.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
        self.topView.addSubview(sendBtn)
        sendBtn.addTarget(self, action: Selector("onTapSend"), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    func onTapSend(){
        
    }
}