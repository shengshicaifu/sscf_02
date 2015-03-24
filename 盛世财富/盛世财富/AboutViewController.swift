//
//  AboutViewController.swift
//  盛世财富
//
//  Created by xiao on 15-3-24.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//



import UIKit

class AboutViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{

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
        return 4
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        
        switch indexPath.row {
        case 0:
            cell = self.mainTable.dequeueReusableCellWithIdentifier("version") as UITableViewCell
            
        case 1:
            cell = self.mainTable.dequeueReusableCellWithIdentifier("wechat") as UITableViewCell
            
        case 2:
            cell = self.mainTable.dequeueReusableCellWithIdentifier("weibo") as UITableViewCell
        case 3:
            cell = self.mainTable.dequeueReusableCellWithIdentifier("phone") as UITableViewCell
        default: cell = nil
        }
        return cell
    }

}

