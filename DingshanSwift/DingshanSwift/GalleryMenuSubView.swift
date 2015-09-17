//
//  GalleryMenuSubView.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/7.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class GalleryMenuSubView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame aRect: CGRect) {
        super.init(frame: aRect);
        self.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.2)
    }
}