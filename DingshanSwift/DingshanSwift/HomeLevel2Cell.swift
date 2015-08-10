//
//  HomeLevel2Cell.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/7/23.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class HomeLevel2Cell:UITableViewCell
{
    var icon:UIImageView?
    var title:UILabel?
    override init(style astyle:UITableViewCellStyle, reuseIdentifier str:String?) {
        super.init(style:astyle, reuseIdentifier:str)
        
        icon = UIImageView(frame: CGRect(x: 15, y: 8, width: 128, height: 128))
        icon?.backgroundColor = UIColor.magentaColor().colorWithAlphaComponent(0.2)
        icon?.clipsToBounds = true;
        self.addSubview(icon!)
        
        self.title = UILabel(frame: self.bounds)
        self.title!.text = ".."
        self.addSubview(title!)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func clearData()
    {
        title!.text = ""
    }
    func loadCellData(dic:NSDictionary)
    {
        let str = dic.objectForKey("topic_title") as? String
        title!.text = str
    }
}