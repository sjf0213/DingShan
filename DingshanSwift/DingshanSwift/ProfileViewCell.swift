//
//  ProfileViewCell.swift
//  DingshanSwift
//
//  Created by xiong qi on 15/11/18.
//  Copyright © 2015年 song jufeng. All rights reserved.
//

import Foundation

class ProfileViewCell:UITableViewCell
{
    var icon = UIImageView()
    var title = UILabel()
    var arrow = UIImageView()
    
    override init(style astyle:UITableViewCellStyle, reuseIdentifier str:String?) {
        super.init(style:astyle, reuseIdentifier:str)
        self.backgroundColor = UIColor.whiteColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        icon = UIImageView(frame: CGRect(x: 15, y: 9, width: 54, height: 27))
        icon.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.5)
        icon.clipsToBounds = true;
        self.contentView.addSubview(icon)
        
        title = UILabel(frame: CGRect(x: 84, y: 12, width: self.bounds.size.width - 114 - 50, height: 20))
        title.font = UIFont.systemFontOfSize(17.0)
        title.text = "..."
        self.contentView.addSubview(title)
        
        arrow = UIImageView(frame: CGRect(x: self.bounds.size.width-50, y: 12, width: 20, height: 20))
        arrow.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.5)
        self.contentView.addSubview(arrow)
        
        let topline = UIView(frame: CGRect(x: 15.0, y: 88-0.5, width: self.bounds.width - 30.0, height: 0.5))
        topline.backgroundColor = UIColor(white: 216/255.0, alpha: 1.0)
        self.contentView.addSubview(topline)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func clearData()
    {
        title.text = ""
    }
    
    func loadCellData(data:Dictionary<String,String>)
    {
        title.text = data["title"]
        icon.image = UIImage.init(named: data["image"]!)
    }
}