//
//  GalleryViewCell.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/8/17.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class  GalleryViewCell : UICollectionViewCell
{
    var bgImg:UIImageView?
    var title:UILabel?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame aRect: CGRect) {
        super.init(frame: aRect);
        self.backgroundColor = UIColor.lightGrayColor();
        bgImg = UIImageView(frame: self.bounds)
        bgImg?.clipsToBounds = true;
        self.addSubview(bgImg!)
        title = UILabel(frame: CGRect(x: 0, y: frame.size.height - 15, width: frame.size.width, height: 15))
        title?.textAlignment = NSTextAlignment.Center;
        title?.textColor = UIColor.whiteColor()
        title?.font = UIFont.systemFontOfSize(11.0)
        title?.backgroundColor = UIColor .blackColor().colorWithAlphaComponent(0.3)
        self.addSubview(title!)
    }
    
    func clearData()
    {
        bgImg?.image = nil;
        title?.text = nil;
    }
    
    override func layoutSubviews() {
        bgImg?.frame = self.bounds
        title?.frame = CGRect(x: 0, y: frame.size.height - 15, width: frame.size.width, height: 15)
        
    }
    
    func loadCellData(info:ImageInfoData)
    {
        title?.text = info.desc
        let url = NSURL(string: info.url.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
        bgImg?.sd_setImageWithURL(url)
    }
}
