//
//  ForumTopicData.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/8.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class ForumTopicData : NSObject {
    var topicId:NSInteger = 0
    var topicTitle:String = ""
    
    required override init() {
        super.init()
    }
    
    init( dic : [String: AnyObject]){
        if let num = dic["topic_id"] as? String {
            topicId = num.toInt()!
            print("-+- topicId = \(topicId)")
        }
//        topicId = dic["topic_id"]?.integerValue
        if let tmp = dic["topic_title"] as? String{
            topicTitle = tmp
            print("-+- topicTitle = \(topicTitle)")
        }
    }
}