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
    var refreshView:RefreshView?
    var loadMoreView:LoadView?
    var currentPage:NSInteger = 0
    var dataList =  NSMutableArray()
    var singleConfig:[AnyObject]?
    var multiConfig:[AnyObject]?
    
    override func loadView()
    {
        super.loadView()
        self.view.backgroundColor = UIColor.whiteColor()
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
            height: self.view.bounds.size.height - self.topView.bounds.size.height - self.menuView.bounds.size.height), collectionViewLayout: layout)
        mainCollection?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        mainCollection?.backgroundColor = UIColor.clearColor()
        mainCollection?.dataSource = self;
        mainCollection?.delegate = self;
        mainCollection?.registerClass(GalleryViewCell.classForCoder(), forCellWithReuseIdentifier: GalleryViewCellIdentifier)
        
        self.view.addSubview(mainCollection!)
        self.view.bringSubviewToFront(menuView)
        
        menuView.tapItemHandler = {(config:[NSObject:AnyObject]) -> Void in
            print("-----------Changed ! ! !userSelectConfig = \(config)")
            self.currentPage = 0
            self.startRequest(config)
        }
    }
    
    override func viewDidLoad() {
        seg?.selectedSegmentIndex = 1;
        self.startRequest(nil)
    }
    
    // 切换套图与单图
    func changeBySegIndex(index:Int)->Void{
        self.currentPage = 0
        self.dataList.removeAllObjects()
        mainCollection?.reloadData()
        if 0 == index{
            menuView.menuConfig = multiConfig!
        }
        if (1 == index){
            menuView.menuConfig = singleConfig!
        }
    }
    
    func onTapBtn(sender:UIButton) {
        print(sender, terminator: "")
        let detail = DetailController()
        self.navigationController?.pushViewController(detail, animated: true)
        
    }
    
    func startRequest(config:[NSObject:AnyObject]?){
        var parameter:[NSObject:AnyObject] = [  "iid" : String(self.currentPage),
                                              "psize" : "10",
                                               "json" : "1"]
        if config != nil{
            for one in config! {
                parameter[one.0] = one.1
            }
        }
        print("Multi = = = = = = =parameter = \(parameter)", terminator: "")
        var type = ""
        if 0 == seg?.selectedSegmentIndex{
            type = "multi"
        }else if 1 == seg?.selectedSegmentIndex{
            type = "single"
        }
        let url = ServerApi.gallery_get_galary_list(type, dic:parameter)
        
        print("url = \(url)", terminator: "")
        AFDSClient.sharedInstance.GET(url, parameters: nil,
            success: {(task, JSON) -> Void in
        
//                print("\n responseJSON- - - - -data = \(JSON)")
                // 下拉刷新时候清空旧数据（请求失败也清空）
                if (self.currentPage == 0 && self.dataList.count > 0){
                    self.dataList.removeAllObjects()
                }
                // 如果请求数据有效
                if let dic = JSON as? [NSObject:AnyObject]{
//                    print("\n responseJSON- - - - -data:", dic)
                    self.processRequestResult(dic)
                }
                // 控件复位
                self.refreshView?.RefreshScrollViewDataSourceDidFinishedLoading(self.mainCollection)
                self.loadMoreView?.RefreshScrollViewDataSourceDidFinishedLoading(self.mainCollection)
            }, failure: {( task, error) -> Void in
                print("\n failure: TIP --- e:\(error)")
        })
    }
    
    func processRequestResult(result:[NSObject:AnyObject]){
        if (200 == result["c"]?.integerValue){
            if let list = result["v"] as? [NSObject:AnyObject]{
                if let arr = list["image_list"] as? [AnyObject]{
                    for var i = 0; i < arr.count; ++i {
                        if let item = arr[i] as? [NSObject:AnyObject] {
                            let data = ImageInfoData(dic: item)
                            self.dataList.addObject(data)
                        }
                    }
                    self.mainCollection?.reloadData()
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
            self.mainCollection?.reloadData()
        }
    }
// MARK: UICollectionViewDelegate
    func collectionView (collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let w:CGFloat = (self.view.bounds.size.width - (3 * gallery_gap)) * 0.5
        var h = w;
        if let data = self.dataList.objectAtIndex(indexPath.item) as? ImageInfoData{
            if (data.width != 0 && data.height != 0){// 如果没有宽高数据，则显示方形图片
                h = w * CGFloat(data.height) / CGFloat(data.width)
            }
        }
        let rt = CGSize(width: w, height: h)
        return rt
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.dataList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
//        print("+++++++++++++++cellForItemAtIndexPath-------\(indexPath)")
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(GalleryViewCellIdentifier, forIndexPath: indexPath) as? GalleryViewCell{
            cell.clearData()
            if let item = self.dataList.objectAtIndex(indexPath.item) as? ImageInfoData{
                cell.loadCellData(item)
            }
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
//        print("+++++++++++++++didSelectItemAtIndexPath-------\(indexPath)")
        if let imgData = dataList[indexPath.item] as? ImageInfoData{
            let detail = GalleryDetailController()
            self.navigationController?.pushViewController(detail, animated: true)
            detail.navigationItem.title =  imgData.desc;
        }
    }
}