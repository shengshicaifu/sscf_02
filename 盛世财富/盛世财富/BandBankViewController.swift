//
//  BandBankViewController.swift
//  盛世财富
//
//  Created by 云笺 on 15/5/25.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit
class BandBankViewController: UIViewController,UITableViewDelegate {
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var bankLabel: UILabel!
    @IBOutlet weak var bankButton: UIButton!
    @IBOutlet weak var top: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
     }
   
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var userDefaults = NSUserDefaults.standardUserDefaults()
        var bankCardNo = userDefaults.objectForKey("bankCardNo") as? String
        var bankName = userDefaults.objectForKey("bankName") as? String
        var username = userDefaults.objectForKey("username") as? String
        
        if bankCardNo == "" || bankCardNo == nil{
            firstView.hidden = true
            secondView.hidden = false
            hintLabel.hidden = true
            bankButton.setTitle("添加银行卡", forState: UIControlState.Normal)
            top.constant = 10
            firstView.layer.cornerRadius = 10
            secondView.layer.cornerRadius = 10
        }
        else{
            firstView.hidden = false
            secondView.hidden = false
            hintLabel.hidden = true
            bankNameLabel.text = bankName
            userNameLabel.text = Common.replaceStringToX(username!, start: 0, end: 2)
            bankLabel.text = Common.replaceStringToX(bankCardNo!, start: 3 , end: 5)
            bankButton.setTitle("修改", forState: UIControlState.Normal)
            self.title = "银行卡信息"
            top.constant = self.firstView.bounds.height+20
            firstView.layer.cornerRadius = 10
            secondView.layer.cornerRadius = 10
        }
           }
}
