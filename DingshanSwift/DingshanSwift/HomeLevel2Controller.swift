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
//    var dataArray:NSMutableArray = NSMutableArray()
    
    // alamo part 
    var headers: [String: String] = [:]
    var body: String?
    var elapsedTime: NSTimeInterval?
    var request: Alamofire.Request? {
        didSet {
            oldValue?.cancel()
            
//            self.title = self.request?.description
//            self.refreshControl?.endRefreshing()
            self.headers.removeAll()
            self.body = nil
            self.elapsedTime = nil
        }
    }
    override func loadView()
    {
        super.loadView()
        self.view.backgroundColor = UIColor.lightGrayColor()
//        self.title = "首页二级"
        self.tableSource = ArrayDataSource(withcellIdentifier: HomeCellIdentifier, configureCellBlock:{(cell, data) in
            let itemCell:HomeLevel2Cell? = cell as? HomeLevel2Cell
            let itemDic:NSDictionary? = data as? NSDictionary
            itemCell?.clearData()
            itemCell?.loadCellData(itemDic!)
        })
        mainTable.frame = self.view.bounds;
        mainTable.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.2)
        mainTable.delegate = self
        mainTable.dataSource = self.tableSource
        mainTable.rowHeight = 90.0
        mainTable.registerClass(HomeLevel2Cell.classForCoder(), forCellReuseIdentifier: HomeCellIdentifier)
        self.view.addSubview(mainTable)
    }
    
    override func viewDidLoad() {
        
        self.startRequest()
    }
    
    
    func startRequest()
    {
//        var urlStr:String = "http://v3.kuaigame.com/app/getcategoryarticle?uid=220154&device=iPhone5%2C2&pindex=0&psize=20&appver=3.2.1&key=cNCS0ipHRcFXsuW%2FTyO%2FN%2BmoHsk%3D&did=CD1FBB97-426F-4A83-90AB-A897D580BED2&e=1437637766&categoryid=3&clientid=21&aid=W%2Fsuzn3p2Tb3fQRp1ZaRxZlueKo%3D&iosver=8.4";
        var parameter = ["categoryid" : "3",
                            "pindex" : "0",
                            "psize" : "20",
                            "json" : "1"]
        var useJson = true
        var url = ApiBuilder.article_get_list(parameter)
        print("url = \(url)")
        self.request = Alamofire.request(.GET, url)
        // JSON
        self.request?.responseJSON(options: .AllowFragments, completionHandler: { (requst1:NSURLRequest, response1:NSHTTPURLResponse?, data:AnyObject?,err: NSError?) -> Void in

            print("\n responseJSON- - - - -data = \(data)")
            print("\n responseJSON- - - - -err = \(err)")
            if data is NSDictionary
            {
                print("\n responseJSON- - - - -data is NSDictionary")
                self.processRequestResult(data as! NSDictionary)
            }
        })
    }
    
    func processRequestResult(result:NSDictionary)
    {
        if (200 == result["c"]?.integerValue)
        {
            if let list = result["v"] as? NSDictionary{
                if let arr = list["list"] as? NSArray{
//                    self.dataArray.addObjectsFromArray(arr as [AnyObject])
                    print("\n dataArray- - -\(arr)")
                    self.tableSource?.appendWithItems(arr as [AnyObject])
                    self.mainTable.reloadData()
                }
            }
        }
    }
}