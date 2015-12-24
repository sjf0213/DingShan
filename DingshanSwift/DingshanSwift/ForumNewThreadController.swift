//
//  ForumNewThreadController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/9.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation
let edge_w:CGFloat = 15.0
class ForumNewThreadController : DSViewController{
    
    private var sendBtn = UIButton()
    private var titleTextField = UITextField()
    private var contentTextView = UITextView()
    private var stageMenu : StageMenuToggleBtn?
    var stageIndex:Int = 0
    
    
    private var isStageMenuExpanded:Bool = false
    private var mask:UIView?// 黑色半透明背景，相应点击收起
    
    override func loadView()
    {
        super.loadView()
        self.view.backgroundColor = UIColor.whiteColor()
        self.topTitle = "新话题"
        
        sendBtn = UIButton(frame: CGRect(x: self.view.bounds.size.width - 44, y: 20, width: 44, height: 44))
        sendBtn.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.1)
        sendBtn.setTitle("发送", forState: UIControlState.Normal)
        sendBtn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.topView.addSubview(sendBtn)
        sendBtn.addTarget(self, action: Selector("onTapSend"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let btnSelectSection = UIView(frame: CGRect(x: 0, y: TopBar_H, width: self.view.bounds.size.width , height: 45))
        btnSelectSection.backgroundColor = UIColor(white: 236/255.0, alpha: 1.0)
        self.view.addSubview(btnSelectSection)
        
        
        // 阶段选择配置
        var stageConfig = [AnyObject]()
        if let config = MainConfig.sharedInstance.rootDic?["StageMenu"] as? [AnyObject]{
            stageConfig = config
        }
//        stageMenu = StageMenuView(frame: CGRect(x: 0, y: TopBar_H, width: self.view.bounds.size.width, height: TopBar_H - 20))
//        stageMenu?.menuConfig = stageConfig
//        self.view.addSubview(stageMenu!)
//        stageMenu?.tapItemHandler = {[weak self](index:Int) -> Void in
//            self?.stageIndex = index
//        }
        
        stageMenu = StageMenuToggleBtn(frame: CGRect(x: 0, y: TopBar_H, width: self.view.bounds.size.width, height: TopBar_H - 20))
        self.view.addSubview(stageMenu!)
        stageMenu?.expandHandler = {[weak self]() -> Void in
            if(self?.isStageMenuExpanded == false){
                self?.expandMenu()
            }else{
                self?.shrinkMenu()
            }
        }
        
        let titleLabel = UILabel(frame: CGRect(x: edge_w, y: TopBar_H+btnSelectSection.bounds.height, width: 61 - edge_w , height: 40))
        titleLabel.font = UIFont.systemFontOfSize(15.0)
        titleLabel.text = "标题:"
        self.view.addSubview(titleLabel)
        
        titleTextField = UITextField(frame: CGRect(x: edge_w + titleLabel.bounds.width, y: TopBar_H+btnSelectSection.bounds.height, width: self.view.bounds.size.width - 2*edge_w - titleLabel.bounds.width, height: 40))
        titleTextField.text = ""
        titleTextField.font = UIFont.systemFontOfSize(15.0)
        self.view.addSubview(titleTextField)
        
        let line1 = UIView(frame: CGRect(x: edge_w, y: titleTextField.frame.origin.y + titleTextField.bounds.height, width: self.view.bounds.size.width - 2*edge_w , height: 0.5))
        line1.backgroundColor = UIColor(white: 216/255.0, alpha: 1.0)
        self.view.addSubview(line1)
        
        let cy = line1.frame.origin.y + line1.frame.size.height
        contentTextView = UITextView(frame: CGRect(x: edge_w, y: cy, width: self.view.bounds.size.width - 2*edge_w, height: self.view.bounds.size.height - cy))
        contentTextView.backgroundColor = UIColor.orangeColor().colorWithAlphaComponent(0.2)
        contentTextView.text = ""
        contentTextView.font = UIFont.systemFontOfSize(15.0)
        self.view.addSubview(contentTextView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bringSubviewToFront(stageMenu!)
    }
    
    func onTapSend(){
        self.startRequest()
    }
    
    func startRequest(){
        let parameter = ["ctype" : String(self.stageIndex),
                          "json" : "1"]
        let strTitle = titleTextField.text
        let strContent = contentTextView.text
        if (strTitle != nil && strContent != nil){
            let postBody = ["topic_title":strTitle,
                          "topic_content":strContent]
            let url = ServerApi.forum_create_topic(parameter)
            
            AFDSClient.sharedInstance.POST(url, parameters: postBody,
                success: {(task, JSON) -> Void in
                    // 如果请求数据有效
                    if let dic = JSON as? [NSObject:AnyObject]{
                        debugPrint("\n responseJSON- - - - -data:\(JSON)")
                        if (200 == dic["c"]?.integerValue){
                            self.close()
                        }
                    }
                }, failure: {( task, error) -> Void in
                    print("\n failure: TIP --- e:\(error)")
                })
        }
    }
    
    func resetMenu(){
        self.shrinkMenu()
    }
    
    func expandMenu(){
        print("-------------expand-------------")
        self.isStageMenuExpanded = true
        //                self.mainBtn.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width - 100, height: TopBar_H - 21)
        self.mask = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height))
        self.mask?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        self.mask?.alpha = 1.0
        let tapRec = UITapGestureRecognizer(target: self, action: Selector("resetMenu"))
        self.mask?.addGestureRecognizer(tapRec)
        self.view.addSubview(self.mask!)
    }
    
    func shrinkMenu(){
        print("-------------shrink-------------")
        self.isStageMenuExpanded = false
        self.mask?.removeFromSuperview()
        self.mask = nil
    }
}