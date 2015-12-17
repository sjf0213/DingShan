//
//  ForumTopicData.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/8.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class ForumTopicData : NSObject {
    var topicId:Int = 0
    var title:String = ""
    var contentText:String = ""
    
    var rowHeight:CGFloat = 0.0
    var contentAttrString:NSAttributedString?
    var labelConstraintsSize:CGSize?
    override var description : String {
        
        var str = "--------------------------"
        str += "\n topicId = " + String(topicId)
        str += "\n title = " + title
        str += "\n contentText = " + contentText
        return str
    }
    required override init() {
        super.init()
    }
    
    init( dic : [NSObject: AnyObject]){
//        let num1 = dic["topic_id"]
//        print("num:\(num1)",num1.dynamicType)
        if let s = dic["topic_id"] as? String {
            if let n = Int(s){
                topicId = n
            }
        }else{
            if let n = dic["topic_id"] as? NSNumber{
                topicId = n.integerValue
            }
        }
        if let tmp = dic["topic_title"] as? String{
            title = tmp
        }
        if let tmp = dic["topic_content"] as? String{
            contentText = tmp
            if(nil == contentAttrString){
                contentAttrString = NSAttributedString(string: tmp)
            }
        }
    }
    
    func getCalculatedRowHeight() -> CGFloat
    {
        if (rowHeight > 0){
            return rowHeight
        }else {
            return self.calculateRowHeight()
        }
    }
    
    func calculateRowHeight() -> CGFloat
    {
        // 正文与图片
        var constraints:CGSize = CGSizeZero;
        if ((self.labelConstraintsSize) != nil){
            constraints = self.labelConstraintsSize!
        }
//        let widthLimit = kForumLordFloorContentWidth
        let sz:CGSize = TTTAttributedLabel.sizeThatFitsAttributedString(contentAttrString, withConstraints: constraints, limitedToNumberOfLines: 1024)
        rowHeight = sz.height
        debugPrint("----------------ForumTopicData.calculateRowHeight.sz = \(sz)")
        return max(rowHeight, kMinForumLordFloorContentHieght)
        
    }
}