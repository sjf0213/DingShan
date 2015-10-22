//
//  UserInfoData.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/9.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class UserInfoData : NSObject {
    
    // 必要数据
    var uid:Int = 0// 用户id
    var aid:String = ""// 授权id
    var did:String = ""// 设备id
    
    // 基本显示资料
    var userName:String = ""//用户昵称
    var userHeadUrl:String = ""//用户头像
    
    // 附加资料
    var userGender:Int = 0//用户性别，0：女，1：男
    var userEmailAddr:String = ""//用户邮箱
    var userPhoneNum:String = ""//用户手机号
    
    required override init() {
        super.init()
    }
    
    init( dic : [String: AnyObject]){
        // 必要数据
        if let tmp = dic["uid"] as? String {
            uid = Int(tmp)!
        }
        if let tmp = dic["aid"] as? String {
            aid = tmp
        }
        if let tmp = dic["did"] as? String {
            aid = tmp
        }
        
        // 基本显示资料
        if let tmp = dic["nickname"] as? String {
            userName = tmp
        }
        if let tmp = dic["imgurl"] as? String {
            userHeadUrl = tmp
        }
        
        // 附加资料
        if let tmp = dic["gender"] as? String {
            userGender = Int(tmp)!
        }
        if let tmp = dic["email"] as? String {
            userEmailAddr = tmp
        }
        if let tmp = dic["phone"] as? String {
            userPhoneNum = tmp
        }
    }
}