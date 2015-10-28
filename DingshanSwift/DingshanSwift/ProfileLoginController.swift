//
//  ProfileLoginController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/15.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class ProfileLoginController: DSViewController {
    var loginDelegate:AnyObject?
    override func loadView()
    {
        super.loadView()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let wxLoginBtn = UIButton(frame: CGRect(x:(self.view.bounds.size.width - 200)*0.5, y:self.view.bounds.size.height - 200, width:200, height:50));
        wxLoginBtn.backgroundColor = UIColor(red: 0, green: 212/255.0, blue: 44/255.0, alpha: 1.0)
        wxLoginBtn.setTitle("微信登录", forState: UIControlState.Normal)
        wxLoginBtn.addTarget(self, action:Selector("onTapLogin"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(wxLoginBtn)
        
        let skipBtn = UIButton(frame: CGRect(x:(self.view.bounds.size.width - 100)*0.5, y:self.view.bounds.size.height - 140, width:100, height:50));
        skipBtn.backgroundColor = UIColor.grayColor()
        skipBtn.setTitle("跳过", forState: UIControlState.Normal)
        skipBtn.addTarget(self, action:Selector("onTapSkip"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(skipBtn)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onClose"), name: Notification_LoginSucceed, object: nil)
    }
    
    func onTapLogin(){
        if let delegate = self.loginDelegate as? DSLoginDelegate{
            delegate.loginByWeixin()
        }
    }
    
    func onTapSkip(){
        if let delegate = self.loginDelegate as? DSLoginDelegate{
            delegate.assignNewGuestUser()
        }
    }
    func onClose(){
        print("---ProfileLoginController on close ")
        if (self.navigationController?.visibleViewController == self){
            self.navigationController?.popViewControllerAnimated(true);
        }else{
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}