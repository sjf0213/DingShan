//
//  StageMenuGridView.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/12/23.
//  Copyright © 2015年 song jufeng. All rights reserved.
//

import Foundation
class StageMenuGridView : UIView{
    // MARK: init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect)
        self.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.3)
        self.clipsToBounds = true
    }
}