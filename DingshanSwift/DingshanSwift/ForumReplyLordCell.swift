//
//  ForumReplyLordCell.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/24.
//  Copyright © 2015年 song jufeng. All rights reserved.
//

import Foundation // 回复列表的层主，本身是一个floor
class ForumReplyLordCell : UICollectionReusableView{
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect);
        self.backgroundColor = UIColor.magentaColor().colorWithAlphaComponent(0.2)
    }
    
    
    func clearData()
    {
        print("\(self).clearData")
    }
    
    func loadCellData(data:AnyObject)
    {
        
    }
    
}