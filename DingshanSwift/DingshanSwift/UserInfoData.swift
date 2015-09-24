//
//  UserInfoData.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/9.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
class UserInfoData : NSObject {
    
    // 数据
    var uid:Int = 0
    var aid:String = ""
    
    // 可显示资料
    var userName:String = ""//用户昵称
    var userHeadUrl:String = ""//用户头像
    
    var userGender:String = ""//用户性别
    var userEmailAddr:String = ""//用户邮箱
    var userPhoneNum:String = ""//用户手机号
    
}