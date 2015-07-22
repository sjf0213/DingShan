//
//  HomeViewController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/7/14.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import UIKit

class HomeViewController:UIViewController,UITableViewDelegate
{
    
    var mainTable = UITableView();
    var tableSource:ArrayDataSource?
    override func loadView()
    {
        super.loadView()
        self.view.backgroundColor = UIColor.whiteColor();
        self.navigationItem.title = "首页"
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

        var arr: AnyObject? = MainConfig.sharedInstance.rootDic?.objectForKey("HomeMenu")
        print("\n arr = \(arr)")
        if arr is NSArray
        {
            self.tableSource!.appendWithItems(arr as! [AnyObject])
        }
        print("\n items = \(self.tableSource!.items)")
        mainTable.reloadData()
    }
    
//MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        print("\n didSelectRowAtIndexPath = \(indexPath)")
        var cell = tableView.cellForRowAtIndexPath(indexPath) as? HomeTableCell
        var detail = HomeLevel2Controller()
        detail.navigationItem.title = cell?.title?.text
        self.navigationController?.pushViewController(detail, animated: true)
    }
}