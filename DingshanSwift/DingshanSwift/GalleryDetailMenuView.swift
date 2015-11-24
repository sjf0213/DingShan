//
//  GalleryDetailMenuView.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/11/24.
//  Copyright © 2015年 song jufeng. All rights reserved.
//

import Foundation
class GalleryDetailMenuView : UIView{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame aRect: CGRect) {
        super.init(frame: aRect);
        self.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.3)
        
    }
}