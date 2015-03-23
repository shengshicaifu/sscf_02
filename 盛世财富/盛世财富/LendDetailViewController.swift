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
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.delegate = self
        
        
        
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
        case 2:
            if self.view.viewWithTag(1) != nil && self.view.viewWithTag(1)?.hidden == true {
                return 450
            }else {
                return 130
            }
        case 3:
            if self.view.viewWithTag(2) != nil && self.view.viewWithTag(2)?.hidden == true {
                return 350
            }else {
                return 130
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

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section.hashValue == 2 {
            
            if self.view.viewWithTag(1)?.hidden == false {
                self.view.viewWithTag(1)?.hidden = true
                self.view.viewWithTag(10)?.hidden = false
              
            }else{
                self.view.viewWithTag(1)?.hidden = false
                self.view.viewWithTag(10)?.hidden = true
            }
        }
        if indexPath.section.hashValue == 3{
            
            if self.view.viewWithTag(2)?.hidden == false {
                self.view.viewWithTag(2)?.hidden = true
                self.view.viewWithTag(11)?.hidden = false
                
            }else{
                self.view.viewWithTag(2)?.hidden = false
                self.view.viewWithTag(11)?.hidden = true
            }
        }
        mainTable.reloadData()
    }
    
}

