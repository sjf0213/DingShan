//
//  AFDSClient.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/10/27.
//  Copyright © 2015年 song jufeng. All rights reserved.
//

import Foundation
class AFDSClient: AFHTTPSessionManager {
    
    class var sharedInstance: AFDSClient {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: AFDSClient? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = AFDSClient(baseURL: NSURL(string: HostName))
            Static.instance!.securityPolicy = AFSecurityPolicy(pinningMode: AFSSLPinningMode.None)
        }
        return Static.instance!
    }
    
}