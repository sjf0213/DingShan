//
//  ForumFloorLordCell.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/23.
//  Copyright © 2015年 song jufeng. All rights reserved.
//

import Foundation
class ForumFloorLordCell : UICollectionReusableView{
    
    var attrStrLabel:TTTAttributedLabel?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame aRect: CGRect) {
        super.init(frame: aRect);
        self.backgroundColor = UIColor.orangeColor().colorWithAlphaComponent(0.2)
        
        attrStrLabel = TTTAttributedLabel(frame: CGRectZero)
        attrStrLabel?.backgroundColor = UIColor.cyanColor().colorWithAlphaComponent(0.2)
        attrStrLabel?.font = kForumFloorCellContentFont
        attrStrLabel?.text = "..."
        attrStrLabel?.numberOfLines = 0;
        self.addSubview(attrStrLabel!)
    }
    
    func clearData()
    {
//        print("\(self).clearData")
        attrStrLabel?.setText("")
    }
    
    func loadCellData(data:AnyObject)
    {
        if let d = data as? ForumTopicData{
            attrStrLabel?.attributedText = d.contentAttrString
//            debugPrint("---------loadCellData.attrStrLabel = \(attrStrLabel?.attributedText?.string)")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        attrStrLabel?.frame = CGRect(x: kForumFloorEdgeWidth, y: 12, width: kForumLordFloorContentWidth, height: self.frame.size.height);
        debugPrint("---------ForumFloorLordCell.layoutSubviews.attrStrLabel.frame = \(attrStrLabel?.frame)")
        self.setNeedsDisplay()
    }
}