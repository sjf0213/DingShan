//
//  TabBarToggleBtn.swift
//  DingshanSwift
//
//  Created by 宋炬峰 on 15/8/29.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class TabBarToggleBtn : UIControl
{
    var img1:UIImage = UIImage();
    var img0:UIImage = UIImage();
    var title:String = ""{
        willSet(newTitle)
        {
            self.titleLabel.text = newTitle
        }
    }
    private var mainImg = UIImageView();
    private var titleLabel = UILabel()
    var curSelected:Bool = false{
        willSet(newCurSelected){
            if (newCurSelected){
                mainImg.image = img1;
                titleLabel.textColor = UIColor(red: 252/255.0, green: 74/255.0, blue: 100/255.0, alpha: 1.0)
            }else{
                mainImg.image = img0;
                titleLabel.textColor = UIColor(white: 155.0/255.0, alpha: 1.0)
            }
        }
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect)
        self.backgroundColor = TABBAR_COLOR
        mainImg.frame = CGRect(x: 0, y: 0, width: aRect.size.width, height: 35)
        mainImg.contentMode = UIViewContentMode.Center
        self.addSubview(mainImg)
        
        titleLabel.frame = CGRect(x: 0, y: 35, width: aRect.size.width, height: 11);
        titleLabel.font = UIFont.systemFontOfSize(10.0)
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.textColor = UIColor(white: 155.0/255.0, alpha: 1.0)
        self.addSubview(titleLabel)
    }
}