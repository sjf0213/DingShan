//
//  HomeGridViewController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/8/7.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

let homeBgArr = ["home1","home2","home3","home4","home5","home6","home7","home8","home9"]
let homeTitleArr = ["准备阶段","拆改阶段","水电阶段","泥木阶段","油漆阶段","竣工验收","软装阶段","入住阶段","心得体会"]
import Foundation
class HomeGridViewController:DSViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    var mainCollectionView:UICollectionView?
    var layout:UICollectionViewFlowLayout?
    
    override func loadView()
    {
        // SNS区
        super.loadView()
//        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
//        self.navigationController?.navigationBar.backgroundColor = NAVI_COLOR
        self.view.backgroundColor = UIColor.whiteColor();
        self.navigationItem.title = "首页"
        layout = UICollectionViewFlowLayout()
        let w = 0.5 * (self.view.bounds.size.width - 44)
        let h = w * 160.0 / 275.0
        print("w = \(w) h = \(h)")
        layout?.itemSize = CGSize(width:w, height:h);
        layout?.minimumLineSpacing = 9.0;
        layout?.minimumInteritemSpacing = 14.0;
        layout?.footerReferenceSize = CGSize(width: w*2+14, height: h)
        layout?.sectionInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        mainCollectionView = UICollectionView(frame: CGRect(x: 15, y: TopBar_H, width: self.view.bounds.size.width-30, height: self.view.bounds.size.height), collectionViewLayout: layout!)
        mainCollectionView?.backgroundColor = UIColor.clearColor();
        mainCollectionView?.dataSource = self
        mainCollectionView?.delegate = self
        mainCollectionView?.registerClass(HomeGridCell.classForCoder(), forCellWithReuseIdentifier: HomeGridCellIdentifier)
        mainCollectionView?.registerClass(HomeGridCell.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: HomeGridFooterIdentifier)
        self.view.addSubview(mainCollectionView!)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 8
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        var cell : HomeGridCell? = collectionView.dequeueReusableCellWithReuseIdentifier(HomeGridCellIdentifier, forIndexPath: indexPath) as? HomeGridCell
        cell?.clearData()
        cell?.loadCellData(["bg":homeBgArr[indexPath.row],
                         "title":homeTitleArr[indexPath.row]])
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
    {
        var footer:HomeGridCell? = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: HomeGridFooterIdentifier, forIndexPath: indexPath)  as? HomeGridCell
        footer?.clearData()
        footer?.loadCellData(["bg":homeBgArr[8],
                        "title":homeTitleArr[8]])
        return footer!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        print("\n didSelectRowAtIndexPath = \(indexPath)")
        var cell = mainCollectionView?.cellForItemAtIndexPath(indexPath) as? HomeGridCell
        var detail = HomeController()
        detail.navigationItem.title = cell?.title?.text
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    
}