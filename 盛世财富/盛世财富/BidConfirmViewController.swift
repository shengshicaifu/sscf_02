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
    @IBOutlet weak var payBtn: UIButton!
    
    var id:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bidMoney.delegate = self
        reward.delegate = self
        experience.delegate = self
        payPassword.delegate = self
        payBtn.layer.cornerRadius = 5
        if let id = id {
//            println(id)
        }
    }
    @IBAction func confirm(sender: AnyObject) {
        loading.startLoading(self.view)
        let afnet = AFHTTPRequestOperationManager()
        let param = ["borrow_id":id,"invest_money":bidMoney.text,"pin":payPassword.text,"is_confirm":"0","reward_use":reward.text,"use_experince":experience.text,"to":NSUserDefaults.standardUserDefaults().objectForKey("token") as! String]
        let url = "http://www.sscf88.com/App-Invest-investmoney"
        println(param)
        afnet.POST(url, parameters: param, success: { (opration :AFHTTPRequestOperation!, res :AnyObject!) -> Void in
            //            println(res["message"])
            AlertView.showMsg(res["message"] as! String, parentView: self.view)
            println(res)
            }) { (opration:AFHTTPRequestOperation!, error:NSError!) -> Void in
                AlertView.showMsg(error.localizedDescription+"，请退出后重试或联系客服！"
                    , parentView: self.view)
        }
        loading.stopLoading()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
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
    
    override func viewWillAppear(animated: Bool) {
        DaiDodgeKeyboard.addRegisterTheViewNeedDodgeKeyboard(self.view)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        DaiDodgeKeyboard.removeRegisterTheViewNeedDodgeKeyboard()
        super.viewWillDisappear(animated)
    }
}

