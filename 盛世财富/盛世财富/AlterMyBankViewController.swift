//
//  AlterMyBankViewController.swift
//  盛世财富
//
//  Created by hhh on 15-4-22.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit
class AlterMyBankViewController :
UIViewController{
    
    @IBOutlet weak var bankName: UITextField!
    
    @IBOutlet weak var bankNo: UITextField!
    
    @IBOutlet weak var confirmBankNo: UITextField!
    
    @IBOutlet weak var bankPrince: UITextField!
    
    @IBOutlet weak var bankShi: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func returnTapped(sender: AnyObject) {
         self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func ToTapped(sender: AnyObject) {
        
            var alert = UIAlertController(title: "提示", message: "你填写的资料有误。请重新输入", preferredStyle:UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
             super.didReceiveMemoryWarning()
    }

}
