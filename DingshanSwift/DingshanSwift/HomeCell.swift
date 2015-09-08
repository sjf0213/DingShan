//
//  HomeCell.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/7/23.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation

class HomeCell:UITableViewCell
{
    var icon = UIImageView()
    var title = UILabel()
    override init(style astyle:UITableViewCellStyle, reuseIdentifier str:String?) {
        super.init(style:astyle, reuseIdentifier:str)
        self.backgroundColor = UIColor.whiteColor()
        
        icon = UIImageView(frame: CGRect(x: 15, y: 9, width: 64, height: 64))
        icon.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.5)
        icon.clipsToBounds = true;
        self.contentView.addSubview(icon)
        
        title = UILabel(frame: CGRect(x: 89.0, y: 12, width: self.bounds.size.width - 89 - 15, height: 38))
        title.font = UIFont.systemFontOfSize(15.0)
        title.numberOfLines = 2;
        title.text = "..."
        self.contentView.addSubview(title)
        
        let topline = UIView(frame: CGRect(x: 15.0, y: HomeRow_H-0.5, width: self.bounds.width - 30.0, height: 0.5))
        topline.backgroundColor = UIColor(white: 216/255.0, alpha: 1.0)
        self.contentView.addSubview(topline)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func clearData()
    {
        title.text = ""
    }
    func loadCellData(dic:NSDictionary)
    {
        let str = dic.objectForKey("topic_title") as? String
        title.text = str
    }
}