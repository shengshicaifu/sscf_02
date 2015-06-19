//
//  testMainViewController.swift
//  盛世财富
//
//  Created by 肖典 on 15/6/19.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit
class testMainViewController:UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tabelView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabelView.dataSource = self
        self.tabelView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("choose") as! UITableViewCell
        return cell
    }
}