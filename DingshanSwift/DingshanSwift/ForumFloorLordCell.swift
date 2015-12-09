//
//  ForumFloorLordCell.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/23.
//  Copyright © 2015年 song jufeng. All rights reserved.
//

import Foundation
class ForumFloorLordCell : ForumFloorCell{
    
    override init(style astyle:UITableViewCellStyle, reuseIdentifier str:String?) {
        super.init(style:astyle, reuseIdentifier:str)
        self.backgroundColor = UIColor.orangeColor().colorWithAlphaComponent(0.2)
        
        attrStrLabel = TTTAttributedLabel(frame: CGRectZero)
        attrStrLabel?.backgroundColor = UIColor.cyanColor().colorWithAlphaComponent(0.2)
        attrStrLabel?.font = kForumFloorCellContentFont
        attrStrLabel?.text = "..."
        attrStrLabel?.numberOfLines = 0;
        self.contentView.addSubview(attrStrLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func clearData()
    {
        print("\(self).clearData")
        attrStrLabel?.setText("")
    }
    
    override func loadCellData(data:AnyObject)
    {
        if let d = data as? ForumTopicData{
            attrStrLabel?.text = d.contentText
        }
    }
    
    override func layoutSubviews() {
    super.layoutSubviews()
    
//    self.attrStrLabel.frame = CGRectOffset(CGRectInset(self.bounds, kForumFloorEdgeWidth, kForumFloorEdgeWidth), kForumFloorEdgeWidth, kForumFloorEdgeWidth);
        attrStrLabel?.frame = CGRect(x: kForumFloorEdgeWidth, y: 12, width: kForumLordFloorContentWidth, height: self.frame.size.height);
        self.setNeedsDisplay()
    }
}