//
//  GalleryViewController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/7/14.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation

let gallery_gap:CGFloat = 10.0

class GalleryViewController:DSViewController,UICollectionViewDataSource, UICollectionViewDelegate,CHTCollectionViewDelegateWaterfallLayout
{
    var seg:KASegmentControl?
    var menuView = GalleryMenuView()
    var mainCollection:UICollectionView?
    var currentPage:NSInteger = 0
    var dataList =  NSMutableArray()
    var singleConfig:[AnyObject]?
    var multiConfig:[AnyObject]?
    var configCache:[NSObject:AnyObject]?
    var indicatorTop:UzysRadialProgressActivityIndicator?
    var indicatorBottom:UzysRadialProgressActivityIndicator?
    override func loadView(){
        super.loadView()
        self.view.backgroundColor = NAVI_COLOR
        self.backBtnHidden = true
        
        // 读取菜单配置
        if let configAll = MainConfig.sharedInstance.rootDic?["GalleryMenu"] as? [NSObject:AnyObject]{
            multiConfig = configAll["Multi"] as? [AnyObject]
            singleConfig = configAll["Single"] as? [AnyObject]
        }
        
        // 初始化切换按钮
        seg = KASegmentControl(frame: CGRectMake((self.topView.frame.size.width - 140)*0.5, 27, 140, 30),
                            withItems: ["套图", "单图"],
                            withLightedColor: THEME_COLOR)
        self.topView.addSubview(seg!)
        seg?.tapSegmentItemHandler = {(selectedIndex)->Void in
            self.changeBySegIndex(selectedIndex)
        }
        
        // 初始化菜单
        menuView.frame = CGRectMake(0, self.topView.frame.size.height, self.view.bounds.size.width, 40)
        self.view.addSubview(menuView)
        
        let layout = CHTCollectionViewWaterfallLayout()
        layout.sectionInset = UIEdgeInsetsMake(gallery_gap, gallery_gap, gallery_gap, gallery_gap);
        layout.columnCount = 2;
        layout.minimumColumnSpacing = gallery_gap;
        layout.minimumInteritemSpacing = gallery_gap;
        
        mainCollection = UICollectionView(frame: CGRect(x: 0,
            y: self.topView.bounds.size.height + self.menuView.bounds.size.height,
            width: self.view.bounds.size.width,
            height: self.view.bounds.size.height - self.topView.bounds.size.height - self.menuView.bounds.size.height - MAIN_TAB_H), collectionViewLayout: layout)
        mainCollection?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        mainCollection?.backgroundColor = UIColor.whiteColor()
        mainCollection?.dataSource = self;
        mainCollection?.delegate = self;
        mainCollection?.registerClass(GalleryViewCell.classForCoder(), forCellWithReuseIdentifier: GalleryViewCellIdentifier)
        
        mainCollection?.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        mainCollection?.alwaysBounceVertical = true
        
        mainCollection?.addPullToRefreshActionHandler({ [weak self] () -> Void in
            self?.currentPage = 0
            self?.dataList.removeAllObjects()
            self?.mainCollection?.reloadData()
            self?.startRequest(self?.configCache)
            print("A_DONE------- self.frame = (\(self?.indicatorTop?.frame.origin.x), \(self?.indicatorTop?.frame.origin.y), \(self?.indicatorTop?.frame.size.width), \(self?.indicatorTop?.frame.size.height)")
            
        })
        mainCollection?.addPullToLoadMoreActionHandler({ [weak self] () -> Void in
            self?.startRequest(self?.configCache)
            print("B_DONE------- self.frame = (\(self?.indicatorBottom?.frame.origin.x), \(self?.indicatorBottom?.frame.origin.y), \(self?.indicatorBottom?.frame.size.width), \(self?.indicatorBottom?.frame.size.height)")
            
        })
        indicatorTop?.progressThreshold = 64.0
        indicatorBottom?.progressThreshold = 44;
        
        
        self.view.addSubview(mainCollection!)
        self.view.bringSubviewToFront(menuView)
        
        menuView.tapItemHandler = {[weak self](config:[NSObject:AnyObject]) -> Void in
            print("-----------Changed ! ! !userSelectConfig = \(config)")
            self?.configCache = config
            self?.currentPage = 0
            self?.dataList.removeAllObjects()
            self?.mainCollection?.reloadData()
            self?.startRequest(config)
        }
    }
    
    deinit {
        //
    }
    
    override func viewDidLoad() {
        seg?.selectedSegmentIndex = 1;
        
    }
    
    // 切换套图与单图
    func changeBySegIndex(index:Int)->Void{
        self.currentPage = 0
        self.dataList.removeAllObjects()
        self.mainCollection?.reloadData()
        if 0 == index{
            menuView.menuConfig = multiConfig!
        }
        if (1 == index){
            menuView.menuConfig = singleConfig!
        }
        mainCollection?.triggerPullToRefresh()
    }
    
    func onTapBtn(sender:UIButton) {
        print(sender, terminator: "")
        let detail = DetailController()
        self.navigationController?.pushViewController(detail, animated: true)
        
    }
    
    func startRequest(config:[NSObject:AnyObject]?){
        var parameter:[NSObject:AnyObject] = [  "iid" : String(self.currentPage),
                                              "psize" : "30",
                                               "json" : "1"]
        if config != nil{
            for one in config! {
                parameter[one.0] = String(one.1)
            }
        }
        // print("Multi = = = = = = =parameter = \(parameter)", terminator: "")
        var type = ""
        if 0 == seg?.selectedSegmentIndex{
            type = "multi"
        }else if 1 == seg?.selectedSegmentIndex{
            type = "single"
        }
        let url = ServerApi.gallery_get_galary_list(type, dic:parameter)
        
        // print("\n---$$$---url = \(url)", terminator: "")
        AFDSClient.sharedInstance.GET(url, parameters: nil,
            success: {[weak self](task, JSON) -> Void in
                print("\n responseJSON- - - - -data = \(JSON)")
                // 下拉刷新时候清空旧数据（请求失败也清空）
                if (self?.currentPage == 0 && self?.dataList.count > 0){
                    self?.dataList.removeAllObjects()
                }
                self?.currentPage++
                // 如果请求数据有效
                if let dic = JSON as? [NSObject:AnyObject]{
                    // print("\n responseJSON- - - - -data:", dic)
                    self?.processRequestResult(dic)
                }
                // 控件复位
                self?.mainCollection?.stopRefreshAnimation()
                self?.mainCollection?.stopLoadMoreAnimation()
            }, failure: {[weak self]( task, error) -> Void in
                print("\n failure: TIP --- e:\(error)")
                self?.mainCollection?.stopRefreshAnimation()
                self?.mainCollection?.stopLoadMoreAnimation()
        })
    }
    
    func processRequestResult(result:[NSObject:AnyObject]){
        if (200 == result["c"]?.integerValue){
            if let v = result["v"] as? [NSObject:AnyObject]{
                if let list = v["image_list"] as? [AnyObject]{
                    for item in list{
                        if let arr = item["imageurls"] as? [AnyObject]{// 组图
                            if arr.count > 0{
                                if let firstImageData = arr[0] as? [NSObject:AnyObject]{
                                    let data = ImageInfoData(dic: firstImageData)
                                    self.dataList.addObject(data)
                                }
                            }
                        }else{// 单图
                            if let data = item as? [NSObject:AnyObject]{
                                let data = ImageInfoData(dic: data)
                                self.dataList.addObject(data)
                            }
                        }
                    }
                    // print("\n---===---self.dataList = \(self.dataList)")
                    self.mainCollection?.reloadData()
                }
            }
        }else{
            // 失败时候清空数据后也要重新加载
            self.mainCollection?.reloadData()
        }
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView (collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        var sz = CGSize(width: 100.0, height: 100.0)
        if let data = self.dataList.objectAtIndex(indexPath.row) as? ImageInfoData{
            sz = CGSize(width: data.width, height: data.height)
        }
        return sz
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.dataList.count
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        if let imgData = dataList[indexPath.row] as? ImageInfoData{
            let detail = GalleryDetailController()
            self.navigationController?.pushViewController(detail, animated: true)
            detail.navigationItem.title =  imgData.desc;
        }
    }
}