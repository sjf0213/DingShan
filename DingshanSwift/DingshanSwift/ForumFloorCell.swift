//
//  ForumFloorCell.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/7/30.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class ForumFloorCell : UITableViewCell{
    
    private var content = UILabel()
    
    override init(style astyle:UITableViewCellStyle, reuseIdentifier str:String?) {
        super.init(style:astyle, reuseIdentifier:str)
        self.backgroundColor = UIColor.whiteColor()
        
        content = UILabel(frame: CGRect(x: 89.0, y: 12, width: self.bounds.size.width - 89 - 15, height: 38))
        content.font = UIFont.systemFontOfSize(15.0)
        content.numberOfLines = 2;
        content.text = "..."
        self.contentView.addSubview(content)
        
        let topline = UIView(frame: CGRect(x: 15.0, y: HomeRow_H-0.5, width: self.bounds.width - 30.0, height: 0.5))
        topline.backgroundColor = UIColor(white: 216/255.0, alpha: 1.0)
        self.contentView.addSubview(topline)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func clearData()
    {
        print("\(self).clearData")
        content.text = ""
    }
    func loadCellData(data:ForumFloorData)
    {
        content.text = data.contentText
    }
}