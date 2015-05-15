//
//  AccountInfoTableViewController.swift
//  盛世财富
//  账户信息
//  Created by 云笺 on 15/5/15.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit

class AccountInfoTableViewController: UITableViewController,UITableViewDataSource,UITableViewDelegate {

    
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var PhoneLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //退出登录
    @IBAction func loginOutAction(sender: UIButton) {
    }

}
