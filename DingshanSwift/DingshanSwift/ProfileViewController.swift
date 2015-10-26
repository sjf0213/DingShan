//
//  ProfileViewController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/7/14.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import UIKit
let myTopInset:CGFloat = 295
class ProfileViewController:DSViewController
{
    var delegate:AnyObject?
    var mainTable = UITableView()
    var infoView = UIView()
    
    private var userNameLabel = UILabel()
    private var userHeadView = UIButton()
    private var userHeadImg = UIImageView()
    override func loadView()
    {
        super.loadView()
        self.topView.hidden = true
        self.view.backgroundColor = UIColor.whiteColor()
        
        mainTable.frame = self.view.bounds
        mainTable.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.2)
        mainTable.contentInset = UIEdgeInsets(top: myTopInset, left: 0, bottom: 0, right: 0)
        self.view.addSubview(self.mainTable)
        
        infoView.frame = CGRect(x: 0, y: -myTopInset-20, width: self.mainTable.bounds.width, height: 198)
        infoView.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
        self.mainTable.addSubview(infoView)
        
        let loginBtn = UIButton(frame: CGRect(x:0, y:20, width:100, height:50));
        loginBtn.backgroundColor = UIColor.lightGrayColor()
        loginBtn.setTitle("login", forState: UIControlState.Normal)
        loginBtn.addTarget(self, action:Selector("onTapLogin:"), forControlEvents: UIControlEvents.TouchUpInside)
        infoView.addSubview(loginBtn)
        
        userHeadView.frame = CGRect(x: (self.view.bounds.size.width - 73)*0.5, y: 50, width: 73, height: 73)
        userHeadView.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.2)
        userHeadView.setImage(UIImage(named:"user_head_default"), forState: UIControlState.Normal)
        userHeadView.layer.cornerRadius = userHeadView.bounds.width * 0.5
        userHeadView.addTarget(self, action: Selector("onTapEditInfo:"), forControlEvents: UIControlEvents.TouchUpInside)
        infoView.addSubview(userHeadView)
        
        userHeadImg.frame = userHeadView.bounds
        userHeadView.addSubview(userHeadImg)
        
        userNameLabel.frame = CGRect(x: 20, y: 128, width: self.view.bounds.size.width - 40, height: 16)
        userNameLabel.font = UIFont.systemFontOfSize(15.0)
        userNameLabel.textAlignment = NSTextAlignment.Center
        userNameLabel.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.2)
        infoView.addSubview(userNameLabel)
        
        let topMenuView = UIView(frame: CGRect(x: 0, y: infoView.frame.size.height - 49, width: infoView.frame.size.width, height: 49))
        topMenuView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        infoView.addSubview(topMenuView)
        
        let subleftView = UIView(frame: CGRect(x: 0, y: -myTopInset - 20 + infoView.frame.size.height + 20, width: 150, height: 78))
        subleftView.backgroundColor = UIColor.orangeColor().colorWithAlphaComponent(0.3)
        self.mainTable.addSubview(subleftView)
        
        let subrightView = UIView(frame: CGRect(x: 170, y: -myTopInset - 20 + infoView.frame.size.height + 20, width: 150, height: 78))
        subrightView.backgroundColor = UIColor.orangeColor().colorWithAlphaComponent(0.3)
        self.mainTable.addSubview(subrightView)
        
        topMenuView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        infoView.addSubview(topMenuView)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("refreshInfo"), name: Notification_UpdateUserInfo, object: nil)
        
    }
    
    func onTapLogin(sender:UIButton) {
        print("onTapLogin", terminator: "")
        let controller = ProfileLoginController()
        controller.loginDelegate = self.delegate
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func onTapEditInfo(sender:UIButton) {
        let controller = ProfileUserInfoEditController()
        controller.ossDelegate = self.delegate
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func refreshInfo(){
        if MainConfig.sharedInstance.userLoginDone{
            let info = MainConfig.sharedInstance.userInfo
            userNameLabel.text = info.userName
        }
    }
}