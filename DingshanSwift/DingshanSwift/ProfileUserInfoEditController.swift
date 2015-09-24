//
//  ProfileUserInfoEditController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/23.
//  Copyright © 2015年 song jufeng. All rights reserved.
//

import Foundation
class ProfileUserInfoEditController : DSViewController{
    
    private var userHeadView = UIButton()
    
    override func loadView(){
        super.loadView()
        self.view.backgroundColor = UIColor(red: 0.9, green: 0.8, blue: 0.9, alpha: 1.0)
        
        userHeadView.frame = CGRect(x: (self.view.bounds.size.width - 73)*0.5, y: 50, width: 73, height: 73)
        userHeadView.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.2)
        userHeadView.layer.cornerRadius = userHeadView.bounds.width * 0.5
        userHeadView.addTarget(self, action: Selector("onTapUploadHead:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(userHeadView)
    }
    
    func onTapUploadHead(sender:UIButton) {
        
    }
}