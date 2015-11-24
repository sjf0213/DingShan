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
    }
}