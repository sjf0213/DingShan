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

protocol DSLoginDelegate{
     func loginByWeixin()
     func assignNewUser()
}

protocol DSOSSDelegate{
    func uploadAliyunOSSImage(url:NSURL)
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
    let accessKey = "3YpqwaeHIWQlIJQk"
    let secretKey = "z9Pq9bnY6pzKzGnoS3DEz8END8lwwm"
    let userImageBucket = "dingshanimage"
    let uploadDataPath = "userupload"
    let downloadObjectKey = "userupload/001.jpg"
    let uploadObjectKey = "userupload/test.jpg"
    
    private var bucket:OSSBucket?
//    private var ossDownloadData:OSSData?
//    private var ossUploadData:OSSData?
//    private var ossRangeData:OSSData?
//    
//    private var fileDownloadData:OSSFile?
//    private var fileUploadData:OSSFile?
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
        self.initOSSService()
        tabbar = TabBarView(frame: CGRect(x: 0, y: self.view.bounds.height - MAIN_TAB_H, width: self.view.bounds.width, height: MAIN_TAB_H))
        tabbar?.delegate = self;
        tabbar?.setHomeIndex(0);
        self.view.addSubview(tabbar!)
//        let config = MainConfig.sharedInstance
    }
    
    func initOSSService(){
        let ossService = ALBBOSSServiceProvider.getService()
        ossService.setGlobalDefaultBucketAcl(PRIVATE)
        ossService.setGlobalDefaultBucketHostId(HostName)
        ossService.setAuthenticationType(ORIGIN_AKSK)
        ossService.setGenerateToken { (method, md5, type, date, xoss, resource) -> String! in
            let content = String(format:"%@\n%@\n%@\n%@\n%@%@", method, md5, type, date, xoss, resource)
            var signature = OSSTool.calBase64Sha1WithData(content, withKey: self.secretKey)
            signature = String(format:"OSS %@:%@", self.accessKey, signature)
            print("Signature:\(signature)");
            return signature
        }
        bucket = ossService.getBucket(self.userImageBucket)
        
//        ossDownloadData = ossService.getOSSDataWithBucket(bucket, key: downloadObjectKey)
//        ossUploadData = ossService.getOSSDataWithBucket(bucket, key:uploadObjectKey)
//        
//        let uploadData = UIImageJPEGRepresentation(UIImage(named: "home_ad.jpg")!, 0.21)
//        ossUploadData!.setData(uploadData, withType:"jpg")
//        ossUploadData!.enableUploadCheckMd5sum(true)
//        
//        ossRangeData = ossService.getOSSDataWithBucket(bucket, key:downloadObjectKey)
//        ossRangeData!.setRangeFrom(10, to: 20)
//        
//        fileDownloadData = ossService.getOSSFileWithBucket(bucket, key:downloadObjectKey)
//        fileUploadData = ossService.getOSSFileWithBucket(bucket, key:uploadObjectKey)
//        fileUploadData!.setPath(uploadDataPath, withContentType:"jpg")
    }
}

extension MainViewController : DSOSSDelegate{
    func uploadAliyunOSSImage(url:NSURL){
        //        let fileURL = NSBundle.mainBundle().URLForResource("Default", withExtension: "png")
        //        Alamofire.upload(.POST, "http://httpbin.org/post", file: fileURL!)
        
//        fileUploadData = ossService.getOSSFileWithBucket(bucket, key:uploadObjectKey)
//        fileUploadData!.setPath(uploadDataPath, withContentType:"jpg")
//        dispatch_async{dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) -> Void in
            //            self.taskHandler = ossUploadData.uploadWithUploadCallback{(isSuccess, error) {
            //                    if (isSuccess) {
            //                    NSLog(@"suceess!");
            //                    } else {
            //                    NSLog(@"failed! Error message: %@", error);
            //                    }
            //                    } withProgressCallback:^(float progress) {
            //                    NSLog(@"current progress: %f", progress);
            //                    dispatch_async(dispatch_get_main_queue(), ^{
            //                    [_ossDataProgressView setProgress:progress];
            //                    });
            //                }
            //            }
        
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
