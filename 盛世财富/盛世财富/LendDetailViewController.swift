//
//  LendDetailViewController.swift
//  盛世财富
//
//  Created by xiao on 15-3-17.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//



import UIKit

class LendDetailViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var btmBar: UIToolbar!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.delegate = self
       
        
        // Do any additional setup after loading the view, typically from a nib.
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        
        switch indexPath.section.hashValue {
        case 0:
            cell = self.mainTable.dequeueReusableCellWithIdentifier("bidDetail") as UITableViewCell
            
        case 1:
            
            if indexPath.row == 0{
                cell = self.mainTable.dequeueReusableCellWithIdentifier("bidIntroduce") as UITableViewCell
            }else{
                cell = self.mainTable.dequeueReusableCellWithIdentifier("bidProtocol") as UITableViewCell
            }
        case 2:
            cell = self.mainTable.dequeueReusableCellWithIdentifier("userInfo") as UITableViewCell
        case 3:
            cell = self.mainTable.dequeueReusableCellWithIdentifier("creditProfile") as UITableViewCell
        default: cell = nil
        }
        return cell
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        var val = indexPath.section.hashValue
        var row = indexPath.row
        switch val{
        case 1:
            if row == 0 {
                return 230
            }else{
                return 30
            }
        default:
            return 130
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section.hashValue == 0 {
            return 1
        }else if section.hashValue == 1  {
            return 2
        }else if section.hashValue == 2{
            return 1
        }else if section.hashValue == 3{
            return 1
        }else {
            return 0
        
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
}

