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
    var ossClient:OSSClient?
    let AccessKey = "3YpqwaeHIWQlIJQk"
    let SecretKey = "z9Pq9bnY6pzKzGnoS3DEz8END8lwwm"
    let userImageBucket = "dingshanimage"
    let uploadDataPath = "userupload"
//    private var bucket:OSSBucket?
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
        self.initOSSClient()
        tabbar = TabBarView(frame: CGRect(x: 0, y: self.view.bounds.height - MAIN_TAB_H, width: self.view.bounds.width, height: MAIN_TAB_H))
        tabbar?.delegate = self;
        tabbar?.setHomeIndex(0);
        self.view.addSubview(tabbar!)
//        let config = MainConfig.sharedInstance
    }
    
//    func initOSSService(){
//        ossService = ALBBOSSServiceProvider.getService()
//        ossService?.setGlobalDefaultBucketAcl(PRIVATE)
//        ossService?.setGlobalDefaultBucketHostId(HostName)
//        ossService?.setAuthenticationType(ORIGIN_AKSK)
//        ossService?.setGenerateToken { (method, md5, type, date, xoss, resource) -> String! in
//            let content = String(format:"%@\n%@\n%@\n%@\n%@%@", method, md5, type, date, xoss, resource)
//            var signature = OSSTool.calBase64Sha1WithData(content, withKey: self.secretKey)
//            signature = String(format:"OSS %@:%@", self.accessKey, signature)
//            print("Signature:\(signature)");
//            return signature
//        }
//        bucket = ossService?.getBucket(self.userImageBucket)
//    }
    
    func initOSSClient() {
    
        let credential = OSSPlainTextAKSKPairCredentialProvider(plainTextAccessKey: AccessKey, secretKey:SecretKey)
    
        // 自实现签名，可以用本地签名也可以远程加签
//        id<OSSCredentialProvider> credential1 = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
//        NSString *signature = [OSSUtil calBase64Sha1WithData:contentToSign withSecret:@"3YpqwaeHIWQlIJQk"];
//        if (signature != nil) {
//        *error = nil;
//        } else {
//        // construct error object
//        *error = [NSError errorWithDomain:@"<your error domain>" code:OSSClientErrorCodeSignFailed userInfo:nil];
//        return nil;
//        }
//        return [NSString stringWithFormat:@"OSS %@:%@", @"z9Pq9bnY6pzKzGnoS3DEz8END8lwwm", signature];
//        }];
        
        /*
        
        // Federation鉴权，建议通过访问远程业务服务器获取签名
        // 假设访问业务服务器的获取token服务时，返回的数据格式如下：
        // {"accessKeyId":"STS.iA645eTOXEqP3cg3VeHf",
        // "accessKeySecret":"rV3VQrpFQ4BsyHSAvi5NVLpPIVffDJv4LojUBZCf",
        // "expiration":1441593388000,
        // "federatedUser":"335450541522398178:alice-001",
        // "requestId":"C0E01B94-332E-4582-87F9-B857C807EE52",
        // "securityToken":"CAES7QIIARKAAZPlqaN9ILiQZPS+JDkS/GSZN45RLx4YS/p3OgaUC+oJl3XSlbJ7StKpQp1Q3KtZVCeAKAYY6HYSFOa6rU0bltFXAPyW+jvlijGKLezJs0AcIvP5a4ki6yHWovkbPYNnFSOhOmCGMmXKIkhrRSHMGYJRj8AIUvICAbDhzryeNHvUGhhTVFMuaUE2NDVlVE9YRXFQM2NnM1ZlSGYiEjMzNTQ1MDU0MTUyMjM5ODE3OCoJYWxpY2UtMDAxMOG/g7v6KToGUnNhTUQ1QloKATEaVQoFQWxsb3cSHwoMQWN0aW9uRXF1YWxzEgZBY3Rpb24aBwoFb3NzOioSKwoOUmVzb3VyY2VFcXVhbHMSCFJlc291cmNlGg8KDWFjczpvc3M6KjoqOipKEDEwNzI2MDc4NDc4NjM4ODhSAFoPQXNzdW1lZFJvbGVVc2VyYABqEjMzNTQ1MDU0MTUyMjM5ODE3OHIHeHljLTAwMQ=="}
        id<OSSCredentialProvider> credential2 = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
        NSURL * url = [NSURL URLWithString:@"http://10.1.39.15:8080/distribute-token.json"];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        BFTaskCompletionSource * tcs = [BFTaskCompletionSource taskCompletionSource];
        NSURLSession * session = [NSURLSession sharedSession];
        NSURLSessionTask * sessionTask = [session dataTaskWithRequest:request
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
        [tcs setError:error];
        return;
        }
        [tcs setResult:data];
        }];
        [sessionTask resume];
        [tcs.task waitUntilFinished];
        if (tcs.task.error) {
        return nil;
        } else {
        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:tcs.task.result
        options:kNilOptions
        error:nil];
        OSSFederationToken * token = [OSSFederationToken new];
        token.tAccessKey = [object objectForKey:@"accessKeyId"];
        token.tSecretKey = [object objectForKey:@"accessKeySecret"];
        token.tToken = [object objectForKey:@"securityToken"];
        token.expirationTimeInMilliSecond = [[object objectForKey:@"expiration"] longLongValue];
        return token;
        }
        }];
        
        
        OSSClientConfiguration * conf = [OSSClientConfiguration new];
        conf.maxRetryCount = 3;
        conf.enableBackgroundTransmitService = NO; // 是否开启后台传输服务
        conf.timeoutIntervalForRequest = 15;
        conf.timeoutIntervalForResource = 24 * 60 * 60;
        
        ossClient = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential clientConfiguration:conf];
*/
    }
}

extension MainViewController : DSOSSDelegate{
    /* 1.3版本的OSSSDK
    func uploadAliyunOSSImage(url:NSURL){
        let uploadObjectKey = "userupload/sjf01.jpg"
        let fileUploadData = ossService?.getOSSFileWithBucket(bucket, key:uploadObjectKey)
        fileUploadData?.setPath(uploadDataPath, withContentType:"jpg")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){ ()-> Void in
            var error:NSError?
            fileUploadData?.upload(&error)
            if let actualError = error {
                print("fileSynUpload error is :\(actualError)");
            } else {
                NSLog("fileSynUpload succeed");
            }
        }
    }
*/
    
    // 2.1版本的OSS SDK
    // 同步上传
    func uploadAliyunOSSImage(url:NSURL) {
        let put = OSSPutObjectRequest()
        // required fields
        put.bucketName = "android-test"
        put.objectKey = "file1m"
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
