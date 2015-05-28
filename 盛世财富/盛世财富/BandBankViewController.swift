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
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var bankLabel: UILabel!
    @IBOutlet weak var bankButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        var userDefaults = NSUserDefaults.standardUserDefaults()
        let bankCardNo = userDefaults.objectForKey("bankCardNo") as? String
        let bankName = userDefaults.objectForKey("bankName") as? String
        let username = userDefaults.objectForKey("username") as? String
        if bankCardNo == "" || bankCardNo == nil{
            bankNameLabel.hidden = true
            userNameLabel.hidden = true
            bankLabel.text = "你尚未添加任何银行卡"
            bankButton.setTitle("添加", forState: UIControlState.Normal)
        }
        else{
            bankNameLabel.text = bankName
            bankNameLabel.textColor = UIColor.blueColor()
            userNameLabel.text = username
            userNameLabel.textColor = UIColor.redColor()
            
            bankLabel.text = Common.replaceStringToX(bankCardNo!, start: 0, end: 8)
            bankLabel.textColor = UIColor.blueColor()
            bankButton.setTitle("修改", forState: UIControlState.Normal)
        }
    }
     }
   
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        var userDefaults = NSUserDefaults.standardUserDefaults()
//        let bankCardNo = userDefaults.objectForKey("bankCardNo") as? String
//        let bankName = userDefaults.objectForKey("bankName") as? String
//        let username = userDefaults.objectForKey("username") as? String
//        if bankCardNo == "" || bankCardNo == nil{
//            bankNameLabel.hidden = true
//            userNameLabel.hidden = true
//            bankLabel.text = "你尚未添加任何银行卡"
//            bankButton.setTitle("添加", forState: UIControlState.Normal)
//        }
//        else{
//            bankNameLabel.text = bankName
//            bankNameLabel.textColor = UIColor.blueColor()
//            userNameLabel.text = username
//            userNameLabel.textColor = UIColor.redColor()
//            
//            bankLabel.text = Common.replaceStringToX(bankCardNo!, start: 0, end: 8)
//            bankLabel.textColor = UIColor.blueColor()
//            bankButton.setTitle("修改", forState: UIControlState.Normal)
//        }
//    }
//}
