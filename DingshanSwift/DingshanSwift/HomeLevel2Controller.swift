//
//  HomeLevel2Controller.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/7/22.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
import Alamofire
class HomeLevel2Controller:UIViewController,UITableViewDelegate
{
    var mainTable = UITableView();
    var tableSource:ArrayDataSource?
    override func loadView()
    {
        super.loadView()
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        self.tableSource = ArrayDataSource(withcellIdentifier: HomeCellIdentifier, configureCellBlock:{(cell, data) in
            var itemCell:HomeTableCell? = cell as? HomeTableCell
            var itemDic:String? = data as? String
            itemCell?.clearData()
            itemCell?.loadCellData(itemDic!)
        })
        mainTable.frame = self.view.bounds;
        mainTable.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.2)
        mainTable.delegate = self
        mainTable.dataSource = self.tableSource
        mainTable.registerClass(HomeTableCell.classForCoder(), forCellReuseIdentifier: HomeCellIdentifier)
        self.view.addSubview(mainTable)
    }
    
    override func viewDidLoad() {
        
    }
}