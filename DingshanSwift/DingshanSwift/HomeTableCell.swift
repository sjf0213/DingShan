//
//  HomeTableCell.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/7/20.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class HomeTableCell:UITableViewCell
{
    var title:UILabel?
    override init(style astyle:UITableViewCellStyle, reuseIdentifier str:String?) {
        super.init(style:astyle, reuseIdentifier:str)
        self.title = UILabel(frame: self.bounds)
        self.title!.text = ".."
        self.addSubview(title!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func clearData()
    {
        title!.text = ""
    }
    func loadCellData(data:String)
    {
        title!.text = data
    }
}