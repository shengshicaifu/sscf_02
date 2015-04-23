//
//  TransRecordViewController.swift
//  盛世财富
//
//  Created by zengchang on 15-3-17.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit

//理财管理
class FinanceManagerViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
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
//    var arrString:[String] = ["aaaa","bbbb","cccc","dddd"]
    @IBOutlet weak var tableView: UITableView!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 1{
            return 2
        }
        else{
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = self.tableView.dequeueReusableCellWithIdentifier("transRecordCell") as UITableViewCell
        if indexPath.section == 0{
            if indexPath.row == 0{
            //取出控件
            var label1 = cell.viewWithTag(1) as UILabel
            var label2 = cell.viewWithTag(2) as UILabel
                label1.text = "账户净资产"
                label2.text = "0.00"
            label1 = UILabel(frame: CGRectMake(10, 10, self.tableView.bounds.width/2, 20))
            label2 = UILabel(frame: CGRectMake(self.tableView.bounds.width/3, 20, 30, 20))
                cell.addSubview(label1)
                cell.addSubview(label2)
                
            }
            
        }
        
        
//        //对控件进行赋值
//        for string in arrString {
//            label1.text = string
//            label2.text = string + "1111"
//        }
        
        return cell
    }

}