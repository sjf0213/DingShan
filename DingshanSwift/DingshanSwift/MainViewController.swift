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
    var tabbar:MainTabBar?
    var homeController:HomeViewController?
    var galleryController:GalleryViewController?
    var profileController:ProfileViewController?
    override func loadView()
    {
        super.loadView()
        self.view.backgroundColor = UIColor.cyanColor()
    }
    
    override func viewDidLoad() {
        tabbar = MainTabBar(frame: CGRect(x: 0, y: self.view.bounds.height - 44, width: self.view.bounds.width, height: 44))
        tabbar?.delegate = self;
        self.view.addSubview(tabbar!)
    }
}

extension MainViewController : MainTabBarDelegate
{
    func didSelectTabButton(tag:Int)
    {
        print("..."+String(tag))
        
        switch tag {
        case 0:
            if homeController == nil{
                homeController = HomeViewController()
                self.view.addSubview(homeController!.view)
            }
            self.view.bringSubviewToFront(homeController!.view)
            break
        case 1:
            if galleryController == nil{
                galleryController = GalleryViewController()
                self.view.addSubview(galleryController!.view)
            }
            self.view.bringSubviewToFront(galleryController!.view)
            break
        case 2:
            if profileController == nil{
                profileController = ProfileViewController()
                self.view.addSubview(profileController!.view)
            }
            self.view.bringSubviewToFront(profileController!.view)
            break
        default:
            break
        }
        self.view.bringSubviewToFront(tabbar!)
    }
}