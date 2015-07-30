//
//  ForumFloorListController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/7/28.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class ForumFloorListController:UIViewController
{
    var mainTable = UITableView();
    var tableSource:ArrayDataSource?
    override func loadView()
    {
        super.loadView()
        self.view.backgroundColor = UIColor.lightGrayColor()
    }
    

}