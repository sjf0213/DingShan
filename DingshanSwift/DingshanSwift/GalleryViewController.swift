//
//  GalleryViewController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/7/14.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
import Alamofire

let gallery_gap:CGFloat = 10.0

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
        seg?.selectedSegmentIndex = 1;
        
        menuView.frame = CGRectMake(0, self.topView.frame.size.height, self.view.bounds.size.width, 40)
        self.view.addSubview(menuView)
        menuView.menuTitleArr = [["title":"1"], ["title":"2"], ["title":"3"]]
        
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
        
    }
    
    override func viewDidLoad() {
        
        self.startRequest()
    }
    
    func onTapBtn(sender:UIButton) {
        print(sender, terminator: "")
        let detail = DetailController()
        self.navigationController?.pushViewController(detail, animated: true)
        
    }
    
    func startRequest(){
        let parameter = ["pindex" : "0",
                          "psize" : "10",
                     "categoryid" : "1",
                           "json" : "1"]
        let url = ApiBuilder.gallery_get_galary_single_list(parameter)
        print("url = \(url)", terminator: "")
        self.request = Alamofire.request(.GET, url)
        // JSON
        self.request?.responseJSON(completionHandler: {(request, response, result) -> Void in
        
            print("\n responseJSON- - - - -data = \(result)")
            // 下拉刷新时候清空旧数据（请求失败也清空）
            if (self.currentPage == 0 && self.dataList.count > 0){
                self.dataList.removeAllObjects()
            }
            // 如果请求数据有效
            if let dic = result.value as? NSDictionary{
                print("\n responseJSON- - - - -data is NSDictionary")
                self.processRequestResult(dic)
            }
            // 控件复位
            self.refreshView?.RefreshScrollViewDataSourceDidFinishedLoading(self.mainCollection)
            self.loadMoreView?.RefreshScrollViewDataSourceDidFinishedLoading(self.mainCollection)
        })
    }
    
    func processRequestResult(result:NSDictionary){
        if (200 == result["c"]?.integerValue){
            if let list = result["v"] as? NSDictionary{
                if let arr = list["image_list"] as? NSArray{
                    for var i = 0; i < arr.count; ++i {
                        if let item = arr[i] as? [String:AnyObject] {
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