//
//  GalleryViewController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/7/14.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
import Alamofire

class GalleryViewController:DSViewController,UICollectionViewDataSource, UICollectionViewDelegate,CHTCollectionViewDelegateWaterfallLayout
{
    var seg:KASegmentControl?
    var menuView = GalleryMenuView()
//    var foldMenu:UIView?
    var mainCollection:UICollectionView?
    var refreshView:RefreshView?
    var loadMoreView:LoadView?
    var currentPage:NSInteger = 0
    var dataList =  NSMutableArray()
    
    var request: Alamofire.Request? {
        didSet {
            oldValue?.cancel()
        }
    }
    override func loadView()
    {
        super.loadView()
        self.view.backgroundColor = UIColor.whiteColor()
        
        seg = KASegmentControl(frame: CGRectMake((self.topView.frame.size.width - 140)*0.5, 27, 140, 30),
                            withItems: ["套图", "单图"],
                            withLightedColor: THEME_COLOR)
        self.topView.addSubview(seg!)
        seg?.selectedSegmentIndex = 0;
        
        menuView.frame = CGRectMake(0, self.topView.frame.size.height, self.view.bounds.size.width, 40)
        self.view.addSubview(menuView)
        menuView.menuTitleArr = [["title":"1"], ["title":"2"], ["title":"3"]]
        
        var layout = CHTCollectionViewWaterfallLayout()
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.columnCount = 2;
        layout.minimumColumnSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        
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
        
    }
    
    override func viewDidLoad() {
        
        self.startRequest()
    }
    
    func onTapBtn(sender:UIButton) {
        print(sender)
        var detail = DetailController()
        self.navigationController?.pushViewController(detail, animated: true)
        
    }
    
    func startRequest(){
        
        
//        "http://v3.kuaigame.com/app/getcategoryarticle?uid=223378&device=iPhone5%2C2&pindex=0&psize=20&appver=3.3.0&key=TDqKUTCWopMCLFvlJzOkR3NYGkI%3D&did=038D6DED-EC45-49D6-A616-CF887E1BEE07&e=1439807501&categoryid=1&clientid=21&aid=lIsGbvnD6lq5cl%2BUfayEum60dbE%3D&iosver=8.4.1";\
//        
        var parameter = ["pindex" : "0",
            "psize" : "50",
            "categoryid" : "1",
            "json" : "1"]
        var useJson = true
        var url = ApiBuilder.forum_get_galary_list(parameter)
        print("url = \(url)")
        self.request = Alamofire.request(.GET, url)
        // JSON
        self.request?.responseJSON(options: .AllowFragments, completionHandler: { (requst1:NSURLRequest, response1:NSHTTPURLResponse?, data:AnyObject?,err: NSError?) -> Void in
            
//            print("\n responseJSON- - - - -data = \(data)")
//            print("\n responseJSON- - - - -err = \(err)")
            // 下拉刷新时候清空旧数据（请求失败也清空）
            if (self.currentPage == 0 && self.dataList.count > 0){
                self.dataList.removeAllObjects()
            }
            // 如果请求数据有效
            if data is NSDictionary{
                print("\n responseJSON- - - - -data is NSDictionary")
                self.processRequestResult(data as! NSDictionary)
            }
            // 控件复位
            self.refreshView?.RefreshScrollViewDataSourceDidFinishedLoading(self.mainCollection)
            self.loadMoreView?.RefreshScrollViewDataSourceDidFinishedLoading(self.mainCollection)
        })
    }
    
    func processRequestResult(result:NSDictionary){
        if (200 == result["c"]?.integerValue){
            if let list = result["v"] as? NSDictionary{
                if let arr = list["list"] as? NSArray{
//                    print("\n dataArray- - -\(arr)")
                    self.dataList.addObjectsFromArray(arr as [AnyObject])
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
    
    func collectionView (collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSize(width: 200, height: 200)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
//        print("+++++++++++++++numberOfItemsInSection-------\(self.dataList.count)")
        return self.dataList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
//        print("+++++++++++++++cellForItemAtIndexPath-------\(indexPath)")
        var cell:GalleryViewCell? = collectionView.dequeueReusableCellWithReuseIdentifier(GalleryViewCellIdentifier, forIndexPath: indexPath) as? GalleryViewCell
        cell?.clearData()
        var item:NSDictionary = self.dataList.objectAtIndex(indexPath.item) as! NSDictionary
        cell?.loadCellData(item)
        return cell!;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
//        print("+++++++++++++++didSelectItemAtIndexPath-------\(indexPath)")
        var detail = GalleryDetailController()
        detail.navigationItem.title =  dataList[indexPath.item].string;
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
}