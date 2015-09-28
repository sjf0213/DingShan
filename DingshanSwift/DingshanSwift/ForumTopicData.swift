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
    var title:String = ""
    var contentText:String = ""
    
    required override init() {
        super.init()
    }
    
    init( dic : [String: AnyObject]){
        if let num = dic["topic_id"] as? String {
            topicId = Int(num)!
        }
        if let tmp = dic["topic_title"] as? String{
            title = tmp
        }
        if let tmp = dic["topic_content"] as? String{
            contentText = tmp
        }
    }
}