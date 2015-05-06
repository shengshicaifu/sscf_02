//
//  NewPersonCenterViewController.swift
//  盛世财富
//
//  Created by 肖典 on 15/5/6.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit
class NewPersonCenterViewController:UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var mainTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.dataSource = self
        mainTable.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section.hashValue == 0{
            return 2
        }
        if section.hashValue == 1{
            return 1
        }
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell =  UITableViewCell()
        var sec = indexPath.section.hashValue
        var row = indexPath.row
        if sec == 0{
            if row == 0{
                cell = self.mainTable.dequeueReusableCellWithIdentifier("finance") as UITableViewCell
            }
            if row == 1{
                cell = self.mainTable.dequeueReusableCellWithIdentifier("record") as UITableViewCell
            }
        }
        if sec == 1{
            cell = self.mainTable.dequeueReusableCellWithIdentifier("secure") as UITableViewCell
        }
        return cell
    }
    //section数量
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
        
    }
    //section的header高度
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }
        if section == 1{
            return 10
        }
        return 10
    }
    
}