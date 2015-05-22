//
//  AccountSafeTableViewController.swift
//  盛世财富
//  账户安全
//  Created by 云笺 on 15/5/18.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit

class AccountSafeTableViewController: UITableViewController,UITableViewDelegate {

    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var setPinPasswordLabel: UILabel!
    
    @IBOutlet weak var handCell: UITableViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        
        
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //NSLog("%@",indexPath.row)
        if indexPath.row == 1 {
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
        if pinpass == nil {
            setPinPasswordLabel.text = "请设置交易密码"
        } else {
            setPinPasswordLabel.text = "修改交易密码"
        }
        
        self.phoneLabel.text = userDefaults.objectForKey("phone") as? String
    }


}
