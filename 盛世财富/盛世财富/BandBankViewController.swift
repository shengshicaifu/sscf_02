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
//            bankNameLabel.hidden = true
//            userNameLabel.hidden = true
//            bankLabel.text = "你尚未添加任何银行卡"
//            bankButton.setTitle("添加", forState: UIControlState.Normal)
//            self.title = "银行卡信息"
            firstView.hidden = true
            secondView.hidden = false
            hintLabel.hidden = true
            bankButton.setTitle("添加银行卡", forState: UIControlState.Normal)
            top.constant = 100
            firstView.layer.cornerRadius = 10
            secondView.layer.cornerRadius = 10
            
        }
        else{
            bankNameLabel.text = bankName
//            bankNameLabel.textColor = UIColor.blueColor()
            userNameLabel.text = Common.replaceStringToX(username!, start: 0, end: 2)
//            userNameLabel.textColor = UIColor.redColor()
            
            bankLabel.text = Common.replaceStringToX(bankCardNo!, start: 0, end: 0)
//            bankLabel.textColor = UIColor.blueColor()
            bankButton.setTitle("修改", forState: UIControlState.Normal)
            self.title = "银行卡信息"
            firstView.layer.cornerRadius = 10
            secondView.layer.cornerRadius = 10
        }
    }
}
