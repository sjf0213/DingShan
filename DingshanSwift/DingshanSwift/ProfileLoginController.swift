//
//  ProfileLoginController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/15.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class ProfileLoginController: DSViewController {
    var loginDele:loginDelegate?
    override func loadView()
    {
        super.loadView()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let wxLoginBtn = UIButton(frame: CGRect(x:(self.view.bounds.size.width - 200)*0.5, y:self.view.bounds.size.height - 200, width:200, height:50));
        wxLoginBtn.backgroundColor = UIColor(red: 0, green: 212/255.0, blue: 44/255.0, alpha: 1.0)
        wxLoginBtn.setTitle("微信登录", forState: UIControlState.Normal)
        wxLoginBtn.addTarget(self, action:Selector("onTapLogin"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(wxLoginBtn)
    }
    
    func onTapLogin(){
        self.loginDele?.loginByWeixin()
    }
}