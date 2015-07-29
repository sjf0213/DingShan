//
//  HomeLevel2Controller.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/7/22.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
import Alamofire
class HomeLevel2Controller:UIViewController,UITableViewDelegate,LoadViewProtocol,UIScrollViewDelegate
{
    var mainTable = UITableView();
    var tableSource:ArrayDataSource?
//    var dataArray:NSMutableArray = NSMutableArray()
    var refreshView:RefreshView?
    var loadMoreView:LoadView?
    var currentPage:NSInteger = 0
    
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
    override func loadView(){
        super.loadView()
        self.view.backgroundColor = UIColor.lightGrayColor()
//        self.title = "首页二级"
        self.tableSource = ArrayDataSource(withcellIdentifier: HomeCellIdentifier, configureCellBlock:{(cell, data) in
            let itemCell:HomeLevel2Cell? = cell as? HomeLevel2Cell
            let itemDic:NSDictionary? = data as? NSDictionary
            itemCell?.clearData()
            itemCell?.loadCellData(itemDic!)
        })
        
        refreshView = RefreshView(frame:CGRect(x:0,
                                                y:TOPNAVI_H,
                                                width:self.view.bounds.width,
                                                height:60))
        refreshView?.backgroundColor = UIColor.cyanColor()
        refreshView?.delegate = self
        self.view.addSubview(self.refreshView!)
        
        mainTable.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height);
        mainTable.contentInset = UIEdgeInsets(top: TOPNAVI_H, left: 0, bottom: 0, right: 0)
//        mainTable.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.2)
        mainTable.backgroundColor = UIColor.clearColor()
        mainTable.delegate = self
        mainTable.dataSource = self.tableSource
        mainTable.rowHeight = 70.0
        mainTable.registerClass(HomeLevel2Cell.classForCoder(), forCellReuseIdentifier: HomeCellIdentifier)
        self.view.addSubview(mainTable)
        
        self.refreshView?.loadinsets = self.mainTable.contentInset
        
        loadMoreView = LoadView(frame:CGRect(x:0, y:-1000, width:self.view.bounds.width, height:50))
        loadMoreView?.delegate = self
        refreshView?.backgroundColor = UIColor.cyanColor()
        loadMoreView?.loadinsets = self.mainTable.contentInset
        self.mainTable.addSubview(self.loadMoreView!)
    }
    
    override func viewDidLoad() {
        
        self.startRequest()
    }
    
    func refresh(){
        self.loadMoreView?.isCanUse = false
        self.loadMoreView?.hidden = true
        self.currentPage = 0
        self.startRequest()
    }
    
    func startRequest(){
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
            
            // 下拉刷新时候清空旧数据（请求失败也清空）
            if (self.currentPage == 0 && self.tableSource?.items.count > 0){
                self.tableSource?.removeAllItems()
            }
            // 如果请求数据有效
            if data is NSDictionary{
                print("\n responseJSON- - - - -data is NSDictionary")
                self.processRequestResult(data as! NSDictionary)
            }
            // 控件复位
            self.refreshView?.RefreshScrollViewDataSourceDidFinishedLoading(self.mainTable)
            self.loadMoreView?.RefreshScrollViewDataSourceDidFinishedLoading(self.mainTable)
        })
    }
    
    func processRequestResult(result:NSDictionary){
        if (200 == result["c"]?.integerValue){
            if let list = result["v"] as? NSDictionary{
                if let arr = list["list"] as? NSArray{
                    print("\n dataArray- - -\(arr)")
                    self.tableSource?.appendWithItems(arr as [AnyObject])
                    self.mainTable.reloadData()
                    if (arr.count < Default_Request_Count) {
                        self.loadMoreView?.isCanUse = false
                        self.loadMoreView?.hidden = true
                    }else{
                        self.loadMoreView?.isCanUse = true
                        self.loadMoreView?.hidden = false
                    }
                }
            }
        }else{
            // 失败时候清空数据后也要重新加载
            self.mainTable.reloadData()
        }
    }
    
   //MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView){
        if (scrollView.contentOffset.y <= 0){
            self.refreshView?.RefreshScrollViewDidScroll(scrollView)
            return;
        }else{
            self.loadMoreView?.RefreshScrollViewDidScroll(scrollView)
        }
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>){
        if (scrollView.contentOffset.y<=0){
            self.refreshView?.RefreshScrollViewDidEndDragging(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        self.refreshView?.RefreshScrollViewDidEndDecelerating(scrollView)
    }
    
    //MARK: - LoadViewProtocol Methods
    
    //开始加载数据
    func BeginLoadingData(view:UIView){
        self.currentPage++
        self.startRequest()
    }
    //开始刷新数据
    func BeginRefreshData(view:UIView){
        self.refresh()
    }
    
    func FinishedLoadingDataButFailed(){
        self.startRequest()
    }
}