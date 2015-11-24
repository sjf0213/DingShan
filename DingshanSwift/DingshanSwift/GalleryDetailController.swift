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
    var topBar:GalleryDetailTopBar?
    var bottomBar:GalleryDetailBottomBar?
    var titleCache:String = ""
    var mask : UIButton?
    var menuView : GalleryDetailMenuView?
    override func loadView(){
        super.loadView()
        self.view.backgroundColor = UIColor.blackColor()
        container = ScrollContainerView(frame: self.view.bounds);
        self.view.addSubview(container!)
        // KVO
        container?.addObserver(self, forKeyPath: "totalShowCount", options: NSKeyValueObservingOptions.New, context: nil)
        container?.addObserver(self, forKeyPath: "currentShowNumber", options: NSKeyValueObservingOptions.New, context: nil)
        
        topBar = GalleryDetailTopBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 64));
        self.view.addSubview(self.topBar!)
        topBar?.backBlock = {self.navigationController?.popViewControllerAnimated(true)}
        topBar?.tapMoreBlock = {
            if nil == self.menuView{
                let menu = GalleryDetailMenuView(frame: CGRect(x: self.view.frame.size.width - 90, y: -120, width: 80, height: 100))
                self.menuView = menu
                self.menuView?.tapMenuItemHandler = {(index) -> Void in
                    switch index{
                        case 0:
                            let tempview = self.container?.getCurrentShowView()
                            if ((tempview?.respondsToSelector(Selector("SaveToAlbum:"))) == true) {
                                tempview?.performSelector(Selector("SaveToAlbum:"), withObject:self.view, afterDelay:0)
                            }
                            break
                        default:
                            break
                    }
                    self.onTapMask()
                }
                self.view.addSubview(self.menuView!)
            }
            //MotionBlur
            self.menuView?.enableBlurWithAngle(CGFloat(M_PI_2), completion: { () -> Void in
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options:UIViewAnimationOptions([.AllowUserInteraction, .BeginFromCurrentState]), animations: { () -> Void in
                    self.menuView?.frame = CGRect(x: self.view.frame.size.width - 90, y: 54, width: 80, height: 100)
                    }, completion: { (finished) -> Void in
                        self.menuView?.disableBlur()
                })
            })
            self.mask?.hidden = false
        }
        
        bottomBar = GalleryDetailBottomBar(frame: CGRect(x: 0, y: self.view.frame.size.height - 44, width: self.view.frame.size.width, height: 44));
        self.view.addSubview(self.bottomBar!)
        if (titleCache.characters.count > 0){
            bottomBar?.title = titleCache
        }
        
        self.mask = UIButton(frame: self.view.bounds)
        self.mask?.backgroundColor = UIColor.clearColor()
        self.mask?.hidden = true
        self.mask?.addTarget(self, action: Selector("onTapMask"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.mask!)
        
        // 单击手势
        let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("onTapView"))
        self.view.addGestureRecognizer(tapRecognizer)
        
    }
    
    override func viewDidLoad() {
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (keyPath == "currentShowNumber" ||
            keyPath ==  "totalShowCount"){
            self.bottomBar?.pageText = String(format:"%zd / %zd", (self.container?.currentShowNumber)!, (self.container?.totalShowCount)!)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
    // 供单图使用
    func loadImageData(data:ImageInfoData){
        let arr:[AnyObject] = [data.url]
        
        dispatch_async(dispatch_get_main_queue(),{ [weak self]() -> Void in
            self?.container?.addDataSourceByArray(arr)
            self?.bottomBar?.title = data.desc
            self?.bottomBar?.hidePageTip = true;
        })
    }
    
    // 供多图使用
    func loadDetailTitle(title:String){
        self.titleCache = title
    }
    // 供多图使用
    func startRequest(imageSetId:Int){
        
        let parameter:[NSObject:AnyObject] = [ "iid" : String(imageSetId),
                                              "json" : "1"]
        let url = ServerApi.gallery_get_galary_detail(parameter)
         print("\n---$$$---url = \(url)", terminator: "")
        AFDSClient.sharedInstance.GET(url, parameters: nil,
            success: {[weak self](task, JSON) -> Void in
                print("\n responseJSON- - - - -data = \(JSON)")
                // 如果请求数据有效
                if let dic = JSON as? [NSObject:AnyObject]{
                    // print("\n responseJSON- - - - -data:", dic)
                    self?.processRequestResult(dic)
                }
            }, failure: {( task, error) -> Void in
                print("\n failure: TIP --- e:\(error)")
            })
    }
    
    func processRequestResult(result:[NSObject:AnyObject]){
        if (200 == result["c"]?.integerValue){
            if let list = result["v"] as? [AnyObject]{
                var urlArr:[AnyObject] = [AnyObject]()
                for item in list{
                    if let dic = item as? [NSObject: AnyObject]{
                        let data = ImageInfoData(dic: dic)
                        urlArr.append(data.url)
                    }
                }
                print("urlArr = \(urlArr)")
                dispatch_async(dispatch_get_main_queue(),{ () -> Void in
                    self.container?.addDataSourceByArray(urlArr)
                })
            }
        }
    }
    
    func onTapView(){
        print("onTapView = = = = = = = =")
    }
    
    func onTapMask(){
        print("on Tap mask = = = = = = = =")
        
        if (self.menuView != nil){
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options:UIViewAnimationOptions([.AllowUserInteraction, .BeginFromCurrentState]), animations: { () -> Void in
                self.menuView?.frame = CGRect(x: self.view.frame.size.width - 90, y: -120, width: 80, height: 100)
            }, completion: { (finished) -> Void in
                self.menuView?.removeFromSuperview()
                self.menuView = nil
            })
        }
        self.mask?.hidden = true
    }
}