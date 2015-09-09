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
    var topView = TopBarView()
    var topTitle = ""{
        didSet{
            self.titleLabel.text = topTitle
        }
    }
    private var titleLabel = UILabel()
    override func loadView()
    {
        super.loadView()
        self.navigationController?.navigationBar.hidden = true;
        topView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, TopBar_H)
        topView.backgroundColor = NAVI_COLOR
        self.view.addSubview(topView);
        
        titleLabel.frame = CGRect(x:44, y:20, width:topView.bounds.size.width - 88, height:topView.bounds.size.height - 20)
        titleLabel.textAlignment = NSTextAlignment.Center
        topView.addSubview(titleLabel)
    }
    
    override func viewDidLoad() {
        self.view.bringSubviewToFront(topView)
    }
}