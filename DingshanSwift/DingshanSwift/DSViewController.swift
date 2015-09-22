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
            self.topView.title = topTitle
        }
    }
    var backBtnHidden = false{
        didSet{
            self.topView.backBtnHidden = backBtnHidden
        }
    }
    
    //////////////////////////
    override func loadView(){
        super.loadView()
        self.navigationController?.navigationBar.hidden = true;
        topView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, TopBar_H)
        self.view.addSubview(topView);
        
        topView.backBlock = {self.navigationController?.popViewControllerAnimated(true)}
    }
    
    override func viewDidLoad() {
        self.view.bringSubviewToFront(topView)
    }
    
    func close()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
}