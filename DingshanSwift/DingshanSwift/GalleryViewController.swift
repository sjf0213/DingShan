//
//  GalleryViewController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/7/14.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import UIKit

class GalleryViewController:DSViewController
{
    var seg:KASegmentControl?
    var foldMenu:UIView?
    var mainCollection:UICollectionView?
    override func loadView()
    {
        super.loadView()
        self.view.backgroundColor = UIColor.whiteColor()
        
        seg = KASegmentControl(frame: CGRectMake((self.topView.frame.size.width - 140)*0.5, 27, 140, 30),
                            withItems: ["套图", "单图"],
                            withLightedColor: THEME_COLOR)
        self.topView.addSubview(seg!)
        seg?.selectedSegmentIndex = 0;
        
        foldMenu = UIView(frame: CGRectMake(0, self.topView.frame.size.height, self.view.bounds.size.width, 40))
        foldMenu?.backgroundColor = UIColor(white: 0.9, alpha: 0.5)
        self.view.addSubview(foldMenu!)
        
        var layout = CHTCollectionViewWaterfallLayout()
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.columnCount = 2;
        layout.minimumColumnSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        
        mainCollection = UICollectionView(frame: CGRect(x: 0,
            y: self.topView.bounds.size.height,
            width: self.view.bounds.size.width,
            height: self.view.bounds.size.height - self.topView.bounds.size.height), collectionViewLayout: layout)
        mainCollection?.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        mainCollection?.backgroundColor = UIColor.orangeColor()
        
        
    }
    
    func onTapBtn(sender:UIButton) {
        print(sender)
        var detail = DetailController()
        self.navigationController?.pushViewController(detail, animated: true)
        
    }
}