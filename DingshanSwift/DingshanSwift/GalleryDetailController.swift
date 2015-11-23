//
//  GalleryDetailController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/6.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation

class GalleryDetailController: DSViewController {
    var container:ScrollContainerView?
    var topBar:GalleryDetailTopBar?
    override func loadView(){
        super.loadView()
        self.view.backgroundColor = UIColor.blackColor()
        
        // 单击手势
        let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("onTapView"))
        self.view.addGestureRecognizer(tapRecognizer)
        
    }
    
    override func viewDidLoad() {
        container = ScrollContainerView(frame: self.view.bounds);
        self.view.addSubview(container!)
        
        
        topBar = GalleryDetailTopBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 64));
        self.view.addSubview(self.topBar!)
        topBar?.backBlock = {self.navigationController?.popViewControllerAnimated(true)}
    }
    
    override func viewDidAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
    func loadImageData(data:ImageInfoData){
        let arr:[AnyObject] = [data.url]
        dispatch_async(dispatch_get_main_queue(),{ [weak self]() -> Void in
            self?.container?.addDataSourceByArray(arr)
        })
    }
    
    func startRequest(imageSetId:Int){
        
        let parameter:[NSObject:AnyObject] = [ "iid" : String(imageSetId),
                                              "json" : "1"]
        let url = ServerApi.gallery_get_galary_detail(parameter)
         print("\n---$$$---url = \(url)", terminator: "")
        AFDSClient.sharedInstance.GET(url, parameters: nil,
            success: {[weak self](task, JSON) -> Void in
                print("\n responseJSON- - - - -data = \(JSON)")
                // 如果请求数据有效
                if let dic = JSON as? [NSObject:AnyObject]{
                    // print("\n responseJSON- - - - -data:", dic)
                    self?.processRequestResult(dic)
                }
            }, failure: {( task, error) -> Void in
                print("\n failure: TIP --- e:\(error)")
            })
    }
    
    func processRequestResult(result:[NSObject:AnyObject]){
        if (200 == result["c"]?.integerValue){
            if let list = result["v"] as? [AnyObject]{
                var urlArr:[AnyObject] = [AnyObject]()
                for item in list{
                    if let dic = item as? [NSObject: AnyObject]{
                        let data = ImageInfoData(dic: dic)
                        urlArr.append(data.url)
                    }
                }
                print("urlArr = \(urlArr)")
                dispatch_async(dispatch_get_main_queue(),{ () -> Void in
                    self.container?.addDataSourceByArray(urlArr)
                })
            }
        }
    }
    
    func onTapView(){
        print("onTapView = = = = = =  == ")
    }
}