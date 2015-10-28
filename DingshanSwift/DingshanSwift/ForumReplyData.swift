//
//  ForumReplyData.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/9.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class ForumReplyData : NSObject {
    var replyId:NSInteger = 0
    var contentText:String = ""
    
    required override init() {
        super.init()
    }
    
    init( dic : [NSObject: AnyObject]){
        if let s = dic["reply_id"] as? String {
            if let n = Int(s){
                replyId = n
            }
        }else{
            if let n = dic["reply_id"] as? NSNumber{
                replyId = n.integerValue
            }
        }
        if let tmp = dic["reply_content"] as? String{
            contentText = tmp
        }
    }
}