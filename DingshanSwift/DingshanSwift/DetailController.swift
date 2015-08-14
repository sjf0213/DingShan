//
//  DetailController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/7/15.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import UIKit

class DetailController:UIViewController
{
    override func loadView()
    {
        super.loadView()
        self.view.backgroundColor = UIColor.whiteColor()
        
        
        var btn1 = UIButton(frame: CGRect(x:100,y:100,width:100,height:100));
        btn1.backgroundColor = UIColor.grayColor()
        let ccount = self.navigationController?.childViewControllers.count
        var labelText:String = String(format:"layer No.%d", ccount!)
        
        btn1.setTitle(labelText, forState: UIControlState.Normal)
        btn1.addTarget(self, action:Selector("onTapBtn:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn1)
    }
    
    func onTapBtn(sender:UIButton) {
        print(sender)
        var detail = DetailController()
        self.navigationController?.pushViewController(detail, animated: true)
        
    }
}