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
    @IBOutlet weak var usermoney: UILabel!
    @IBOutlet weak var bidName: UILabel!
    @IBOutlet weak var bidRate: UILabel!
    
    @IBOutlet weak var typeName: UILabel!
    var id:String?
    var bidTitle:String?
    var percent:String?
    var type:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bidMoney.delegate = self
        reward.delegate = self
        experience.delegate = self
        payPassword.delegate = self
        payBtn.layer.cornerRadius = 5
        if let usermoney:String = NSUserDefaults.standardUserDefaults().objectForKey("usermoney") as? String {
            self.usermoney.text = usermoney
        }
        if let rate:String = percent{
            self.bidRate.text = "\(rate)"
        }
        if let title:String = bidTitle {
            self.bidName.text = title
        }
        if let type = self.type {
            if type != "8"{
                typeName.text = "认购份数："
            }
        }
    }
    @IBAction func confirm(sender: AnyObject) {
        bidMoney.resignFirstResponder()
        reward.resignFirstResponder()
        experience.resignFirstResponder()
        payPassword.resignFirstResponder()
        loading.startLoading(self.view)
        let afnet = AFHTTPRequestOperationManager()
        let param = ["borrow_id":id,"invest_money":bidMoney.text,"pin":payPassword.text,"is_confirm":"0","reward_use":reward.text,"use_experince":experience.text,"to":NSUserDefaults.standardUserDefaults().objectForKey("token") as! String]
        let url = "http://www.sscf88.com/App-Invest-investmoney"
//        println(param)
        afnet.POST(url, parameters: param, success: { (opration :AFHTTPRequestOperation!, res :AnyObject!) -> Void in
            //            println(res["message"])
            AlertView.showMsg(res["message"] as! String, parentView: self.view)
            println(res)
            }) { (opration:AFHTTPRequestOperation!, error:NSError!) -> Void in
                AlertView.showMsg("系统错误，请联系客服！"
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

