//
//  ChargeViewController.swift
//  盛世财富
//
//  Created by hhh on 15-4-23.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit
class ChargeViewController:UIViewController,UITableViewDelegate{
    
    @IBOutlet weak var mainView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.delegate = self
    }
    @IBAction func returnTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
}
