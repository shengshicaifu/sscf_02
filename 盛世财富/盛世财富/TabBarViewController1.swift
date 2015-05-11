//
//  TabBarViewController1.swift
//  盛世财富
//
//  Created by hhh on 15-5-9.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit
class TabBarViewController1:UITableViewController,UITableViewDelegate,UITableViewDataSource{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section.hashValue == 0{
            return 3
        }
        else{
            return 4
        }

    }
   
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = self.tableView.dequeueReusableCellWithIdentifier("tabBarViewCell") as UITableViewCell
        
        return cell
        
    }
    
    
    
}
