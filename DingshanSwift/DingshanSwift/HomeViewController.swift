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
    var tableSource:ArrayDataSource = ArrayDataSource()
    override func loadView()
    {
        super.loadView()
        self.view.backgroundColor = UIColor.whiteColor();
        
        mainTable.frame = self.view.bounds;
        mainTable.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.2)
        mainTable.delegate = self
        mainTable.dataSource = self.tableSource
        
        
        var btn1 = UIButton(frame: CGRect(x:100,y:100,width:100,height:100));
        btn1.backgroundColor = UIColor.orangeColor()
        btn1.setTitle("go detail", forState: UIControlState.Normal)
        btn1.addTarget(self, action:Selector("onTapBtn:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn1)
        
    }
    
    override func viewDidLoad() {
        
        var configDic:NSDictionary? = NSDictionary(contentsOfFile: "GeneralConfig.plist")
        println(configDic)
        
//        stringByAppendingPathComponent:@"KuaiGameDB.data"];
        var path:NSString = "GeneralConfig.plist"
//        FileHelp.shareInstance().isFileExist(<#filePath: String!#>)
//        let arr:NSArray = NSArray(
//        self.tableSource.
    }
    
    func onTapBtn(sender:UIButton) {
        print(sender)
        var detail = DetailController()
        self.navigationController?.pushViewController(detail, animated: true)
        
    }
}