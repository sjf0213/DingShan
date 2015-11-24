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
        
        let ang = UIImageView(frame: CGRect(x: frame.size.width - 18, y: 0, width: 12, height: 6))
        ang.image = UIImage(named:"gallery_more_pop")
        self.addSubview(ang)
        
        let container = UIView(frame: CGRect(x: 0, y: 6, width: frame.size.width, height: frame.size.height))
        container.backgroundColor = UIColor.whiteColor()
        self.addSubview(container)
    }
}