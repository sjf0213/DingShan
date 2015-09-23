//
//  ForumReplyListController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/9.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
import Alamofire
class ForumReplyListController:DSViewController,UITableViewDelegate,LoadViewProtocol,UIScrollViewDelegate
{
    var mainTable = UITableView();
    var topicData = ForumTopicData()
    var floorData = ForumFloorData()
    var tableSource:ArrayDataSource?
    var refreshView:RefreshView?
    var loadMoreView:LoadView?
    var currentPage:NSInteger = 0
    var request: Alamofire.Request? {
        didSet {
            oldValue?.cancel()
        }
    }
    override func loadView()
    {
        super.loadView()
        self.view.backgroundColor = UIColor.lightGrayColor()
        self.topTitle = "楼回复列表"
        self.tableSource = ArrayDataSource(withcellIdentifier: ReplyCellIdentifier, configureCellBlock:{(cell, data) in
            if let itemCell = cell as? ForumReplyCell{
                itemCell.clearData()
                if let d = data as? ForumReplyData{
                    itemCell.loadCellData(d)
                }
            }
        })
        
        refreshView = RefreshView(frame:CGRect(x:0,
            y:TopBar_H,
            width:self.view.bounds.width,
            height:60))
        refreshView?.delegate = self
        self.view.addSubview(self.refreshView!)
        
        mainTable.frame = CGRect(x: 0, y: TopBar_H, width: self.view.bounds.size.width, height: self.view.bounds.size.height);
        mainTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        mainTable.backgroundColor = UIColor.whiteColor()
        mainTable.separatorStyle = UITableViewCellSeparatorStyle.None
        mainTable.delegate = self
        mainTable.dataSource = self.tableSource
        mainTable.rowHeight = HomeRow_H
        mainTable.registerClass(ForumReplyCell.classForCoder(), forCellReuseIdentifier: ReplyCellIdentifier)
        self.view.addSubview(mainTable)
        
        self.refreshView?.loadinsets = self.mainTable.contentInset
        
        loadMoreView = LoadView(frame:CGRect(x:0, y:-1000, width:self.view.bounds.width, height:50))
        loadMoreView?.delegate = self
        loadMoreView?.loadinsets = self.mainTable.contentInset
        self.mainTable.addSubview(self.loadMoreView!)
    }
    
    override func viewDidLoad() {
        
        
    }
    
    func loadReplyListByTopicData(topic:ForumTopicData, floor:ForumFloorData)
    {
        self.topicData = topic;
        self.floorData = floor;
        self.startRequest();
    }
    
    func startRequest(){
        let parameter = ["topicid" : NSNumber(integer: self.topicData.topicId),
            "floorid" : self.floorData.floorId,
            "replyid" : NSNumber(integer: 0),
            "sorttype" : "0",
            "pindex" : "0",
            "psize" : "20",
            "json" : "1"]
//        var useJson = true
        let url = ApiBuilder.forum_get_reply_list(parameter)
        print("url = \(url)", terminator: "")
        self.request = Alamofire.request(.GET, url)
        // JSON
//        self.request?.responseJSON(options: .AllowFragments, completionHandler: { (requst1:NSURLRequest, response1:NSHTTPURLResponse?, data:AnyObject?,err: NSError?) -> Void in
        self.request?.responseJSON(completionHandler: {(request, response, result) -> Void in
            
            print("\n responseJSON- - - - -data = \(result)")
            
            // 下拉刷新时候清空旧数据（请求失败也清空）
            if (self.currentPage == 0 && self.tableSource?.items.count > 0){
                self.tableSource?.removeAllItems()
            }
            // 如果请求数据有效
            if let dic = result.value as? NSDictionary{
                print("\n responseJSON- - - - -data is NSDictionary")
                self.processRequestResult(dic)
            }
            // 控件复位
            self.refreshView?.RefreshScrollViewDataSourceDidFinishedLoading(self.mainTable)
            self.loadMoreView?.RefreshScrollViewDataSourceDidFinishedLoading(self.mainTable)
        })
    }
    func processRequestResult(result:NSDictionary){
        
        if (200 == result["c"]?.integerValue){
            if let list = result["v"] as? NSDictionary{
                var allDataArray = [AnyObject]()
                if (self.currentPage == 0){
                    if(self.tableSource?.items.count > 0){
                        self.tableSource?.removeAllItems();
                    }
                    // 只有分页的第一页有楼主层数据
                    if let topicInfoDic = result.objectForKey("topic_info") as? [String:AnyObject]{
                        if let title = topicInfoDic["topic_title"] as? String{
                            self.topTitle = title
                        }
                        let lordData = ForumFloorData(dic: topicInfoDic);
                        lordData.isLordFloor = true// 标记为楼主
                        allDataArray.append(lordData)
                    }
                }
                // 除楼主以外的回复
                if let replyArr = list["reply_list"] as? NSArray{
                    print("\n dataArray- - -\(replyArr)", terminator: "")
                    for var i = 0; i < replyArr.count; ++i {
                        if let item = replyArr[i] as? [String:AnyObject] {
                            let data = ForumReplyData(dic: item)
                            allDataArray.append(data)
                        }
                    }
                    if (replyArr.count < Default_Request_Count) {
                        self.loadMoreView?.isCanUse = false
                        self.loadMoreView?.hidden = true
                    }else{
                        self.loadMoreView?.isCanUse = true
                        self.loadMoreView?.hidden = false
                    }
                }
                self.tableSource?.items.addObjectsFromArray(allDataArray)
                self.mainTable.reloadData()
            }
        }else{
            // 失败时候清空数据后也要重新加载
            self.mainTable.reloadData()
        }
    }
}