//
//  GalleryDetailController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/6.
//  Copyright (c) 2015年 song jufeng. All rights reserved.
//

import Foundation

class GalleryDetailController: DSViewController {
    var container:ScrollContainerView?
    override func loadView(){
        super.loadView()
        self.view.backgroundColor = UIColor.whiteColor()
        
        
    }
    
    override func viewDidLoad() {
        container = ScrollContainerView(frame: self.view.bounds);
        self.view.addSubview(container!)
    }
    
    func loadImageArray(arr:[AnyObject]){
        container?.addDataSourceByArray(arr)
    }
}