//
//  ForumNewThreadController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/9.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
import Alamofire
let edge_w:CGFloat = 15.0
class ForumNewThreadController : DSViewController{
    
    private var sendBtn = UIButton()
    private var titleTextField = UITextField()
    var request: Alamofire.Request? {
        didSet {
            oldValue?.cancel()
        }
    }
    override func loadView()
    {
        super.loadView()
        self.view.backgroundColor = UIColor.whiteColor()
        self.topTitle = "新话题"
        
        sendBtn = UIButton(frame: CGRect(x: self.view.bounds.size.width - 44, y: 20, width: 44, height: 44))
        self.view.bounds.size.width - 2*edge_w
        self.topView.addSubview(sendBtn)
        sendBtn.addTarget(self, action: Selector("onTapSend"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let btnSelectSection = UIView(frame: CGRect(x: 0, y: TopBar_H, width: self.view.bounds.size.width , height: 45))
        btnSelectSection.backgroundColor = UIColor(white: 236/255.0, alpha: 1.0)
        self.view.addSubview(btnSelectSection)
        
        let titleLabel = UILabel(frame: CGRect(x: edge_w, y: TopBar_H+btnSelectSection.bounds.height, width: 61 - edge_w , height: 40))
        titleLabel.font = UIFont.systemFontOfSize(15.0)
        titleLabel.text = "标题:"
        self.view.addSubview(titleLabel)
        
        titleTextField = UITextField(frame: CGRect(x: edge_w + titleLabel.bounds.width, y: TopBar_H+btnSelectSection.bounds.height, width: self.view.bounds.size.width - 2*edge_w - titleLabel.bounds.width, height: 40))
//        titleTextField.backgroundColor = UIColor.orangeColor().colorWithAlphaComponent(0.1)
        titleTextField.text = ""
        titleTextField.font = UIFont.systemFontOfSize(15.0)
        self.view.addSubview(titleTextField)
        
        let line1 = UIView(frame: CGRect(x: edge_w, y: titleTextField.frame.origin.y + titleTextField.bounds.height, width: self.view.bounds.size.width - 2*edge_w , height: 0.5))
        line1.backgroundColor = UIColor(white: 216/255.0, alpha: 1.0)
        self.view.addSubview(line1)
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