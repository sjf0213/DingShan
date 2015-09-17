//
//  ForumFloorData.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/9.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class ForumFloorData : NSObject {
    var floorId:NSInteger = 0
    var contentText:String = ""
    
    required override init() {
        super.init()
    }
    
    init( dic : [String: AnyObject]){
        if let num = dic["floor_id"] as? String {
            floorId = Int(num)!
            print("-+- floorId = \(floorId)", terminator: "")
        }
        //        topicId = dic["topic_id"]?.integerValue
        if let tmp = dic["floor_content"] as? String{
            contentText = tmp
            print("-+- contentText = \(contentText)", terminator: "")
        }
    }
}