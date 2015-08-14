//
//  GalleryViewController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/7/14.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import UIKit

class GalleryViewController:DSViewController
{
    var seg:KASegmentControl?
    override func loadView()
    {
        super.loadView()
        self.view.backgroundColor = UIColor.whiteColor()
        
        seg = KASegmentControl(frame: CGRectMake((self.topView.frame.size.width - 140)*0.5, 27, 140, 30),
                            withItems: ["套图", "单图"],
                            withLightedColor: THEME_COLOR)
        self.topView.addSubview(seg!)
        seg?.selectedSegmentIndex = 0;
        
        var btn1 = UIButton(frame: CGRect(x:100,y:100,width:100,height:100));
        btn1.backgroundColor = UIColor.lightGrayColor()
        btn1.setTitle("go detail", forState: UIControlState.Normal)
        btn1.addTarget(self, action:Selector("onTapBtn:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn1)
    }
    
    func onTapBtn(sender:UIButton) {
        print(sender)
        var detail = DetailController()
        self.navigationController?.pushViewController(detail, animated: true)
        
    }
}