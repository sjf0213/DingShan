//
//  ImageInfoData.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/10.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class ImageInfoData: NSObject {
    var imageId:Int = 0
    var desc:String = ""
    var url:String = ""
    var width:Int = 0
    var height:Int = 0
    required override init() {
        super.init()
    }
    
    override var description : String {
        
        var str = "--------------------------\n image_id = "+String(imageId)
        str += "\n image_url = " + url
        str += "\n image_name = " + desc
        str += "\n w = " + String(width)
        str += "\n h = " + String(height)
        return str
    }
    
    init( dic : [NSObject:AnyObject]){
        if let s = dic["image_id"] as? String {
            if let n = Int(s){
                imageId = n
            }
        }else{
            if let n = dic["image_id"] as? NSNumber{
                imageId = n.integerValue
            }
        }
        ////////////
        if let tmp = dic["image_url"] as? String{
            url = tmp
        }
        if let tmp = dic["image_name"] as? String{
            desc = tmp
        }
        ////////////
        if let s = dic["image_width"] as? String {
            if let n = Int(s){
                width = n
            }
        }else{
            if let n = dic["image_width"] as? NSNumber{
                width = n.integerValue
            }
        }
        ////////////
        if let s = dic["image_height"] as? String {
            if let n = Int(s){
                height = n
            }
        }else{
            if let n = dic["image_height"] as? NSNumber{
                height = n.integerValue
            }
        }
    }
}