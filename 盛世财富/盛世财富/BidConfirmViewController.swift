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
    @IBOutlet weak var restMoney: UILabel!
    
    @IBOutlet weak var unit: UILabel!
    
    
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var typeName: UILabel!
    var id:String?
    var type:String?
    var duration:String = String()
    override func viewDidAppear(animated: Bool) {
         UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let url = Common.serverHost+"/app-invest-detailcontent-id-"+self.id!
        let afnet = AFHTTPRequestOperationManager()
        //检查手机网络
        var reach = Reachability(hostName: Common.domain)
        reach.unreachableBlock = {(r:Reachability!) -> Void in
            //NSLog("网络不可用")
            dispatch_async(dispatch_get_main_queue(), {
                
                AlertView.alert("提示", message: "网络连接有问题，请检查手机网络", buttonTitle: "确定", viewController: self)
            })
        }
        
        reach.reachableBlock = {(r:Reachability!) -> Void in
            //NSLog("网络可用")
            dispatch_async(dispatch_get_main_queue(), {
                
                afnet.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                afnet.GET(url, parameters: nil, success: { (operation:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                     UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    let d = data.objectForKey("data") as! NSDictionary
                    println(d)
                    if let borrowInfo = d.objectForKey("borrowinfo") as? NSDictionary {
                        self.usermoney.text = NSUserDefaults.standardUserDefaults().objectForKey("accountMoney") as? String
                        if let borrow_type = borrowInfo.objectForKey("borrow_type") as? String{
                            self.type = borrow_type
                            if let borrow_duration = borrowInfo.objectForKey("borrow_duration") as? String{
                                self.duration = borrow_duration
                            }

                            if let borrow_name = borrowInfo.objectForKey("borrow_name") as? String{
                                self.bidName.text = borrow_name
                            }
                            if let borrow_interest_rate = borrowInfo.objectForKey("borrow_interest_rate") as? String{
                                self.bidRate.text = borrow_interest_rate + "%"
                            }
                            if let need = borrowInfo.objectForKey("need") as? NSInteger{
                                self.restMoney.text = "\(need)元"
                            }
                            if borrow_type != "8" {
                                self.typeName.text = "认购份数："
                                self.unit.text = "份"
//                                self.moneyLabel.text = "可认购："
//                                if let transfer_can = borrowInfo.objectForKey("transfer_can") as? String{
//                                    self.restMoney.text = transfer_can+"份"
//                                }
                                if let per_transferData = borrowInfo.objectForKey("per_transferData") as? String{
                                    self.bidMoney.placeholder = "每份\(per_transferData)元"
                                }
                            }else{
                                
                                if let borrow_min = borrowInfo.objectForKey("borrow_min") as? String{
                                    self.bidMoney.placeholder = "起投金额\(borrow_min)"
                                }
                            }
                           
                        }
                    }
                    
                    }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                         UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        println(error)
                })
            })
        }
        reach.startNotifier()
        // [borrowinfo][ transfer_can]
        //起投金额: String [borrowinfo][borrow_min]
        //
        //        if let usermoney:String = NSUserDefaults.standardUserDefaults().objectForKey("accountMoney") as? String {
        //            self.usermoney.text = "\(usermoney)元"
        //        }
        //        if let rate:String = percent{
        //            self.bidRate.text = "\(rate)"
        //        }
        //        if let title:String = bidTitle {
        //            self.bidName.text = title
        //        }
        //        if let type = self.type {
        //            if type != "8"{
        //                typeName.text = "认购份数："
        //                unit.text = "份"
        //                bidMoney.placeholder = "每份\(self.per_transferData!)元"
        //                //               println(duration)
        //            }
        //        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bidMoney.delegate = self
        reward.delegate = self
        experience.delegate = self
        payPassword.delegate = self
        payBtn.layer.cornerRadius = 5
    
        
        
    }
    @IBAction func confirm(sender: AnyObject) {
        resignAll()
        
        if Common.isLogin() == false {
            AlertView.alert("提示", message: "请登录后再使用", buttonTitle: "确定", viewController: self)
            return
        }
        
        if bidMoney.text.isEmpty {
            //bidMoney.becomeFirstResponder()
            AlertView.showMsg("请填写投标金额", parentView: self.view)
            return
        }
        if !Common.isMoney(bidMoney.text) {
            //bidMoney.becomeFirstResponder()
            AlertView.showMsg("只能是数字", parentView: self.view)
            return
        }
        
        if !reward.text.isEmpty && !Common.isMoney(reward.text) {
            //reward.becomeFirstResponder()
            AlertView.showMsg("奖金只能是数字", parentView: self.view)
            return
        }
        
        if !experience.text.isEmpty && !Common.isMoney(experience.text) {
            //experience.becomeFirstResponder()
            AlertView.showMsg("体验金只能是数字", parentView: self.view)
            return
        }
        
        
        if payPassword.text.isEmpty {
            //payPassword.becomeFirstResponder()
            AlertView.showMsg("请输入支付密码", parentView: self.view)
            return
        }
        if !Common.isPassword(payPassword.text) {
            //payPassword.becomeFirstResponder()
            AlertView.showMsg(Common.passwordErrorTip, parentView: self.view)
            return
        }
        let user = NSUserDefaults.standardUserDefaults()
        var pinpas = user.objectForKey("pinpass") as? String
        if ( pinpas == nil) || (pinpas!.isEmpty) {
                var view = self.storyboard?.instantiateViewControllerWithIdentifier("setPinPasswordViewController") as! SetPinPasswordViewController

                AlertView.alert("提示", message: "请设置交易密码", buttonTitle: "确定", viewController: self, callback: { (alertAction:UIAlertAction!) -> Void in
                    self.presentViewController(view, animated: true, completion: nil)
                })
        }
        
        //检查手机网络
        var reach = Reachability(hostName: Common.domain)
        reach.unreachableBlock = {(r:Reachability!) -> Void in
            //NSLog("网络不可用")
            dispatch_async(dispatch_get_main_queue(), {

                AlertView.alert("提示", message: "网络连接有问题，请检查手机网络", buttonTitle: "确定", viewController: self)
            })
        }
        
        reach.reachableBlock = {(r:Reachability!) -> Void in
           //NSLog("网络可用")
            dispatch_async(dispatch_get_main_queue(), {
                loading.startLoading(self.view)
                let afnet = AFHTTPRequestOperationManager()
                var param = NSMutableDictionary()
                var url = String()
                if let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String{
                    if let type = self.type {
                        if type == "8"{
                            param = ["borrow_id":self.id!,"invest_money":self.bidMoney.text,"pin":self.payPassword.text,"is_confirm":"0","reward_use":self.reward.text,"use_experince":self.experience.text,"to":token]
                            url = Common.serverHost + "/App-Invest-investmoney"
                        }else{
                            url = Common.serverHost + "/App-Invest-newtinvestmoney"
                            param = ["borrow_id":self.id!,"duration":self.duration,"transfer_invest_num":self.bidMoney.text,"pin":self.payPassword.text,"is_confirm":"0","reward_use":self.reward.text,"use_experince":self.experience.text,"to":token]
                        }
                    }
                }
                println(url)
                //        println(param)
                afnet.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                afnet.POST(url, parameters: param, success: { (opration :AFHTTPRequestOperation!, res :AnyObject!) -> Void in
//                    println(res)
                    loading.stopLoading()
                    //AlertView.showMsg(res["message"] as! String, parentView: self.view)
                    
                    var result = res as! NSDictionary
                    var code = result["code"] as! Int
                    if code == -1 {
                        AlertView.alert("提示", message: "请先登录", buttonTitle: "确定", viewController: self )
                        
                        
                    }else if code == 0 {
                        AlertView.alert("提示", message: res["message"] as! String, buttonTitle: "确定", viewController: self)
                    }else if code == 50 {
                        AlertView.alert("提示", message: "账户余额不足，请充值", buttonTitle: "确定", viewController: self)
                    }else if code == 200 {
                        
                        AlertView.alert("提示", message: "恭喜您投标成功", buttonTitle: "确定", viewController: self, callback: { (action:UIAlertAction!) -> Void in
                            self.navigationController?.popViewControllerAnimated(true)
                        })
                    }
                    
                    
                    }) { (opration:AFHTTPRequestOperation!, error:NSError!) -> Void in
                        println(error.localizedDescription)
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
        resignAll()
        return true
    }
    
    func resignAll(){
        bidMoney.resignFirstResponder()
        reward.resignFirstResponder()
        experience.resignFirstResponder()
        payPassword.resignFirstResponder()
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

