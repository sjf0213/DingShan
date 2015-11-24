//
//  SNSShareView.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/11/24.
//  Copyright © 2015年 song jufeng. All rights reserved.
//

import Foundation
class SNSShareView:UIView{
    var cancelHandler: (() -> Void)?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame aRect: CGRect) {
        super.init(frame: aRect);
        self.backgroundColor = UIColor.whiteColor()
        let cancelBtn = UIButton(frame: CGRect(x: 10, y: frame.size.height - 50, width: frame.size.width - 20, height: 40))
        cancelBtn.backgroundColor = UIColor.lightGrayColor()
        self.addSubview(cancelBtn)
        
        let titleArr = ["微信好友", "朋友圈", "QQ", "微博"]
        let iconArr  = ["sns_weixin", "sns_moments", "sns_qq", "sns_weibo"]
        let w:CGFloat = 72.0
        let gap = (frame.size.width - 20.0 - 4*w)/5.0
        for (var i = 0; i < 4; i++){
            let btn = SNSShareBtn(frame: CGRect(x: 10.0+gap+CGFloat(i)*(w+gap), y: 0, width: w, height: 120))
            btn.setImage(UIImage(named: iconArr[i]), forState:UIControlState.Normal)
            btn.title = titleArr[i]
            self.addSubview(btn);
        }
        
    }
}