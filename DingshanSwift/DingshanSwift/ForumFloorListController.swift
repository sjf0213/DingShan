//
//  ForumFloorListController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/7/28.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class ForumFloorListController:DSViewController,UICollectionViewDataSource,UICollectionViewDelegate,LoadViewProtocol,UIScrollViewDelegate
{
    var mainTable = UICollectionView()
    var topicData = ForumTopicData()
//    var tableSource:ArrayDataSource?
    var dataList =  NSMutableArray()
    var refreshView:RefreshView?
    var loadMoreView:LoadView?
    var currentPage:NSInteger = 0
    
    override func loadView()
    {
        super.loadView()
        self.view.backgroundColor = UIColor.lightGrayColor()
        self.topTitle = "楼层列表"
        /*
        self.tableSource = ArrayDataSource(withcellIdentifier: FloorFollowingCellIdentifier, withFirstRowIdentifier:FloorLordCellIdentifier, configureCellBlock:{(cell, data) in
            if let d = data as? ForumTopicData{
                if let itemCell = cell as? ForumFloorLordCell{
                    itemCell.clearData()
                    itemCell.loadCellData(d)
                }
            }
            if let d = data as? ForumFloorData{
                if let itemCell = cell as? ForumFloorFollowingCell{
                    itemCell.clearData()
                    itemCell.loadCellData(d)
                }
            }
        })
*/
        
        refreshView = RefreshView(frame:CGRect(x:0,
            y:TopBar_H,
            width:self.view.bounds.width,
            height:60))
        refreshView?.delegate = self
        self.view.addSubview(self.refreshView!)
        
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize.zero
        layout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame), 100);
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        
        mainTable = UICollectionView(frame: CGRect( x: 0, y: TopBar_H, width: self.view.bounds.size.width, height: self.view.bounds.size.height), collectionViewLayout: layout)
        mainTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        mainTable.backgroundColor = UIColor.whiteColor()
        mainTable.delegate = self
        mainTable.dataSource = self
        mainTable.registerClass(ForumFloorLordCell.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: FloorLordCellIdentifier)
        mainTable.registerClass(ForumFloorFollowingCell.classForCoder(), forCellWithReuseIdentifier: FloorFollowingCellIdentifier)
        self.view.addSubview(mainTable)
        
        self.refreshView?.loadinsets = self.mainTable.contentInset
        
        loadMoreView = LoadView(frame:CGRect(x:0, y:-1000, width:self.view.bounds.width, height:50))
        loadMoreView?.delegate = self
        loadMoreView?.loadinsets = self.mainTable.contentInset
        self.mainTable.addSubview(self.loadMoreView!)
    }
    
    override func viewDidLoad() {
        
    }
    
    func loadFloorListByTopicData(data:ForumTopicData)
    {
        print("\n---loadFloorListByTopicData = \(data)")
        self.topicData = data;
        self.startRequest();
    }
    
    func startRequest(){
        let parameter:[NSObject:AnyObject] = ["topicid" : String(self.topicData.topicId),
            "floorid" : String(0),
            "replyid" : String(0),
            "sorttype" : "0",
            "pindex" : "0",
            "psize" : "20",
            "json" : "1"]
        let url = ServerApi.forum_get_floor_list(parameter)
        print("startRequest.url = \(url)")
        AFDSClient.sharedInstance.GET(url, parameters: nil,
            success: {(task, JSON:AnyObject) -> Void in
//                print("\n responseJSON- - - - -data = \(JSON), \(JSON.dynamicType)", JSON.dynamicType)
                // 下拉刷新时候清空旧数据（请求失败也清空）
                if (self.currentPage == 0 && self.dataList.count > 0){
                    self.dataList.removeAllObjects()
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
            if let v = result["v"] as? [NSObject:AnyObject]{
                var allDataArray = [AnyObject]()
                print("\n v- - -\(v)")
                if (self.currentPage == 0){
                    if(self.dataList.count > 0){
                        self.dataList.removeAllObjects()
                    }
                    // 只有分页的第一页有楼主层数据
                    if let topicInfoDic = v["topic_info"] as? [NSObject:AnyObject]{
                        if let title = topicInfoDic["topic_title"] as? String{
                            self.topTitle = title
                        }
                        let lordData = ForumTopicData(dic: topicInfoDic);
//                        lordData.isLordFloor = true// 标记为楼主
                        allDataArray.append(lordData)
                    }
                }
                // 除楼主以外的回复
                if let replyArr = v["floor_list"] as? NSArray{
                    for var i = 0; i < replyArr.count; ++i {
                        if let item = replyArr[i] as? [NSObject:AnyObject] {
                            let data = ForumFloorData(dic: item)
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
                self.dataList.addObjectsFromArray(allDataArray)
                self.mainTable.reloadData()
            }
        }else{
            // 失败时候清空数据后也要重新加载
            self.mainTable.reloadData()
            if let c = result["c"], let v = result["v"]{
                print("\n TIP --- c:\(c), v:\(v)")
            }
        }
    }
  // MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.dataList.count
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView{
        if (kind == UICollectionElementKindSectionHeader)
        {
            if let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: FloorLordCellIdentifier, forIndexPath: indexPath) as? ForumFloorLordCell{
                header.clearData()
                if let item = self.dataList.objectAtIndex(0) as? ImageInfoData{
                    header.loadCellData(item)
                }
                return header
            }
        }
        return UICollectionReusableView()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(GalleryViewCellIdentifier, forIndexPath: indexPath) as? GalleryViewCell{
            cell.clearData()
            if let item = self.dataList.objectAtIndex(indexPath.row) as? ImageInfoData{
                cell.loadCellData(item)
            }
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    // MARK: - UICollectionViewDelegate
    

    /*
// MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        var h : CGFloat = kMinForumLordFloorContentHieght
        if let data = self.tableSource?.items[indexPath.row] as? ForumTopicData{
            h = data.getCalculatedRowHeight()
        }
        if let data = self.tableSource?.items[indexPath.row] as? ForumFloorData{
            h = data.getCalculatedRowHeight()
        }
        return h;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        print("\n\(self.classForCoder) didSelectRowAtIndexPath = \(indexPath)", terminator: "")
        if let _ = tableView.cellForRowAtIndexPath(indexPath) as? ForumFloorCell{
            let detail = ForumReplyListController()
            detail.navigationItem.title = self.topicData.title
            self.navigationController?.pushViewController(detail, animated: true)
            if let data = self.tableSource?.items[indexPath.row] as? ForumFloorData{
                detail.loadReplyListByTopicData(self.topicData,floor:data)
            }
        }
    }
*/
}