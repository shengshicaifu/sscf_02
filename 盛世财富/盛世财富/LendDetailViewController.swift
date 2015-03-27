//
//  LendDetailViewController.swift
//  盛世财富
//
//  Created by xiao on 15-3-17.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//



import UIKit

class LendDetailViewController: UITableViewController ,UITableViewDelegate{

    @IBOutlet weak var mainTable: UITableView!
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.delegate = self
        
        
        
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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

