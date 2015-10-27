//
//  ProfileUserInfoEditController.swift
//  DingshanSwift
//
//  Created by song jufeng on 15/9/23.
//  Copyright © 2015年 song jufeng. All rights reserved.
//

import Foundation
class ProfileUserInfoEditController : DSViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    var ossDelegate:AnyObject?
    
    private var userHeadView = UIButton()

    override func loadView(){
        super.loadView()
        self.view.backgroundColor = UIColor(red: 0.9, green: 0.8, blue: 0.9, alpha: 1.0)
        
        userHeadView.frame = CGRect(x: (self.view.bounds.size.width - 73)*0.5, y: TopBar_H+50, width: 73, height: 73)
        userHeadView.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.2)
        userHeadView.setImage(UIImage(named:"user_head_default"), forState: UIControlState.Normal)
        userHeadView.layer.cornerRadius = userHeadView.bounds.width * 0.5
        userHeadView.addTarget(self, action: Selector("onTapUploadHead:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(userHeadView)
    }
    
    func onTapUploadHead(sender:UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true) { () -> Void in
            // todo
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let data = UIImageJPEGRepresentation(image!, 1.0);
        let DocumentsPath = NSHomeDirectory().stringByAppendingString("/Documents")
        //文件管理器
        let fileManager = NSFileManager.defaultManager()
        let imageUrlstr = DocumentsPath.stringByAppendingString("/user_head_upload.jpg")
        let imageUrl = NSURL(string: imageUrlstr)
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为user_head_upload.jpg
        do{
            try fileManager.createDirectoryAtPath(DocumentsPath, withIntermediateDirectories: true, attributes: nil)
            fileManager.createFileAtPath(imageUrlstr, contents: data, attributes: nil)
        }catch{
            print(error)
        }
        if imageUrl != nil{
            if let delegate = self.ossDelegate as? DSOSSDelegate{
                delegate.uploadAliyunOSSImage(imageUrl!, withKey:"userupload/user_head_1234567.jpg")
            }
        }
        picker.dismissViewControllerAnimated(true) { () -> Void in }
    }
}