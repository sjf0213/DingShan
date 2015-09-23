//
//  ForumFloorFollowingCell.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/23.
//  Copyright © 2015年 song jufeng. All rights reserved.
//

import Foundation
class ForumFloorFollowingCell : ForumFloorCell{
    
    override init(style astyle:UITableViewCellStyle, reuseIdentifier str:String?) {
        super.init(style:astyle, reuseIdentifier:str)
        self.backgroundColor = UIColor.magentaColor().colorWithAlphaComponent(0.2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}