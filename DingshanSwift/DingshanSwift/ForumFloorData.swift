//
//  ForumFloorData.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/9.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
let kForumFloorEdgeWidth:CGFloat = 15.0
let kMinForumLordFloorContentHieght:CGFloat = 60.0
let kForumLordFloorContentWidth = UIScreen.mainScreen().bounds.width - 2.0*kForumFloorEdgeWidth
let kForumFollowingFloorContentWidth = UIScreen.mainScreen().bounds.width - 2.0*kForumFloorEdgeWidth - 50
let kForumFloorCellContentFont = UIFont.systemFontOfSize(16.0)
class ForumFloorData : NSObject {
    var floorId:Int = 0
    var contentText:String = ""
    var isLordFloor:Bool = false
    
    var rowHeight:CGFloat = 0.0
    var contentAttrString:NSAttributedString?
    
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
        let widthLimit = isLordFloor ? kForumLordFloorContentWidth : kForumFollowingFloorContentWidth
        let sz:CGSize = TTTAttributedLabel.sizeThatFitsAttributedString(contentAttrString, withConstraints: CGSizeMake(widthLimit, CGFloat.max), limitedToNumberOfLines: UInt.max)
        rowHeight = sz.height
        return max(rowHeight, kMinForumLordFloorContentHieght)
    }
    
    
}