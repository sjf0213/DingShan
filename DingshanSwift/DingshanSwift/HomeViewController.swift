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
        
        var btn1 = UIButton(frame: CGRect(x:100,y:100,width:100,height:100));
        btn1.backgroundColor = UIColor.orangeColor()
        btn1.setTitle("go detail", forState: UIControlState.Normal)
        btn1.addTarget(self, action:Selector("onTapBtn:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn1)
        
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
    
    func onTapBtn(sender:UIButton) {
        print(sender)
        var detail = DetailController()
        self.navigationController?.pushViewController(detail, animated: true)
        
    }
}