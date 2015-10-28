//
//  MainViewController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/7/14.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

//import Foundation
import UIKit

let WeixinAppId = "wx68cd5ad635a52c78"
let WeixinAppSecret = "52e1e407ce34ac5c71f02d7f1d4fd2b8"

protocol DSLoginDelegate{
     func loginByWeixin()
     func assignNewGuestUser()
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
        let _ = MainConfig.sharedInstance
        
        

    }
    
    override func viewDidAppear(animated: Bool) {
        // 弹出登录页面
        //        if false == MainConfig.sharedInstance.userLoginDone{
//        let loginController = ProfileLoginController()
//        loginController.loginDelegate = self
//        self.presentViewController(loginController, animated: true, completion: nil)
        //        }
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
                print("WeixinCallback.onResp, temp.code = \(temp.code) temp.code, temp.state = \(temp.state)")
                let url = String(format:"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WeixinAppId, WeixinAppSecret, temp.code)
                print("\n onResp.url- - - - = \(url)")
                // 通过微信api请求access_token
                let request = NSURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 3)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, err) -> Void in
                    print("\n response- - - - = \(response)")
                    if let resp = response as? NSHTTPURLResponse{
                        if 200 == resp.statusCode {
                            do{
                                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                                print("\n onResp.response.json- - - - = \(json)")
                                if let dic = json as? [NSObject:AnyObject]{
                                    if let tocken = dic["access_token"] as? String{
                                        if let oid = dic["openid"] as? String{
                                            self.fetchUserInfoFromWeixin(tocken, openid: oid)
                                        }
                                    }
                                }
                            }catch{
                                print("\n onResp.response- - - - error =", error)
                            }
                        }
                    }
                })
            }
        }
    }
    
    // // 通过微信api请求用户的个人信息
    func fetchUserInfoFromWeixin(accessTocken:String, openid:String){
        let url = String(format:"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessTocken, openid)
        // 通过微信api请求access_token
        let request = NSURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 3)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, err) -> Void in
            
            print("\n response- - - - = \(response)")
            if let resp = response as? NSHTTPURLResponse{
                if 200 == resp.statusCode {
                    do{
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                        print("\n onResp.response.json- - - - = \(json)")
                        if let wxInfoDic = json as? [NSObject:AnyObject]{
                            if let unionid = wxInfoDic["unionid"] as? String{
                                let unionid = String(format: "wx_unionid_%@", unionid)
                                self.requireNewUserBySomeId(unionid, completion:{(info:[NSObject:AnyObject]) -> Void in
                                    //成功申请新用户之后覆盖微信的用户信息
                                    let name = wxInfoDic["nickname"] as? String
                                    let headimgurl = wxInfoDic["headimgurl"] as? String
                                    if name != nil && headimgurl != nil{
                                        var destDic = Dictionary<String,AnyObject>()
                                        destDic["nickname"] = name
                                        destDic["imgurl"] = headimgurl
                                        //用拿到的微信数据更新用户信息
                                        self.updateUserInfo(destDic, completion:{(info:[NSObject:AnyObject]) -> Void in
                                            self.storeUserInfo(info)
                                        })
                                    }
                                })
                            }
                        }
                    }catch{
                        print("\n onResp.response- - - - error =", error)
                    }
                }
            }
        })
    }
    
    func storeUserInfo(info:[NSObject:AnyObject]){
        print("\n dic = \(info)")
        MainConfig.sharedInstance.userInfo = UserInfoData(dic: info)
        MainConfig.sharedInstance.userLoginDone = true
        print("\n MainConfig.sharedInstance.userInfo = \(MainConfig.sharedInstance.userInfo)")
        NSNotificationCenter.defaultCenter().postNotificationName(Notification_LoginSucceed, object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName(Notification_UpdateUserInfo, object: nil)
    }
}

extension MainViewController : DSLoginDelegate
{
    // 自动分配一个新用户，相当于游客身份
    func assignNewGuestUser(){
        self.requireNewUserBySomeId(OpenUDID.value(), completion:{(info:[NSObject:AnyObject]) -> Void in
            self.storeUserInfo(info)
        })
    }
    
    // 微信登录
    func loginByWeixin(){
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo"
        req.state = "xxx123"
        WXApi.sendAuthReq(req, viewController: self, delegate: self)
    }
    
    // 用ID（比如微信的unionid）注册一个新用户
    func requireNewUserBySomeId(someId:String,
                     completion:((info:[NSObject:AnyObject]) -> Void)?){
        let parameter = ["did" : someId,
                        "json" : "1"]
        let url = ServerApi.user_create_new(parameter)
        print("+++++++++url = \(url)")
        AFDSClient.sharedInstance.GET(url, parameters: nil,
            success: {(task, JSON:AnyObject) -> Void in
                print("\n requireNewUserBySomeId.responseJSON- - - -  = \(JSON)")
                // 如果请求数据有效
                if let dic = JSON as? [String:AnyObject]{
                    print("\n response- - -dic = \(dic)")
                    if let dingshanInfoNewUserInfoDic = dic["v"] as? [String:AnyObject]{
                        if (completion != nil){
                            completion?(info: dingshanInfoNewUserInfoDic)
                        }
                    }
                }
            }, failure: {( task, error) -> Void in
                print("\n failure: TIP --- e:\(error)")
            })
    }

//MARK - 有待使用真正的用户系统，改造
    // 用微信用户数据更新服务器用户信息
    func updateUserInfo(dic:[String:AnyObject],
                completion:((info:[NSObject:AnyObject]) -> Void)?){
        let url = ServerApi.user_update_info()
        let postBody = dic
        AFDSClient.sharedInstance.POST(url, parameters: postBody,
            success: {(task, JSON:AnyObject) -> Void in
                print("\n updateUserInfo.responseJSON- - - - -data = \(JSON)")
                if let v = JSON as? [String:AnyObject]{
                    if let updatedUserInfoDic = v["v"] as? [String:AnyObject]{
                        if (completion != nil){
                            completion?(info: updatedUserInfoDic)
                        }
                    }
                }
            }, failure: {( task, error) -> Void in
                print("\n failure: TIP --- e:\(error)")
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
