//
//  ServerApi.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/10/26.
//  Copyright © 2015年 song jufeng. All rights reserved.
//

import UIKit

class ServerApi: NSObject {
    static let HostName = "http://www.kokoguo.com/"
    static let APISECRECTKEY = "idingshan"    //普通 api的加密key
    static let APICheckTimeInterval = 60*5
    
    var startDate = NSDate().timeIntervalSince1970
    class var sharedInstance: ServerApi {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: ServerApi? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = ServerApi()
        }
        return Static.instance!
    }
    
    class func signatureURL(url:String, args:[NSObject : AnyObject]?)-> String{
        let targetUrlString = HostName + url
        print("\ntargetUrl = ", targetUrlString)
        // 添加基本用户参数
        var finalDic:[NSObject:AnyObject] = ["uid":"1","aid":"asdf","json" : "1"]
//        var finalDic:[NSObject:AnyObject] = ["uid":String(MainConfig.sharedInstance.userInfo.uid),
//                                             "aid":MainConfig.sharedInstance.userInfo.aid]

        // 添加额外的参数
        if args != nil{
            for (onekey, onevalue) in args! {
                finalDic[onekey] = onevalue
            }
        }
        var result = targetUrlString
        result += "?"
        for (onekey, onevalue) in finalDic{
            result += String(format:"%@=%@", onekey, CommonUtility.urlEncodedString(onevalue as? String))
            result += "&"
        }
        result = result.substringToIndex(result.endIndex.predecessor())// 去掉最后一个"&"
        print("signatureURL.result = ", result)
        return result as String;
    }
    
    // 讨论区话题列表
    class func forum_get_topic_list(dic:[NSObject : AnyObject]) -> String{
        return ServerApi.signatureURL("dingshan/topic/topiclist", args: dic)
    }
    class func forum_get_floor_list(dic:[NSObject : AnyObject]) -> String{
        return ServerApi.signatureURL("dingshan/topic/floorlist", args: dic)
    }
    class func forum_get_reply_list(dic:[NSObject : AnyObject]) -> String{
        return ServerApi.signatureURL("dingshan/topic/replylist", args: dic)
    }
    class func forum_create_topic(dic:[NSObject : AnyObject]) -> String{
        return ServerApi.signatureURL("dingshan/topic/createtopic", args: dic)
    }
    
    // 图库列表
    class func gallery_get_galary_single_list(dic:[NSObject : AnyObject]) -> String{
        return ServerApi.signatureURL("dingshan/images/singleimageslist", args: dic)
    }
    class func gallery_get_galary_multi_list(dic:[NSObject : AnyObject]) -> String{
        return ServerApi.signatureURL("dingshan/images/multiimageslist", args: dic)
    }
    
    // 用户
    class func user_create_new(dic:[NSObject : AnyObject]) -> String{
        let url = "dingshan/user/createnewuser"
        let targetUrlString = HostName + url
        print("\ntargetUrl = ", targetUrlString)
        
        var result = targetUrlString
        result += "?"
        for (onekey, onevalue) in dic{
            result += String(format:"%@=%@", onekey, CommonUtility.urlEncodedString(onevalue as? String))
            result += "&"
        }
        result = result.substringToIndex(result.endIndex.predecessor())
        print("signatureURL.result = ", result)
        return result as String;
    }
    class func user_update_info() -> String{
        return ServerApi.signatureURL("dingshan/user/updateuserinfo", args: nil)
    }
}
