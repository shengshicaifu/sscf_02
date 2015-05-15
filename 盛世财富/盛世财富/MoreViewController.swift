//
//  MoreViewController.swift
//  盛世财富
//
//  Created by xiao on 15-3-24.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//



import UIKit

class MoreViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var mainTable: UITableView!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        mainTable.delegate = self
        self.mainTable.rowHeight = 44.0
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 54/255.0, green: 169/255.0, blue: 245/255.0, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        
        switch indexPath.row {
        case 0:
            cell = self.mainTable.dequeueReusableCellWithIdentifier("forum") as! UITableViewCell
            
        case 1:
            cell = self.mainTable.dequeueReusableCellWithIdentifier("update") as! UITableViewCell
            
        case 2:
            cell = self.mainTable.dequeueReusableCellWithIdentifier("feedback") as! UITableViewCell
        case 3:
            cell = self.mainTable.dequeueReusableCellWithIdentifier("about") as! UITableViewCell
        default: cell = nil
        }
        return cell
    }

}

