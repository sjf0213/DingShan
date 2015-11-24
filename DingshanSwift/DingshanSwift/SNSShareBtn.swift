//
//  SNSShareBtn.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/11/24.
//  Copyright © 2015年 song jufeng. All rights reserved.
//

import Foundation
class SNSShareBtn : UIButton{
    
    var title:String = ""{
        didSet{
            self.nameLabel?.text = title
        }
    }
    private var nameLabel:UILabel?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame aRect: CGRect) {
        super.init(frame: aRect);
        self.backgroundColor = UIColor.orangeColor().colorWithAlphaComponent(0.0)
        
        self.nameLabel = UILabel(frame: CGRect(x: 0, y: self.frame.size.height - 30, width: self.frame.size.width, height: 20))
        self.nameLabel?.text = "title"
        self.nameLabel?.textAlignment = NSTextAlignment.Center
        self.nameLabel?.textColor = UIColor.blackColor()
        self.nameLabel?.font = UIFont.systemFontOfSize(12.0)
        self.addSubview(self.nameLabel!)
        
    }
}