//
//  GalleryDetailBottomBar.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/11/23.
//  Copyright © 2015年 song jufeng. All rights reserved.
//

import Foundation
class GalleryDetailBottomBar : UIView{
    var hidePageTip:Bool = false{
        didSet{
            self.pageIndexLabel?.hidden = hidePageTip
        }
    }
    var title:String = ""{
        didSet{
            self.titleLabel?.text = title
        }
    }
    var pageText:String = ""{
        didSet{
            self.pageIndexLabel?.text = pageText
        }
    }
    private var titleLabel:UILabel?
    private var pageIndexLabel:UILabel?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame aRect: CGRect) {
        super.init(frame: aRect);
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5);
        
        self.titleLabel = UILabel(frame: CGRect(x: 10, y: 0, width: self.frame.size.width - 70, height: self.frame.size.height))
        self.titleLabel?.text = "title"
        self.titleLabel?.textColor = UIColor.whiteColor()
        self.titleLabel?.font = UIFont.systemFontOfSize(15.0)
        self.addSubview(self.titleLabel!)
        
        self.pageIndexLabel = UILabel(frame: CGRect(x: self.frame.size.width - 60, y: 0, width: 50, height: self.frame.size.height));
        self.pageIndexLabel?.textAlignment = NSTextAlignment.Right
        self.pageIndexLabel?.textColor = UIColor.whiteColor()
        self.pageIndexLabel?.font = UIFont.systemFontOfSize(15.0)
        self.pageIndexLabel?.text = "1/15"
        self.addSubview(self.pageIndexLabel!)
    }
}