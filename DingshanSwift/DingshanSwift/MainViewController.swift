//
//  MainViewController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/7/14.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

//import Foundation
import UIKit

let MAIN_TAB_H:CGFloat = 50

class MainViewController:UIViewController
{
    var tabbar:MainTabBar?
    var homeController:HomeViewController?
    var homeNavi:UINavigationController?
    var galleryController:GalleryViewController?
    var galleryNavi:UINavigationController?
    var profileController:ProfileViewController?
    var profileNavi:UINavigationController?
    override func loadView()
    {
        super.loadView()
        self.view.backgroundColor = UIColor.cyanColor()
    }
    
    override func viewDidLoad() {
        tabbar = MainTabBar(frame: CGRect(x: 0, y: self.view.bounds.height - MAIN_TAB_H, width: self.view.bounds.width, height: MAIN_TAB_H))
        tabbar?.delegate = self;
        self.view.addSubview(tabbar!)
        
        tabbar?.setHomeIndex(0);
        
        let config = MainConfig.sharedInstance
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
                homeNavi = UINavigationController(rootViewController: homeController!)
                self.view.addSubview(homeNavi!.view)
            }
            tabbar?.removeFromSuperview()
            homeController?.view.addSubview(tabbar!)
            self.view.bringSubviewToFront(homeNavi!.view)
            break
        case 1:
            if galleryController == nil{
                galleryController = GalleryViewController()
                galleryNavi = UINavigationController(rootViewController: galleryController!)
                self.view.addSubview(galleryNavi!.view)
            }
            tabbar?.removeFromSuperview()
            galleryController?.view.addSubview(tabbar!)
            self.view.bringSubviewToFront(galleryNavi!.view)
            break
        case 2:
            if profileController == nil{
                profileController = ProfileViewController()
                profileNavi = UINavigationController(rootViewController: profileController!)
                self.view.addSubview(profileNavi!.view)
            }
            tabbar?.removeFromSuperview()
            profileController?.view.addSubview(tabbar!)
            self.view.bringSubviewToFront(profileNavi!.view)
            break
        default:
            break
        }
        self.view.bringSubviewToFront(tabbar!)
    }
}