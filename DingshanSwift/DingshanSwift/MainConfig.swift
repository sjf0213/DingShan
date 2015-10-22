//
//  MainConfig.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/7/20.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation

class MainConfig {
    
//    static let sharedInstance: MainConfig = MainConfig()
    
    var rootDic:NSDictionary?
    var userInfo = UserInfoData()
    
    static let sharedInstance: MainConfig = MainConfig()
    
    init() {
        //println("MainConfig INIT...");
        let configPath = NSBundle.mainBundle().pathForResource("GeneralConfig", ofType: "plist")
        //print("\n-----configPath = \(configPath)")
        let exist = FileHelp.shareInstance().isFileExist(configPath)
        // print("\n-----isFileExist:\(exist)")
        if exist
        {
            self.rootDic = NSDictionary(contentsOfFile: configPath!);
            print("root dic = \(rootDic)", terminator: "")
        }
    }
    
}