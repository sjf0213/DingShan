//
//  ForumReplyLordCell.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/24.
//  Copyright © 2015年 song jufeng. All rights reserved.
//

import Foundation // 回复列表的层主，本身是一个floor
class ForumReplyLordCell : ForumFloorCell{
    
    override init(style astyle:UITableViewCellStyle, reuseIdentifier str:String?) {
        super.init(style:astyle, reuseIdentifier:str)
        self.backgroundColor = UIColor.magentaColor().colorWithAlphaComponent(0.2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}