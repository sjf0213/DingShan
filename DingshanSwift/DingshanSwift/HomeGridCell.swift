//
//  HomeGridCell.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/8/7.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class HomeGridCell : UICollectionViewCell
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
        title = UILabel(frame: self.bounds)
        title?.textAlignment = NSTextAlignment.Center;
        title?.textColor = UIColor.whiteColor()
        self.addSubview(title!)
    }
    
    func clearData()
    {
        bgImg?.image = nil;
        title?.text = nil;
    }
    
    func loadCellData(info:NSDictionary)
    {
        bgImg?.image = UIImage(named: (info.objectForKey("bg") as? String)!)
        title?.text = info.objectForKey("title") as? String
    }
    
}