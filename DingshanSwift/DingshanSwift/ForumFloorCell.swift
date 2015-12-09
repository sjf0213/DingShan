//
//  ForumFloorCell.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/7/30.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class ForumFloorCell : UITableViewCell{
    
    var attrStrLabel:TTTAttributedLabel?
    override init(style astyle:UITableViewCellStyle, reuseIdentifier str:String?) {
        super.init(style:astyle, reuseIdentifier:str)
        self.backgroundColor = UIColor.whiteColor()
        
        let topline = UIView(frame: CGRect(x: 15.0, y: HomeRow_H-0.5, width: self.bounds.width - 30.0, height: 0.5))
        topline.backgroundColor = UIColor(white: 216/255.0, alpha: 1.0)
        self.contentView.addSubview(topline)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func clearData(){
        print("\(self).clearData")
    }
    func loadCellData(data:AnyObject){
        
    }
}