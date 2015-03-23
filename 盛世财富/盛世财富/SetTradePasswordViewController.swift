//
//  TransRecordViewController.swift
//  盛世财富
//
//  Created by zengchang on 15-3-17.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit

class SetTradePasswordViewController: UIViewController,UITextFieldDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        firstPasswordLabel.delegate = self
        secondPasswordLabel.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //设置交易密码
    @IBOutlet weak var firstPasswordLabel: UITextField!
    @IBOutlet weak var secondPasswordLabel: UITextField!
    @IBAction func setPwdSureTapped(sender: AnyObject) {
        //设置密码确定按钮点击事件
        println("set")
    }
    
    //隐藏键盘
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        firstPasswordLabel.resignFirstResponder()
        secondPasswordLabel.resignFirstResponder()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        firstPasswordLabel.resignFirstResponder()
        secondPasswordLabel.resignFirstResponder()
        return true
    }
}