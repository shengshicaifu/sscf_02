//
//  BidConfirmViewController.swift
//  盛世财富
//
//  Created by xiao on 15-4-23.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation

import UIKit

class BidConfirmViewController: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var bidMoney: UITextField!
    @IBOutlet weak var reward: UITextField!
    @IBOutlet weak var experience: UITextField!
    @IBOutlet weak var payPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bidMoney.delegate = self
        reward.delegate = self
        experience.delegate = self
        payPassword.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
        bidMoney.resignFirstResponder()
        reward.resignFirstResponder()
        experience.resignFirstResponder()
        payPassword.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        bidMoney.resignFirstResponder()
        reward.resignFirstResponder()
        experience.resignFirstResponder()
        payPassword.resignFirstResponder()
        return true
    }
}

