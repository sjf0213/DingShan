//
//  ForumFloorFollowingCell.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/23.
//  Copyright © 2015年 song jufeng. All rights reserved.
//

import Foundation
class ForumFloorFollowingCell : UICollectionViewCell{
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect);
        self.backgroundColor = UIColor.magentaColor().colorWithAlphaComponent(0.2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clearData()
    {
        print("\(self).clearData")
    }
    
    func loadCellData(data:AnyObject)
    {
        
    }
}