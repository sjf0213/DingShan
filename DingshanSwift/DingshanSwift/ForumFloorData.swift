//
//  ForumFloorData.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/9.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class ForumFloorData : NSObject {
    var floorId:Int = 0
    var contentText:String = ""
    var isLordFloor:Bool = false
    required override init() {
        super.init()
    }
    
    init( dic : [NSObject: AnyObject]){
        if let s = dic["floor_id"] as? String {
            if let n = Int(s){
                floorId = n
            }
        }else{
            if let n = dic["floor_id"] as? NSNumber{
                floorId = n.integerValue
            }
        }
        if let tmp = dic["floor_content"] as? String{
            contentText = tmp
        }
    }
    
    
}