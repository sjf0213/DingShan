//
//  ForumNewThreadController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/9.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
import Alamofire
class ForumNewThreadController : DSViewController{
    
    private var sendBtn = UIButton()
    var request: Alamofire.Request? {
        didSet {
            oldValue?.cancel()
        }
    }
    override func loadView()
    {
        super.loadView()
        self.view.backgroundColor = UIColor.lightGrayColor()
        self.topTitle = "新话题"
        
        sendBtn = UIButton(frame: CGRect(x: self.view.bounds.size.width - 44, y: 20, width: 44, height: 44))
        sendBtn.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
        self.topView.addSubview(sendBtn)
        sendBtn.addTarget(self, action: Selector("onTapSend"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func onTapSend(){
        self.startRequest()
    }
    
    func startRequest(){
        let parameter = ["ctype" : "1",
                          "json" : "1"]
        let postBody = ["topic_title":"sjf_test_topic_title",
                        "topic_content":"sjf_test_topic_content"]
        
        
        let url = ApiBuilder.forum_create_topic(parameter)
        
        do{
            let theJSONData = try NSJSONSerialization.dataWithJSONObject(postBody, options: NSJSONWritingOptions(rawValue: 0))
            let theJSONText = NSString(data: theJSONData, encoding: NSASCIIStringEncoding)
            print("\ntheJSONText = \(theJSONText)")
            self.request = Alamofire.upload(.POST, url, data: theJSONData)
        }catch{
            print(error)
        }
    }
}