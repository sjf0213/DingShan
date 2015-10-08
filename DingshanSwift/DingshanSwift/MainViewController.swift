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

let WeixinAppId = "wx68cd5ad635a52c78"
let WeixinAppSecret = "52e1e407ce34ac5c71f02d7f1d4fd2b8"

protocol DSLoginDelegate{
     func loginByWeixin()
     func assignNewUser()
}

protocol DSOSSDelegate{
    func uploadAliyunOSSImage(url:NSURL, withKey akey:String)
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
    
    // Aliyun OSS Begin
    var ossClient:OSSClient?
    let AccessKey = "3YpqwaeHIWQlIJQk"
    let SecretKey = "z9Pq9bnY6pzKzGnoS3DEz8END8lwwm"
    let AliyunEndPoint = "oss-cn-beijing"
    let endPoint = "http://oss-cn-beijing.aliyuncs.com"
    let userImageBucket = "dingshanimage"
    let uploadDataPath = "userupload"
    // Aliyun OSS End
    
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
        //向微信注册
        WXApi.registerApp(WeixinAppId, withDescription:"iDingshanDemo")
        
        //初始化aliyun OSS
        self.initOSSClient()
        
        tabbar = TabBarView(frame: CGRect(x: 0, y: self.view.bounds.height - MAIN_TAB_H, width: self.view.bounds.width, height: MAIN_TAB_H))
        tabbar?.delegate = self;
        tabbar?.setHomeIndex(0);
        self.view.addSubview(tabbar!)
//        let config = MainConfig.sharedInstance
    }
    
    func initOSSClient() {
    
        let credential = OSSPlainTextAKSKPairCredentialProvider(plainTextAccessKey: AccessKey, secretKey:SecretKey)
        let conf = OSSClientConfiguration()
        conf.maxRetryCount = 3
        conf.enableBackgroundTransmitService = false // 是否开启后台传输服务
        conf.timeoutIntervalForRequest = 15
        conf.timeoutIntervalForResource = 24 * 60 * 60
        ossClient = OSSClient(endpoint: endPoint, credentialProvider: credential, clientConfiguration: conf)
    }
    
    func createBucket() {
        let create = OSSCreateBucketRequest()
        create.bucketName = userImageBucket
        create.xOssACL = "public-read"
        create.location = AliyunEndPoint

        let createTask = ossClient?.createBucket(create)
        createTask?.continueWithBlock{ (task) -> AnyObject! in
            if (task.error != nil) {
                print("create bucket failed, error: %@", task.error);
            } else {
                print("create bucket success!");
            }
            return nil
        }
    }
    
    // 微信登录回调
    func onResp(resp:BaseResp){
        
        if let temp = resp as? SendAuthResp {
            if(nil != temp.code && nil != temp.state){
                let url = String(format:"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WeixinAppId, WeixinAppSecret, temp.code)
                self.request = Alamofire.request(.GET, url)
                // JSON
                self.request?.responseJSON(completionHandler: {(request, response, result) -> Void in
                    print("\n responseJSON- - - - -data = \(result)")
                    // 如果请求数据有效
                    if let dic = result.value as? [String:AnyObject]{
                        print("\n response- - -dic = \(dic)")
                        if let tocken = dic["access_token"] as? String{
                            if let oid = dic["openid"] as? String{
                                self.fetchUserInfoFromWeixin(tocken, openid: oid)
                            }
                        }
                    }
                })
            }
        }
    }
    
    func fetchUserInfoFromWeixin(accessTocken:String,openid:String){
        let url = String(format:"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessTocken, openid)
        self.request = Alamofire.request(.GET, url)
        // JSON
        self.request?.responseJSON(completionHandler: {(request, response, result) -> Void in
            print("\n responseJSON- - - - -data = \(result)")
            // 如果请求数据有效
            if let dic = result.value as? [String:AnyObject]{
                print("\n response- - -dic = \(dic)")
                // 使用"unionid"注册新用户
                if let unionid = dic["unionid"] as? String{
                    self.requireNewUserByDid(String(format: "wx%@", unionid))
                }
            }
        })
    }
}

extension MainViewController : DSOSSDelegate{

    // 同步上传, 2.1版本的OSS SDK
    func uploadAliyunOSSImage(url:NSURL, withKey akey:String) {
        print("uploadAliyunOSSImage url = \(url)")
        let put = OSSPutObjectRequest()
        // required fields
        put.bucketName = userImageBucket
        put.objectKey = akey
//        let tempUrl = NSBundle.mainBundle().URLForResource("home_ad", withExtension: "jpg")
//        print("\ntempurl = \(tempUrl)")
        put.uploadingFileURL = url
        put.uploadProgress = {(bytesSent, totalBytesSent, totalBytesExpectedToSend) -> Void in
            let log = String(format:"%zd, %zd, %zd", bytesSent, totalBytesSent, totalBytesExpectedToSend)
            print("uploadProgress LOG:\(log)")
        }
        put.contentType = "";
        put.contentMd5 = "";
        put.contentEncoding = "";
        put.contentDisposition = "";
        
        let putTask = ossClient?.putObject(put)
        if putTask != nil{
            putTask!.waitUntilFinished()
            if ((putTask?.error) != nil) {
                print("upload object failed, error: %@" , putTask!.error);
            } else {
                print("upload object success!");
            }
        }
    }
}

extension MainViewController : DSLoginDelegate
{
    func loginByWeixin(){
        self.sendAuthRequest()
    }
    // 微信登录
    func sendAuthRequest(){
        let req = SendAuthReq()
//        req.scope = "snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"
        req.scope = "snsapi_userinfo"
        req.state = "xxx123"
        req.openID = OpenUDID.value()
        WXApi.sendAuthReq(req, viewController: self, delegate: self)
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
                profileController?.delegate = self
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
