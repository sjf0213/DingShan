//
//  ImageInfoData.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/10.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class ImageInfoData: NSObject {
    var imageId:NSInteger = 0
    var desc:String = ""
    var url:String = ""
    var width:NSInteger = 0
    var height:NSInteger = 0
    required override init() {
        super.init()
    }
    
    init( dic : [String: AnyObject]){
        if let num = dic["image_id"] as? NSNumber {
            imageId = num.integerValue
        }
        if let tmp = dic["image_url"] as? String{
            url = tmp
        }
        if let tmp = dic["image_name"] as? String{
            desc = tmp
        }
        if let num = dic["image_width"] as? NSNumber {
            width = num.integerValue
        }
        if let num = dic["image_height"] as? NSNumber {
            height = num.integerValue
        }
    }
}