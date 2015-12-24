//
//  HomeController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/7/22.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class HomeController:DSViewController,UICollectionViewDataSource,UICollectionViewDelegate
{
    var layout : UICollectionViewFlowLayout?
    var mainTable : UICollectionView?
    var dataList =  NSMutableArray()
    var currentPage:Int = 0
    var indicatorTop:UzysRadialProgressActivityIndicator?
    var indicatorBottom:UzysRadialProgressActivityIndicator?
    var configCache:[NSObject:AnyObject]?
    var stageMenu : StageMenuView?
    var lastTopicId:Int = 0
    var stageIndex:Int = 0

    override func loadView(){
        super.loadView()
        self.view.backgroundColor = UIColor.whiteColor()
        self.backBtnHidden = true
//        self.topView.hidden = true

        layout = UICollectionViewFlowLayout()
        layout?.headerReferenceSize = CGSize.zero
        layout?.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame), HomeRow_H);
        layout?.minimumLineSpacing = 0.0
        layout?.minimumInteritemSpacing = 0.0
        
        mainTable = UICollectionView(frame: CGRect(x: 0, y: TopBar_H, width: self.view.bounds.size.width, height: UIScreen.mainScreen().bounds.size.height - TopBar_H - MAIN_TAB_H), collectionViewLayout: layout!)
        mainTable?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        mainTable?.backgroundColor = UIColor.whiteColor()
        mainTable?.delegate = self
        mainTable?.dataSource = self
        mainTable?.registerClass(HomeHeader.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HomeHeaderIdentifier)
        mainTable?.registerClass(HomeCell.classForCoder(), forCellWithReuseIdentifier: HomeCellIdentifier)
        self.view.addSubview(mainTable!)
        
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
        stageMenu?.tapItemHandler = {[weak self](index:Int) -> Void in
            self?.stageIndex = index
            if(0 == index){
                self?.layout?.headerReferenceSize = CGSize.zero
            }else{
                self?.layout?.headerReferenceSize = CGSize(width: (self?.view.bounds.size.width)!, height: HomeHeader_H)
            }
            self?.mainTable?.setNeedsLayout()
            self?.mainTable?.triggerPullToRefresh()
        }
        
        mainTable?.addPullToRefreshActionHandler({ [weak self] () -> Void in
            self?.currentPage = 0
            self?.dataList.removeAllObjects()
            self?.mainTable?.reloadData()
            self?.startRequest(self?.configCache)
            print("A_DONE------- self.frame = (\(self?.indicatorTop?.frame.origin.x), \(self?.indicatorTop?.frame.origin.y), \(self?.indicatorTop?.frame.size.width), \(self?.indicatorTop?.frame.size.height)")
            
            })
        mainTable?.addPullToLoadMoreActionHandler({ [weak self] () -> Void in
            print("B_DONE------- addPullToLoadMoreActionHandler------- begin")
            self?.startRequest(self?.configCache)
//            print("B_DONE------- self.frame = (\(self?.indicatorBottom?.frame.origin.x), \(self?.indicatorBottom?.frame.origin.y), \(self?.indicatorBottom?.frame.size.width), \(self?.indicatorBottom?.frame.size.height)")
            
            })
        
        mainTable?.addTopInsetInPortrait(0, topInsetInLandscape: 0)
        mainTable?.triggerPullToRefresh()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bringSubviewToFront(stageMenu!)
    }
    override func viewDidAppear(animated: Bool) {
//        mainTable?.triggerPullToRefresh()
    }

    /*
    func refresh(){
//        self.loadMoreView?.isCanUse = false
//        self.loadMoreView?.hidden = true
        self.currentPage = 0
        self.startRequest(nil)
    }*/
    
    func startRequest(config:[NSObject:AnyObject]?){
        let parameter = ["pindex" : String(self.currentPage),
                        "psize" : "10",
                        "sorttype" : String(self.stageIndex),
                        "topicid":String(self.lastTopicId),
                        "json" : "1"]
        
        let url = ServerApi.forum_get_topic_list(parameter)
        print("url = \(url)", terminator: "")
 
        AFDSClient.sharedInstance.GET(url, parameters: nil,
            success: {(task, JSON) -> Void in
//                print("\n HomeController.AFDSClient.success- - - - -data = \(JSON)")
                // 下拉刷新时候清空旧数据（请求失败也清空）
                if (self.currentPage == 0 && self.dataList.count > 0){
                    self.dataList.removeAllObjects()
                }
                
                self.currentPage++;
                // 如果请求数据有效
                if let dic = JSON as? [NSObject:AnyObject]{
                    self.processRequestResult(dic)
                }
                // 控件复位
                self.mainTable?.stopRefreshAnimation()
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
                            self.dataList.addObject(data)
                            
                            if(i == arr.count-1){
                                self.lastTopicId = data.topicId
                            }
                        }
                    }
                    // 正常流程
                    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(load_delay * Double(NSEC_PER_SEC)))
                    dispatch_after(popTime, dispatch_get_main_queue(), {() -> Void in
                        self.mainTable?.reloadData()// 失败时候清空数据后也要重新加载
                        // 控件复位
                        self.mainTable?.stopRefreshAnimation()
                        self.mainTable?.stopLoadMoreAnimation()
                    })
                }else{// 最后一页没有更多数据了
                    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(load_delay * Double(NSEC_PER_SEC)))
                    dispatch_after(popTime, dispatch_get_main_queue(), {() -> Void in
                        self.mainTable?.showLoadMoreEnd(true)
                    })
                }
            }
        }else{
            // 失败时候清空数据后也要重新加载
            self.mainTable?.reloadData()
            if let c = result["c"], let v = result["v"]{
                print("\n TIP --- c:\(c), v:\(v)")
            }
        }
    }
    
    func onTapSearch(){
        print("search some ~ ~", terminator: "")
//    let searchController = SearchStartController()
//        self.navigationController?.pushViewController(searchController, animated: true)
        UIApplication().openURL(NSURL(string: "prefs:root=General&path=ManagedConfigurationList")!)
        
    }
    
    func onTapNewThread(){
        print("add new", terminator: "")
        let newThreadController = ForumNewThreadController()
        self.navigationController?.pushViewController(newThreadController, animated: true)
    }
    
// MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.dataList.count
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView{
        if (kind == UICollectionElementKindSectionHeader){
            if let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: HomeHeaderIdentifier, forIndexPath: indexPath) as? HomeHeader{
                header.clearData()
                return header
            }
        }
        return UICollectionReusableView()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(HomeCellIdentifier, forIndexPath: indexPath) as? HomeCell{
            cell.clearData()
            if let item = self.dataList.objectAtIndex(indexPath.row) as? ForumTopicData{
                cell.loadCellData(item)
            }
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
// MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let controller = ForumFloorListController()
        self.navigationController?.pushViewController(controller, animated: true)
        if let data = self.dataList[indexPath.row] as? ForumTopicData{
            controller.navigationItem.title = data.title
            controller.loadFloorListByTopicData(data)
        }
    }
}