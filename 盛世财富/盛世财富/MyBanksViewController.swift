//
//  TransRecordViewController.swift
//  盛世财富
//
//  Created by zengchang on 15-3-17.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit

//我的银行卡
class MyBanksViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func returnTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var arrString:[String] = ["aaaa","bbbb","cccc","dddd"]
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrString.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = self.tableView.dequeueReusableCellWithIdentifier("transRecordCell") as UITableViewCell
        
        //取出控件
        var label1 = cell.viewWithTag(1) as UILabel
        var label2 = cell.viewWithTag(2) as UILabel
        
        //对控件进行赋值
        for string in arrString {
            label1.text = string
            label2.text = string + "1111"
        }
        
        return cell
    }

}