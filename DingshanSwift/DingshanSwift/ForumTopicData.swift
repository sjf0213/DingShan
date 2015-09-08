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
        if let num = dic["topic_id"] as? NSNumber {
            topicId = num.integerValue;
            print("-+- topicId = \(topicId)")
        }
        if let tmp = dic["topic_title"] as? String{
            topicTitle = tmp
            print("-+- topicTitle = \(topicTitle)")
        }
    }
}