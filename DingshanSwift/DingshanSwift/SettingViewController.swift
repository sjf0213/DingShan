//
//  SettingViewController.swift
//  DingshanSwift
//
//  Created by xiong qi on 15/12/9.
//  Copyright © 2015年 song jufeng. All rights reserved.
//

import UIKit

class SettingViewController: DSViewController {

    @IBOutlet weak var wifiswitch: UISwitch!
    
    @IBOutlet weak var notifyswitch: UISwitch!

    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var cacheLabel: UILabel!

    @IBOutlet weak var logoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.whiteColor()
    }

    @IBAction func wifiChangeValue(sender: AnyObject) {
    }


    @IBAction func notificationChangeValue(sender: AnyObject) {
    }
    
    
    @IBAction func gradeOnclick(sender: AnyObject) {
        let appid = 392901672
        let urlstr = "itms-apps://itunes.apple.com/app/id\(appid)"
        
        UIApplication.sharedApplication().openURL(NSURL(string:urlstr)!)
        
    }
    
    
    @IBAction func feedbackOnclick(sender: AnyObject) {
        
        let detail:FeedbackViewController = FeedbackViewController()
        self.navigationController?.pushViewController(detail, animated: true)
        
    }
    
    
    @IBAction func ourOnclick(sender: AnyObject) {
    }
    
    
    @IBAction func agreementOnclick(sender: AnyObject) {
    }
    
    
    @IBAction func clearOnclick(sender: AnyObject) {
    }
    
    @IBAction func LogoutOnclick(sender: AnyObject) {
        
        NSLog("LogoutOnclick");
        
    }
}
