//
//  HomeHeader.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/12/17.
//  Copyright © 2015年 song jufeng. All rights reserved.
//

import Foundation
class HomeHeader : UICollectionReusableView{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame aRect: CGRect) {
        super.init(frame: aRect);
        self.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.2)
        
    }
    func clearData()
    {
    }
    
    func loadCellData(data:AnyObject)
    {
    }
}