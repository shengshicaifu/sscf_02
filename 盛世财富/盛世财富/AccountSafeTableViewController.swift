//
//  AccountSafeTableViewController.swift
//  盛世财富
//  账户安全
//  Created by 云笺 on 15/5/18.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit

class AccountSafeTableViewController: UITableViewController,UITableViewDelegate {

    @IBOutlet weak var setPinPasswordLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        
        var userDefaults = NSUserDefaults.standardUserDefaults()
        let pinpass = userDefaults.objectForKey("pinpass") as? NSString
        if pinpass == nil {
            setPinPasswordLabel.text = "请设置交易密码"
        }
        
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }


}
