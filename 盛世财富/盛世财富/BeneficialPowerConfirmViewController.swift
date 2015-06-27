//
//  BeneficialPowerConfirmViewController.swift
//  盛世财富
//
//  Created by 莫文琼 on 15/6/26.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit
/**
*  受益权购买
*/
class BeneficialPowerConfirmViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var b1: UIButton!
    
    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var l2: UILabel!
    @IBOutlet weak var l3: UILabel!
    @IBOutlet weak var l4: UILabel!
    @IBOutlet weak var l5: UILabel!
    @IBOutlet weak var l6: UILabel!
    @IBOutlet weak var l7: UILabel!
    @IBOutlet weak var l8: UILabel!
    @IBOutlet weak var l9: UILabel!
    @IBOutlet weak var l10: UILabel!
    @IBOutlet weak var l11: UILabel!
    @IBOutlet weak var l12: UILabel!
    @IBOutlet weak var l13: UILabel!
    @IBOutlet weak var l14: UILabel!
    @IBOutlet weak var l15: UILabel!
    @IBOutlet weak var l16: UILabel!
    
    
    
    
    @IBOutlet weak var t1: UITextField!
    @IBOutlet weak var t2: UITextField!
    @IBOutlet weak var t3: UITextField!
    
    @IBOutlet weak var v1: UIView!
    
    @IBOutlet weak var s1: UIScrollView!
    
    var id = ""
    var account_money:String?//可用金额
    var reward_money:String?//奖金
    var borrow_name:String?
    var borrow_interest_rate:String?
    var lowest_transfer:String?//最少认购分数
    var per_transfer:String?//每份价格
    var surplus_money:String?//剩余金额
    var borrow_duration:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        t1.delegate = self
        t2.delegate = self
        t3.delegate = self
        
        Common.customerButton(b1)
        Common.addBorder(l1)
        Common.addBorder(l2)
        Common.addBorder(l3)
        Common.addBorder(l4)
        Common.addBorder(l5)
        Common.addBorder(l6)
        Common.addBorder(l7)
        Common.addBorder(l8)
        Common.addBorder(l9)
        Common.addBorder(l10)
        Common.addBorder(l11)
        Common.addBorder(l12)
        Common.addBorder(l13)
        Common.addBorder(l14)
        Common.addBorder(l15)
        Common.addBorder(l16)
        Common.addBorder(t1)
        Common.addBorder(t2)
        Common.addBorder(t3)
        
        
        self.s1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "resignAll"))
        
        //获取标的详情
        //检查手机网络
        var reach = Reachability(hostName: Common.domain)
        reach.unreachableBlock = {(r:Reachability!) -> Void in
            //NSLog("网络不可用")
            dispatch_async(dispatch_get_main_queue(), {
                
                AlertView.alert("提示", message: "网络连接有问题，请检查网络是否连接", buttonTitle: "确定", viewController: self)
            })
        }
        
        reach.reachableBlock = {(r:Reachability!) -> Void in
            //NSLog("网络可用")
            dispatch_async(dispatch_get_main_queue(), {
                
                if Common.isLogin() {
                    loading.startLoading(self.view)
                    let afnet = AFHTTPRequestOperationManager()
                    var param = ["id":self.id,"to":NSUserDefaults.standardUserDefaults().objectForKey("token") as! String]
                    var url = Common.serverHost + "/App-Beneficial-shownewinvest"
                    
                    NSLog("受益权url = %@", url)
                    NSLog("受益权param = %@", param)
                    afnet.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                    afnet.POST(url, parameters: param, success: { (opration :AFHTTPRequestOperation!, res :AnyObject!) -> Void in
                        loading.stopLoading()
                        
                        var result = res as! NSDictionary
                        var code = result["code"] as! Int
                        
                        NSLog("受益权 = %@", result)
                        var user = result["data"]?["user"]  as! NSDictionary
                         self.account_money = user["account_money"] as? String
                         self.reward_money = user["reward_money"] as? String
                        
                        var vo = result["data"]?["vo"]  as! NSDictionary
                         self.borrow_name = vo["borrow_name"] as? String
                         self.borrow_interest_rate = vo["borrow_interest_rate"] as? String
                         self.lowest_transfer = vo["lowest_transfer"] as? String//最少认购分数
                         self.per_transfer = vo["per_transfer"] as? String//每份价格
                         self.surplus_money = vo["surplus_money"] as? String//剩余金额
                         self.borrow_duration = vo["borrow_duration"] as? String
                        
                        self.l2.text = self.account_money
                        self.l4.text = self.borrow_name
                        self.l6.text = self.borrow_interest_rate! + "%"
                        self.l8.text = self.surplus_money
                        self.l15.text = self.per_transfer
                        
                        self.t1.placeholder = "最少认购\(self.lowest_transfer!)份"
                        if self.reward_money == nil || self.reward_money == ""{
                            self.t2.placeholder = "可用奖金0元"
                        }else{
                            self.t2.placeholder = "可用奖金\(self.reward_money!)元"
                        }
                        
                        
                        
                        
                        }) { (opration:AFHTTPRequestOperation!, error:NSError!) -> Void in
                            loading.stopLoading()
                            AlertView.alert("错误", message: "服务器错误", buttonTitle: "确定", viewController: self)
                    }

                }
                
            })
        }
        
        reach.startNotifier()
        

    }

    @IBAction func confirm(sender: UIButton) {
        self.confirmAction()
    }
    
    func confirmAction() {
        resignAll()
        if Common.isLogin() == false {
            AlertView.alert("提示", message: "请先登录", okButtonTitle: "确定", cancelButtonTitle: "取消", viewController: self, okCallback: { (action:UIAlertAction!) -> Void in
                var loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("loginViewController") as! LoginViewController
                self.presentViewController(loginViewController, animated: true, completion: nil)
                }, cancelCallback: { (action:UIAlertAction!) -> Void in
                    
            })
            return
        }
        
        let user = NSUserDefaults.standardUserDefaults()
        var pinpas = user.objectForKey("pinpass") as? String
        if ( pinpas == nil) || (pinpas!.isEmpty) {
            AlertView.alert("提示", message: "请先设置支付密码", okButtonTitle: "确定", cancelButtonTitle: "取消", viewController: self, okCallback: { (action:UIAlertAction!) -> Void in
                var view = self.storyboard?.instantiateViewControllerWithIdentifier("setPinPasswordViewController") as! SetPinPasswordViewController
                self.presentViewController(view, animated: true, completion: nil)
                }, cancelCallback: { (action:UIAlertAction!) -> Void in
                    
            })
            return
        }
        
        if t1.text.isEmpty {
            AlertView.showMsg("认购份数不能为空", parentView: self.view)
            return
        }
        
        if !Common.isNumber(t1.text) {
            AlertView.showMsg("认购份数为正数", parentView: self.view)
            return
        }
        
        if t2.text.isEmpty == false && !Common.isMoney(t2.text) {
            AlertView.showMsg("奖金为最多两位小数的数字", parentView: self.view)
            return
        }
        
        if t3.text.isEmpty {
            AlertView.showMsg("支付密码不能为空", parentView: self.view)
            return
        }
        
        if !Common.isPassword(t3.text) {
            AlertView.showMsg("支付密码为英文字母和数字，长度在6到20之间", parentView: self.view)
            return
        }
        
        
        
        //检查手机网络
        var reach = Reachability(hostName: Common.domain)
        reach.unreachableBlock = {(r:Reachability!) -> Void in
            //NSLog("网络不可用")
            dispatch_async(dispatch_get_main_queue(), {
                
                AlertView.alert("提示", message: "网络连接有问题，请检查网络是否连接", buttonTitle: "确定", viewController: self)
            })
        }
        
        reach.reachableBlock = {(r:Reachability!) -> Void in
            //NSLog("网络可用")
            dispatch_async(dispatch_get_main_queue(), {
                loading.startLoading(self.view)
                let afnet = AFHTTPRequestOperationManager()
                var param = [
                    "to":NSUserDefaults.standardUserDefaults().objectForKey("token") as! String,
                        "duration":"1",
                        "beneficialpower_id":self.id,
                        "is_confirm":"1",
                        "pin":self.t3.text,
                        "reward_use":self.t2.text,
                        "transfer_invest_num":self.t1.text
                
                ]
                var url = Common.serverHost + "/App-Beneficial-newtinvestmoney"
                
                afnet.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                afnet.POST(url, parameters: param, success: { (opration :AFHTTPRequestOperation!, res :AnyObject!) -> Void in
                    loading.stopLoading()
                    
                    var result = res as! NSDictionary
                    var code = result["code"] as! Int
                    if code == -1 {
                        AlertView.alert("提示", message: "请先登录", okButtonTitle: "确定", cancelButtonTitle: "取消", viewController: self, okCallback: { (action:UIAlertAction!) -> Void in
                            var loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                            self.presentViewController(loginViewController, animated: true, completion: nil)
                            }, cancelCallback: { (action:UIAlertAction!) -> Void in
                                
                        })
                        
                    }else if code == 0 {
                        AlertView.alert("提示", message: res["message"] as! String, buttonTitle: "确定", viewController: self)
                    }else if code == 150 {
                        AlertView.alert("提示", message: "账户余额不足，请充值", okButtonTitle: "确定", cancelButtonTitle: "取消", viewController: self, okCallback: { (action:UIAlertAction!) -> Void in
                            var controller = self.storyboard?.instantiateViewControllerWithIdentifier("OffLineChargeViewController") as! OffLineChargeViewController
                            self.navigationController?.pushViewController(controller, animated: true)
                            }, cancelCallback: nil)
                    }else if code == 200 {
                        
                        AlertView.alert("提示", message: "恭喜您投标成功", buttonTitle: "确定", viewController: self, callback: { (action:UIAlertAction!) -> Void in
                            self.navigationController?.popViewControllerAnimated(true)
                        })
                    }
                    
                    
                    }) { (opration:AFHTTPRequestOperation!, error:NSError!) -> Void in
                        loading.stopLoading()
                        AlertView.alert("错误", message: "服务器错误", buttonTitle: "确定", viewController: self)
                }
            })
        }
        
        reach.startNotifier()
        
        
        
        
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        resignAll()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == t1 {
            t2.becomeFirstResponder()
        }else if textField == t2 {
            t3.becomeFirstResponder()
        }else if textField == t3 {
            confirmAction()
        }
        return true
    }
    
    func resignAll(){
        t1.resignFirstResponder()
        t2.resignFirstResponder()
        t3.resignFirstResponder()
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
