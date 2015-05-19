//
//  AccountInfoTableViewController.swift
//  盛世财富
//  账户信息
//  Created by 云笺 on 15/5/15.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit

class AccountInfoTableViewController: UITableViewController,UITableViewDataSource,UITableViewDelegate {

    
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var PhoneLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var userDefaults = NSUserDefaults.standardUserDefaults()
        if let phone = userDefaults.objectForKey("username") as? String {
            PhoneLabel.text = phone
        }
        if let gender = userDefaults.objectForKey("gender") as? String {
            genderLabel.text = gender
        }
        
        if let birth = userDefaults.objectForKey("birthday") as? String {
            var formatter = NSDateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            var birthDate = formatter.dateFromString(birth)
            formatter.dateFormat = "yyyy年MM月dd日"
            //birthdayLabel.text = formatter.stringFromDate(birthDate!)
        }
        
    }

    //退出登录
    @IBAction func loginOutAction(sender: UIButton) {
        //提示是否退出
        var alertController = UIAlertController(title: "提示", message: "退出后将无法投资，是否确定退出", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
            //删除用户信息
            var userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.removeObjectForKey("username")
            userDefaults.removeObjectForKey("token")
            userDefaults.removeObjectForKey("userpic")
            userDefaults.removeObjectForKey("usermoney")
            userDefaults.removeObjectForKey("gender")
            userDefaults.removeObjectForKey("birthday")
            AlertView.showMsg("注销成功", parentView: self.view)
            self.presentViewController(self.storyboard?.instantiateViewControllerWithIdentifier("tabBarViewController") as! TabBarViewController, animated: true, completion: nil)
            
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
