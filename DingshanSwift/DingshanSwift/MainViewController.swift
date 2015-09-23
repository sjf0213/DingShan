//
//  MainViewController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/7/14.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

//import Foundation
import UIKit
import Alamofire

protocol loginDelegate{
     func loginByWeixin()
     func assignNewUser()
}

class MainViewController:UIViewController,UIAlertViewDelegate,WXApiDelegate
{
    var tabbar:TabBarView?
    var homeController:HomeController?
    var homeNavi:UINavigationController?
    var galleryController:GalleryViewController?
    var galleryNavi:UINavigationController?
    var profileController:ProfileViewController?
    var profileNavi:UINavigationController?
    
    var request: Alamofire.Request? {
        didSet {
            oldValue?.cancel()
        }
    }
    override func loadView(){
        super.loadView()
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidLoad() {
        tabbar = TabBarView(frame: CGRect(x: 0, y: self.view.bounds.height - MAIN_TAB_H, width: self.view.bounds.width, height: MAIN_TAB_H))
        tabbar?.delegate = self;
        tabbar?.setHomeIndex(0);
        self.view.addSubview(tabbar!)
//        let config = MainConfig.sharedInstance
    }
}

extension MainViewController : loginDelegate
{
    func loginByWeixin(){
        self.sendAuthRequest()
    }
    // 微信登录
    func sendAuthRequest(){
        let req = SendAuthReq()
        req.scope = "snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"
        req.state = "xxx"
        req.openID = "0c806938e2413ce73eef92cc3";
        WXApi.sendAuthReq(req, viewController: self, delegate: self)
    }
    // 微信登录回调
    func onResp(resp:BaseResp){
        self.requireNewUserByDid(String(format: "wx_register_%@", "weixinID001"))
        
        if let temp = resp as? SendAuthResp {
            if(nil != temp.code && nil != temp.state){
                let strTitle = "Auth结果"
                let strMsg = String(format: "code:%@,state:%@,errcode:%zd", temp.code, temp.state, temp.errCode)
                let alert = UIAlertView(title: strTitle, message: strMsg, delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
        }
    }
    
    /////////////////分配新用户
    func assignNewUser(){
        self.requireNewUserByDid(OpenUDID.value())
    }
    
    func requireNewUserByDid(did:String){
        let parameter = ["did" : did,
                        "json" : "1"]
        let url = ApiBuilder.user_create_new(parameter)
        print("+++++++++url = \(url)", terminator: "")
        self.request = Alamofire.request(.GET, url)
        // JSON
        self.request?.responseJSON(completionHandler: {(request, response, result) -> Void in
            print("\n responseJSON- - - - -data = \(result)")
            // 如果请求数据有效
            if let dic = result.value as? NSDictionary{
                print("\n response- --dic = \(dic)")
            }
        })
    }
}


extension MainViewController : TabBarViewDelegate
{
    func didSelectTabButton(tag:Int)
    {
        print("..."+String(tag), terminator: "")
        
        switch tag {
        case 0:
            if homeController == nil{
                homeController = HomeController()
                homeNavi = UINavigationController(rootViewController: homeController!)
                self.view.addSubview(homeNavi!.view)
            }
            tabbar?.removeFromSuperview()
            homeController?.view.addSubview(tabbar!)
            self.view.bringSubviewToFront(homeNavi!.view)
            break
        case 1:
            if galleryController == nil{
                galleryController = GalleryViewController()
                galleryNavi = UINavigationController(rootViewController: galleryController!)
                self.view.addSubview(galleryNavi!.view)
            }
            tabbar?.removeFromSuperview()
            galleryController?.view.addSubview(tabbar!)
            self.view.bringSubviewToFront(galleryNavi!.view)
            break
        case 2:
            if profileController == nil{
                profileController = ProfileViewController()
                profileController?.loginDele = self
                profileNavi = UINavigationController(rootViewController: profileController!)
                self.view.addSubview(profileNavi!.view)
            }
            tabbar?.removeFromSuperview()
            profileController?.view.addSubview(tabbar!)
            self.view.bringSubviewToFront(profileNavi!.view)
            break
        default:
            break
        }
        self.view.bringSubviewToFront(tabbar!)
    }
}
