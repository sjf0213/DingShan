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
    var currentPage:NSInteger = 0
    var indicatorTop:UzysRadialProgressActivityIndicator?
    var indicatorBottom:UzysRadialProgressActivityIndicator?
    var configCache:[NSObject:AnyObject]?
    var stageMenu : StageMenuView?

    override func loadView(){
        super.loadView()
        self.view.backgroundColor = UIColor.whiteColor()
        self.backBtnHidden = true
//        self.topView.hidden = true
        
        self.tableSource = ArrayDataSource(withcellIdentifier: HomeCellIdentifier, configureCellBlock:{(cell, data) in
            if let itemCell = cell as? HomeCell{
                itemCell.clearData()
                if let d = data as? ForumTopicData{
                    itemCell.loadCellData(d)
                }
            }
        })
        
        mainTable.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: UIScreen.mainScreen().bounds.size.height - MAIN_TAB_H);
        print("A_DONE------- self.frame = (\(mainTable.frame.origin.x), \(mainTable.frame.origin.y), \(mainTable.frame.size.width), \(mainTable.frame.size.height)")
        
        mainTable.contentInset = UIEdgeInsets(top: TopBar_H, left: 0, bottom: 0, right: 0)
        mainTable.backgroundColor = UIColor.whiteColor()
        mainTable.separatorStyle = UITableViewCellSeparatorStyle.None
        mainTable.delegate = self
        mainTable.dataSource = self.tableSource
        mainTable.rowHeight = HomeRow_H
        mainTable.registerClass(HomeCell.classForCoder(), forCellReuseIdentifier: HomeCellIdentifier)
        self.view.addSubview(mainTable)
        
//        let adPic = UIImageView(image: UIImage(named: "home_ad.jpg"))
//        adPic.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.1)
//        adPic.alpha = 0.3
//        adPic.frame = CGRect(x: 0, y: 0 - HomeAd_H, width: self.view.bounds.size.width, height: HomeAd_H)
//        mainTable.addSubview(adPic)
        
        let searchBtn = UIButton(frame: CGRect(x: 0, y: 20, width: 44, height: 44))
        searchBtn.setImage(UIImage(named: "search_btn"), forState: UIControlState.Normal)
        self.topView.addSubview(searchBtn)
        searchBtn.addTarget(self, action: Selector("onTapSearch"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let newThreadBtn = UIButton(frame: CGRect(x: self.view.bounds.size.width - 44, y: 20, width: 44, height: 44))
        newThreadBtn.setImage(UIImage(named: "forum_topic_add_new"), forState: UIControlState.Normal)
        self.topView.addSubview(newThreadBtn)
        newThreadBtn.addTarget(self, action: Selector("onTapNewThread"), forControlEvents: UIControlEvents.TouchUpInside)
        
        // 读取菜单配置
        var stageConfig = [AnyObject]()
        if let config = MainConfig.sharedInstance.rootDic?["StageMenu"] as? [AnyObject]{
            stageConfig = config
        }
        // 生成菜单
        stageMenu = StageMenuView(frame: CGRect(x: 50, y: 20, width: self.view.bounds.size.width - 100, height: TopBar_H - 20))
        stageMenu?.menuConfig = stageConfig
        self.view.addSubview(stageMenu!)
        
        
        mainTable.addPullToRefreshActionHandler({ [weak self] () -> Void in
            self?.currentPage = 0
            self?.tableSource?.removeAllItems()
            self?.mainTable.reloadData()
            self?.startRequest(self?.configCache)
            print("A_DONE------- self.frame = (\(self?.indicatorTop?.frame.origin.x), \(self?.indicatorTop?.frame.origin.y), \(self?.indicatorTop?.frame.size.width), \(self?.indicatorTop?.frame.size.height)")
            
            })
//        mainTable.addPullToLoadMoreActionHandler({ [weak self] () -> Void in
//            self?.startRequest(self?.configCache)
//            print("B_DONE------- self.frame = (\(self?.indicatorBottom?.frame.origin.x), \(self?.indicatorBottom?.frame.origin.y), \(self?.indicatorBottom?.frame.size.width), \(self?.indicatorBottom?.frame.size.height)")
//            
//            })
        
        mainTable.addTopInsetInPortrait(TopBar_H, topInsetInLandscape: TopBar_H)
        
        self.view.bringSubviewToFront(self.topView)
    }
    
    override func viewDidAppear(animated: Bool) {
        mainTable.triggerPullToRefresh()
        self.view.bringSubviewToFront(stageMenu!)
    }

    
    func refresh(){
//        self.loadMoreView?.isCanUse = false
//        self.loadMoreView?.hidden = true
        self.currentPage = 0
        self.startRequest(nil)
    }
    
    func startRequest(config:[NSObject:AnyObject]?){
        let parameter = ["pindex" : "0",
                        "psize" : "50",
                        "sorttype" : "1",
                        "topicid":"0",
                        "json" : "1"]
        
        let url = ServerApi.forum_get_topic_list(parameter)
        print("url = \(url)", terminator: "")
 
        AFDSClient.sharedInstance.GET(url, parameters: nil,
            success: {(task, JSON) -> Void in
                print("\n HomeController.AFDSClient.success- - - - -data = \(JSON)")
                // 下拉刷新时候清空旧数据（请求失败也清空）
                if (self.currentPage == 0 && self.tableSource?.items.count > 0){
                    self.tableSource?.removeAllItems()
                }
                // 如果请求数据有效
                if let dic = JSON as? [NSObject:AnyObject]{
                    self.processRequestResult(dic)
                }
                // 控件复位
                // 控件复位
                self.mainTable.stopRefreshAnimation()
//                self.refreshView?.RefreshScrollViewDataSourceDidFinishedLoading(self.mainTable)
//                self.loadMoreView?.RefreshScrollViewDataSourceDidFinishedLoading(self.mainTable)
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
//                    if (arr.count < Default_Request_Count) {
//                        self.loadMoreView?.isCanUse = false
//                        self.loadMoreView?.hidden = true
//                    }else{
//                        self.loadMoreView?.isCanUse = true
//                        self.loadMoreView?.hidden = false
//                    }
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
    
    func onTapSearch(){
        print("search some ~ ~", terminator: "")
        let searchController = SearchStartController()
        self.navigationController?.pushViewController(searchController, animated: true)
    }
    
    func onTapNewThread(){
        print("add new", terminator: "")
        let newThreadController = ForumNewThreadController()
        self.navigationController?.pushViewController(newThreadController, animated: true)
    }
    
// MARK: - UITableViewDelegate
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

}