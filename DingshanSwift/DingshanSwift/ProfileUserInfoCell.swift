//
//  ProfileUserInfoCell.swift
//  DingshanSwift
//
//  Created by xiong qi on 15/11/18.
//  Copyright © 2015年 song jufeng. All rights reserved.
//

import Foundation

class ProfileUserInfoCell:UITableViewCell
{
    var parentdelegate:ProfileViewController?
    var infoView = UIView()
    private var userNameLabel = UILabel()
    private var userHeadView = UIButton()
    private var userHeadImg = UIImageView()
    
    override init(style astyle:UITableViewCellStyle, reuseIdentifier str:String?) {
        super.init(style:astyle, reuseIdentifier:str)
        self.backgroundColor = UIColor.whiteColor()
        
        infoView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 198)
        infoView.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
        self.addSubview(infoView)
        
        let loginBtn = UIButton(frame: CGRect(x:0, y:20, width:100, height:50));
        loginBtn.backgroundColor = UIColor.lightGrayColor()
        loginBtn.setTitle("login", forState: UIControlState.Normal)
        loginBtn.addTarget(self, action:Selector("onTapLogin:"), forControlEvents: UIControlEvents.TouchUpInside)
        infoView.addSubview(loginBtn)
        
        userHeadView.frame = CGRect(x: (self.bounds.size.width - 73)*0.5, y: 50, width: 73, height: 73)
        userHeadView.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.2)
        userHeadView.setImage(UIImage(named:"user_head_default"), forState: UIControlState.Normal)
        userHeadView.layer.cornerRadius = userHeadView.bounds.width * 0.5
        userHeadView.addTarget(self, action: Selector("onTapEditInfo:"), forControlEvents: UIControlEvents.TouchUpInside)
        infoView.addSubview(userHeadView)
        
        userHeadImg.frame = userHeadView.bounds
        userHeadView.addSubview(userHeadImg)
        
        userNameLabel.frame = CGRect(x: 20, y: 128, width: self.bounds.size.width - 40, height: 16)
        userNameLabel.font = UIFont.systemFontOfSize(15.0)
        userNameLabel.textAlignment = NSTextAlignment.Center
        userNameLabel.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.2)
        infoView.addSubview(userNameLabel)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func clearData()
    {
        
    }
    func loadCellData(data:Dictionary<String,String>)
    {
        
    }
    
    func refreshInfo(){
        if MainConfig.sharedInstance.userLoginDone{
            let info = MainConfig.sharedInstance.userInfo
            userNameLabel.text = info.userName
            userHeadImg.sd_setImageWithURL(NSURL(string: info.userHeadUrl))
        }
    }
    
    func onTapLogin(sender:UIButton) {
        
        if self.parentdelegate != nil {
            self.parentdelegate?.onTapLogin()
        }
    }
    
    func onTapEditInfo(sender:UIButton) {
        if self.parentdelegate != nil {
            self.parentdelegate?.onTapEditInfo()
        }
    }
}