//
//  HandPasswordViewController.swift
//  盛世财富
//
//  Created by 肖典 on 15/5/22.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit
class HandPasswordViewController:UITableViewController ,UITableViewDataSource,UITableViewDelegate{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var ad = UIApplication.sharedApplication().delegate as! AppDelegate
        if let pwd = LLLockPassword.loadLockPassword() {
            if indexPath.row == 0 {
                ad.showLLLockViewController(LLLockViewTypeModify)
            }
            if indexPath.row == 1 {
                ad.showLLLockViewController(LLLockViewTypeClean)
            }
        }else{
            ad.showLLLockViewController(LLLockViewTypeCreate)
        }
    }
}