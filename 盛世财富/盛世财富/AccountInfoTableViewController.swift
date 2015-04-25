//
//  AccountInfoTableViewController.swift
//  盛世财富
//  账户信息
//  Created by 莫文琼 on 15-4-24.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit

class AccountInfoTableViewController: UITableViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var photoImageView: UIImageView!

    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var birthlabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self

        accountLabel.text = "15588888888"
        sexLabel.text = "女"
        birthlabel.text = "1989年12月12日"
    }

}
