//
//  HomeHeader.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/12/17.
//  Copyright © 2015年 song jufeng. All rights reserved.
//

import Foundation
class HomeHeader : UICollectionReusableView{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect);
        self.backgroundColor = UIColor.whiteColor()
                
        let iconView = UIView(frame: CGRect(x: 15, y: (self.frame.size.height - 40) * 0.5, width: 40, height: 40))
        iconView.backgroundColor = UIColor(red: 0x53/255.0, green: 0xBB/255.0, blue: 0xE7/255.0, alpha: 1.0)
        iconView.layer.cornerRadius = 3.0
        let icon = UIImageView(image: UIImage(named: "know_icon"))
        icon.frame = iconView.bounds
        icon.contentMode = UIViewContentMode.Center
        iconView.addSubview(icon)
        self.addSubview(iconView)
        
        let title = UILabel(frame: CGRect(x: 65, y: 13, width: self.frame.size.width - 70, height: 16))
        title.font = UIFont.systemFontOfSize(15.0)
        title.text = "知识小结"
        self.addSubview(title)
        
        let desc = UILabel(frame: CGRect(x: 65, y: 34.5, width: self.frame.size.width - 70, height: 13))
        desc.font = UIFont.systemFontOfSize(12.0)
        desc.textColor = UIColor(white: 155/255.0, alpha: 1.0)
        desc.text = "一般人我不告诉他哦!"
        self.addSubview(desc)
        
        let bottomLine = UIView(frame: CGRect(x: 15, y: self.frame.size.height - 0.5, width: self.frame.size.width - 65, height: 0.5))
        bottomLine.backgroundColor = THEME_Line_COLOR
        self.addSubview(bottomLine)
    }
    
    func clearData()
    {
    }
    
    func loadCellData(data:AnyObject)
    {
    }
}