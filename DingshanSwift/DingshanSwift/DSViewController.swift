//
//  DSViewController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/8/13.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import UIKit

class DSViewController:UIViewController
{
    var topView : UIView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, TOPNAVI_H))
    override func loadView()
    {
        super.loadView()
        self.navigationController?.navigationBar.hidden = true;
        topView.backgroundColor = NAVI_COLOR
        self.view.addSubview(topView);
        
        let topline = UIView(frame: CGRect(x: 0, y: topView.bounds.height - 0.5, width: topView.bounds.width, height: 0.5))
        topline.backgroundColor = UIColor.grayColor()
        topView.addSubview(topline)
    }
}