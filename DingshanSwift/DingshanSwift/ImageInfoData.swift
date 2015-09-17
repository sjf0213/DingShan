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
            print("-+- imageId = \(imageId)", terminator: "")
        }
        if let tmp = dic["image_url"] as? String{
            url = tmp
            print("-+- url = \(url)", terminator: "")
        }
        if let tmp = dic["image_name"] as? String{
            desc = tmp
            print("-+- desc = \(desc)", terminator: "")
        }
        if let num = dic["image_width"] as? NSNumber {
            width = num.integerValue
            print("-+- width = \(width)", terminator: "")
        }
        if let num = dic["image_height"] as? NSNumber {
            height = num.integerValue
            print("-+- height = \(height)", terminator: "")
        }
    }
}