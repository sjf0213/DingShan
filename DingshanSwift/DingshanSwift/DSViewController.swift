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
    var backBtnHidden = false{
        didSet{
            self.backBtn.hidden = backBtnHidden
        }
    }
    private var titleLabel = UILabel()
    private var backBtn = UIButton()
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
        
        backBtn.frame = CGRect(x: 0, y: 20, width: 44, height: 44)
        backBtn.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.5)
        self.topView.addSubview(backBtn)
        backBtn.addTarget(self, action: Selector("onTapBack"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    override func viewDidLoad() {
        self.view.bringSubviewToFront(topView)
    }
    
    func onTapBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}