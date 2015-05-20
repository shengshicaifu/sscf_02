//
//  BidConfirmViewController.swift
//  盛世财富
//  投标
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
    @IBOutlet weak var unit: UILabel!
    
    
    @IBOutlet weak var typeName: UILabel!
    var id:String?
    var bidTitle:String?
    var percent:String?
    var type:String?
    var per_transferData:String?
    var duration:String?
    
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
                unit.text = "份"
                bidMoney.placeholder = "每份\(self.per_transferData!)元"
//               println(duration)
            }
        }
    }
    @IBAction func confirm(sender: AnyObject) {
        bidMoney.resignFirstResponder()
        reward.resignFirstResponder()
        experience.resignFirstResponder()
        payPassword.resignFirstResponder()
        
        if Common.isLogin() == false {
            AlertView.alert("提示", message: "请登录后再使用", buttonTitle: "确定", viewController: self)
            return
        }
        
        if bidMoney.text.isEmpty {
            AlertView.alert("提示", message: "请填写投标金额", buttonTitle: "确定", viewController: self)
            return
        }
        if payPassword.text.isEmpty {
            AlertView.alert("提示", message: "请输入支付密码", buttonTitle: "确定", viewController: self)
            return
        }
        loading.startLoading(self.view)
        let afnet = AFHTTPRequestOperationManager()
        var param = NSMutableDictionary()
        var url = String()
        if let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String{
            if let type = self.type {
                if type == "8"{
                    param = ["borrow_id":id!,"invest_money":bidMoney.text,"pin":payPassword.text,"is_confirm":"0","reward_use":reward.text,"use_experince":experience.text,"to":token]
                    url = Constant.getServerHost() + "/App-Invest-investmoney"
                }else{
                    url = Constant.getServerHost() + "/App-Invest-newtinvestmoney"
                    param = ["borrow_id":id!,"duration":duration!,"transfer_invest_num":bidMoney.text,"pin":payPassword.text,"is_confirm":"0","reward_use":reward.text,"use_experince":experience.text,"to":NSUserDefaults.standardUserDefaults().objectForKey("token") as! String]
                }
            }
        }else{
            AlertView.alert("提示", message: "请登录后操作", buttonTitle: "确定", viewController: self)
            return
        }
        
//        println(param)
        afnet.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
        afnet.POST(url, parameters: param, success: { (opration :AFHTTPRequestOperation!, res :AnyObject!) -> Void in
                        println(res)
            AlertView.showMsg(res["message"] as! String, parentView: self.view)
//            println(res["message"])
            }) { (opration:AFHTTPRequestOperation!, error:NSError!) -> Void in
                println(error.localizedDescription)
                AlertView.alert("错误", message: "服务器错误", buttonTitle: "确定", viewController: self)
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

