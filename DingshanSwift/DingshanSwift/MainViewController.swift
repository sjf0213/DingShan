//
//  MainViewController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/7/14.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

//import Foundation
import UIKit

class MainViewController:UIViewController
{
    var tabbar:MainTabBar = MainTabBar()
    override func loadView()
    {
        super.loadView()
        self.view.backgroundColor = UIColor.cyanColor().colorWithAlphaComponent(0.8)
        
        tabbar.frame = CGRect(x: 0, y: self.view.bounds.height - 44, width: self.view.bounds.width, height: 44)
        self.view.addSubview(tabbar)
    }
}