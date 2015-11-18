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
    override func loadView(){
        super.loadView()
        self.view.backgroundColor = UIColor.whiteColor()
        
        
    }
    
    override func viewDidLoad() {
        container = ScrollContainerView(frame: self.view.bounds);
        self.view.addSubview(container!)
    }
    
    func loadImageData(data:ImageInfoData){
        
    }
    
    func startRequest(imageSetId:Int){
        
        let parameter:[NSObject:AnyObject] = [ "iid" : String(imageSetId),
                                              "json" : "1"]
        let url = ServerApi.gallery_get_galary_detail(parameter)
        // print("\n---$$$---url = \(url)", terminator: "")
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
            if let v = result["v"] as? [NSObject:AnyObject]{
                if let list = v["image_list"] as? [AnyObject]{
                    for item in list{
                    }
                }
            }
        }
    }
}