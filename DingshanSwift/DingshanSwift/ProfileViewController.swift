//
//  ProfileViewController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/7/14.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import UIKit
let myTopInset:CGFloat = 295
class ProfileViewController:DSViewController,UITableViewDelegate
{
    var delegate:AnyObject?
    var mainTable = UITableView()
    var tableSource:ArrayDataSource?
    
    
    override func loadView()
    {
        super.loadView()
        self.topView.hidden = true
        self.view.backgroundColor = UIColor.whiteColor()
        
        
//        let topMenuView = UIView(frame: CGRect(x: 0, y: infoView.frame.size.height - 49, width: infoView.frame.size.width, height: 49))
//        topMenuView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
//        infoView.addSubview(topMenuView)
//        
//        let subleftView = UIView(frame: CGRect(x: 0, y: -myTopInset - 20 + infoView.frame.size.height + 20, width: 150, height: 78))
//        subleftView.backgroundColor = UIColor.orangeColor().colorWithAlphaComponent(0.3)
//        self.mainTable.addSubview(subleftView)
//        
//        let subrightView = UIView(frame: CGRect(x: 170, y: -myTopInset - 20 + infoView.frame.size.height + 20, width: 150, height: 78))
//        subrightView.backgroundColor = UIColor.orangeColor().colorWithAlphaComponent(0.3)
//        self.mainTable.addSubview(subrightView)
//        
//        topMenuView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
//        infoView.addSubview(topMenuView)
        
        
        self.tableSource = ArrayDataSource(withcellIdentifier: "ProfileViewCell", withFirstRowIdentifier: "ProfileUserInfoCell", configureCellBlock: {(cell, data) in
            if let itemCell = cell as? ProfileViewCell{
                itemCell.clearData()
                if let d = data as? Dictionary<String,String>{
                    itemCell.loadCellData(d)
                }
            }
            
            if let itemCell = cell as? ProfileUserInfoCell{
                itemCell.parentdelegate = self
            }
        })
        
        let datasource:Array = ["1","2","3"];
        
        self.tableSource?.appendWithItems(datasource)
        
        
        mainTable.frame = self.view.bounds
        mainTable.delegate = self;
        mainTable.dataSource = self.tableSource
        mainTable.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.2)
//        mainTable.contentInset = UIEdgeInsets(top: myTopInset, left: 0, bottom: 0, right: 0)
        self.view.addSubview(self.mainTable)
        
        mainTable.registerClass(ProfileViewCell.classForCoder(), forCellReuseIdentifier: "ProfileViewCell")
        mainTable.registerClass(ProfileUserInfoCell.classForCoder(), forCellReuseIdentifier: "ProfileUserInfoCell")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("refreshInfo"), name: Notification_UpdateUserInfo, object: nil)
        
    }
    
    func onTapLogin() {
        print("onTapLogin", terminator: "")
        let controller = ProfileLoginController()
        controller.loginDelegate = self.delegate
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func onTapEditInfo() {
        let controller = ProfileUserInfoEditController()
        controller.ossDelegate = self.delegate
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
//        print("\n\(self.classForCoder) didSelectRowAtIndexPath = \(indexPath)", terminator: "")
//        if let  cell = tableView.cellForRowAtIndexPath(indexPath) as? HomeCell{
//            let detail = ForumFloorListController()
//            detail.navigationItem.title = cell.title.text
//            self.navigationController?.pushViewController(detail, animated: true)
//            if let data = self.tableSource?.items[indexPath.row] as? ForumTopicData{
//                detail.loadFloorListByTopicData(data)
//            }
//        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if (indexPath.row == 0)
        {
            return myTopInset
        }
        else
        {
            return 50
        }
    }

}