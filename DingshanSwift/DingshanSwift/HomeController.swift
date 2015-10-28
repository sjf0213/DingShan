//
//  HomeController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/7/22.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class HomeController:DSViewController,UITableViewDelegate,LoadViewProtocol,UIScrollViewDelegate
{
    var mainTable = UITableView();
    var tableSource:ArrayDataSource?
    var refreshView:RefreshView?
    var loadMoreView:LoadView?
    var currentPage:NSInteger = 0

    override func loadView(){
        super.loadView()
        self.view.backgroundColor = UIColor.lightGrayColor()
        self.topTitle = "首页"
        self.backBtnHidden = true
        self.tableSource = ArrayDataSource(withcellIdentifier: HomeCellIdentifier, configureCellBlock:{(cell, data) in
            if let itemCell = cell as? HomeCell{
                itemCell.clearData()
                if let d = data as? ForumTopicData{
                    itemCell.loadCellData(d)
                }
            }
        })
        
        let newThreadBtn = UIButton(frame: CGRect(x: self.view.bounds.size.width - 44, y: 20, width: 44, height: 44))
        newThreadBtn.setImage(UIImage(named: "forum_topic_add_new"), forState: UIControlState.Normal)
        self.topView.addSubview(newThreadBtn)
        newThreadBtn.addTarget(self, action: Selector("onTapNewThread"), forControlEvents: UIControlEvents.TouchUpInside)
        
        refreshView = RefreshView(frame:CGRect(x:0,
                                                y:TopBar_H,
                                                width:self.view.bounds.width,
                                                height:60))
        refreshView?.backgroundColor = UIColor.lightGrayColor()
        refreshView?.delegate = self
        self.view.addSubview(self.refreshView!)
        
        mainTable.frame = CGRect(x: 0, y: TopBar_H, width: self.view.bounds.size.width, height: self.view.bounds.size.height - TopBar_H);
        mainTable.contentInset = UIEdgeInsets(top: HomeAd_H, left: 0, bottom: MAIN_TAB_H, right: 0)
        mainTable.backgroundColor = UIColor.whiteColor()
        mainTable.separatorStyle = UITableViewCellSeparatorStyle.None
        mainTable.delegate = self
        mainTable.dataSource = self.tableSource
        mainTable.rowHeight = HomeRow_H
        mainTable.registerClass(HomeCell.classForCoder(), forCellReuseIdentifier: HomeCellIdentifier)
        self.view.addSubview(mainTable)
        
        let adPic = UIImageView(image: UIImage(named: "home_ad.jpg"))
        adPic.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.1)
        adPic.frame = CGRect(x: 0, y: 0 - HomeAd_H, width: self.view.bounds.size.width, height: HomeAd_H)
        mainTable.addSubview(adPic)
        
        self.refreshView?.loadinsets = self.mainTable.contentInset
        
        loadMoreView = LoadView(frame:CGRect(x:0, y:-1000, width:self.view.bounds.width, height:50))
        loadMoreView?.backgroundColor = UIColor.lightGrayColor()
        loadMoreView?.delegate = self
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
        let parameter = ["pindex" : "0",
                        "psize" : "50",
                        "sorttype" : "1",
                        "topicid":"0",
                        "json" : "1"]
        
        let url = ServerApi.forum_get_topic_list(parameter)
        print("url = \(url)", terminator: "")
 
        AFDSClient.sharedInstance.GET(url, parameters: nil,
            success: {(task, JSON) -> Void in
                print("\n AFDSClient.success- - - - -data = \(JSON)")
                // 下拉刷新时候清空旧数据（请求失败也清空）
                
                if (self.currentPage == 0 && self.tableSource?.items.count > 0){
                    self.tableSource?.removeAllItems()
                }
                // 如果请求数据有效
                if let dic = JSON as? [NSObject:AnyObject]{
                    self.processRequestResult(dic)
                }
                // 控件复位
                self.refreshView?.RefreshScrollViewDataSourceDidFinishedLoading(self.mainTable)
                self.loadMoreView?.RefreshScrollViewDataSourceDidFinishedLoading(self.mainTable)
            }, failure: {( task, error) -> Void in
                print("\n failure: TIP --- e:\(error)")
            })
    }
    
    func processRequestResult(result:[NSObject:AnyObject]){
        if (200 == result["c"]?.integerValue){
            if let list = result["v"] as? [NSObject:AnyObject]{
                if let arr = list["topic_list"] as? [AnyObject]{
//                    print("\n dataArray- - -\(arr)", terminator: "")
                    for var i = 0; i < arr.count; ++i {
                        if let item = arr[i] as? [NSObject:AnyObject] {
                            let data = ForumTopicData(dic: item)
                            self.tableSource?.items.addObject(data)
                        }
                    }
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
            if let c = result["c"], let v = result["v"]{
                print("\n TIP --- c:\(c), v:\(v)")
            }
        }
    }
    
    func onTapNewThread(){
        print("add new", terminator: "")
        let newThreadController = ForumNewThreadController()
        self.navigationController?.pushViewController(newThreadController, animated: true)
    }
    
//MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        print("\n\(self.classForCoder) didSelectRowAtIndexPath = \(indexPath)", terminator: "")
        if let  cell = tableView.cellForRowAtIndexPath(indexPath) as? HomeCell{
            let detail = ForumFloorListController()
            detail.navigationItem.title = cell.title.text
            self.navigationController?.pushViewController(detail, animated: true)
            if let data = self.tableSource?.items[indexPath.row] as? ForumTopicData{
                detail.loadFloorListByTopicData(data)
            }
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