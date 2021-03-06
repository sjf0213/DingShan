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
    
    var rootDic:[NSObject:AnyObject]?
    var userInfo = UserInfoData()
    var userLoginDone = false // 记录用户是否主动登录（还是跳过登录以游客身份浏览）
    
    static let sharedInstance: MainConfig = MainConfig()
    
    init() {
        //println("MainConfig INIT...");
        let configPath = NSBundle.mainBundle().pathForResource("GeneralConfig", ofType: "plist")
        //print("\n-----configPath = \(configPath)")
        let exist = FileHelp.shareInstance().isFileExist(configPath)
        // print("\n-----isFileExist:\(exist)")
        if exist
        {
            if let dict = NSDictionary(contentsOfFile: configPath!) as? Dictionary<NSObject, AnyObject> {
                self.rootDic = dict
            }
//            print("\nroot dic = \(rootDic)", terminator: "")
        }
    }
    
}