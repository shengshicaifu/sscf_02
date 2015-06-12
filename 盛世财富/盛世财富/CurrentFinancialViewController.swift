//
//  CurrentFinancialViewController.swift
//  盛世财富
//
//  Created by 肖典 on 15/6/11.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit
class CurrentFinancialViewController:UITableViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var roundView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.roundView.layer.cornerRadius = 7
        let whiteView = UIView(frame: CGRect(x: (self.roundView.frame.width-7)/2, y: (self.roundView.frame.height-7)/2, width: 7, height: 7))
        whiteView.layer.cornerRadius = 3.5
        whiteView.backgroundColor = UIColor.whiteColor()
        self.roundView.addSubview(whiteView)
        self.roundView.layer.zPosition = 1.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 0.001
    }
}