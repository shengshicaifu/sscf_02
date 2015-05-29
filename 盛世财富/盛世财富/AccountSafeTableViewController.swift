//
//  AccountSafeTableViewController.swift
//  盛世财富
//  账户安全
//  Created by 云笺 on 15/5/18.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit

class AccountSafeTableViewController: UITableViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var setPinPasswordLabel: UILabel!
    
    @IBOutlet weak var VerifyRealNameLabel: UILabel!
    @IBOutlet weak var handCell: UITableViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        
        
        
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //NSLog("%@",indexPath.row)
        if indexPath.row == 0 {
            if VerifyRealNameLabel.text == "未实名认证" {
                self.performSegueWithIdentifier("verifyRealNameSegue", sender:nil)
            }
        }
        
        if indexPath.row == 2 {
            if setPinPasswordLabel.text == "请设置交易密码" {
                //self.prepareForSegue(<#segue: UIStoryboardSegue#>, sender: <#AnyObject?#>)
                //setPinPassSegue  modifyPinPassSegue
                self.performSegueWithIdentifier("setPinPassSegue", sender: nil)
            } else {
                self.performSegueWithIdentifier("modifyPinPassSegue", sender: nil)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var userDefaults = NSUserDefaults.standardUserDefaults()
        let pinpass = userDefaults.objectForKey("pinpass") as? NSString
        //NSLog("交易密码:%@", pinpass?)
        
        //交易密码
        if pinpass == nil {
            setPinPasswordLabel.text = "请设置交易密码"
        } else {
            setPinPasswordLabel.text = "修改交易密码"
        }
        
        //绑定手机
        var phone = userDefaults.objectForKey("phone") as? NSString
        if phone != nil {
            self.phoneLabel.text = Common.replaceStringToX(phone!, start: 3, end: 7)
        }
        
        //实名认证
        let isUpload = userDefaults.objectForKey("isUpload") as? NSString
        if isUpload == nil || isUpload == "" {
            VerifyRealNameLabel.text = "未实名认证"
        } else {
            let isVerify = userDefaults.objectForKey("isVerify") as? String
            if isVerify == "0" {
                VerifyRealNameLabel.text = "实名认证审核中"
            }else if isVerify == "1" {
                VerifyRealNameLabel.text = Common.replaceStringToX(isUpload!, start: 2, end: isUpload!.length)
            }
        }
    }


}
