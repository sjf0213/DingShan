//
//  ProfileViewController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/7/14.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import UIKit

class ProfileViewController:DSViewController
{
    var loginDele:loginDelegate?
    var mainTable = UITableView()
    var infoView = UIView()
    override func loadView()
    {
        super.loadView()
        self.view.backgroundColor = UIColor.whiteColor()
        
        mainTable.frame = self.view.bounds
        mainTable.contentInset = UIEdgeInsets(top: HomeAd_H, left: 0, bottom: 0, right: 0)
        self.view.addSubview(self.mainTable)
        
        infoView.frame = CGRect(x: 0, y: 0-self.mainTable.contentInset.top, width: self.mainTable.bounds.width, height: self.mainTable.contentInset.top)
        self.mainTable.addSubview(infoView)
        
        var loginBtn = UIButton(frame: CGRect(x:(self.view.bounds.size.width - 100)*0.5, y:100, width:100, height:50));
        loginBtn.backgroundColor = UIColor.lightGrayColor()
        loginBtn.setTitle("login", forState: UIControlState.Normal)
        loginBtn.addTarget(self, action:Selector("onTapLogin:"), forControlEvents: UIControlEvents.TouchUpInside)
        infoView.addSubview(loginBtn)
    }
    
    func onTapLogin(sender:UIButton) {
        print("onTapLogin")
        var controller = ProfileLoginController()
        controller.loginDele = self.loginDele
        self.navigationController?.pushViewController(controller, animated: true)
    }
}