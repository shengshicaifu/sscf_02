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
            AlertView.showMsg("注销成功", parentView: self.view)
            self.performSegueWithIdentifier("accountToMain", sender: nil)
            
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
