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

    @IBOutlet weak var styleView: UIView!
    @IBOutlet weak var bidMoney: UITextField!
    @IBOutlet weak var reward: UITextField!
    @IBOutlet weak var experience: UITextField!
    @IBOutlet weak var payPassword: UITextField!
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var usermoney: UILabel!
    @IBOutlet weak var bidName: UILabel!
    @IBOutlet weak var bidRate: UILabel!
    @IBOutlet weak var restMoney: UILabel!
    @IBOutlet weak var currentRateLabel: UILabel!
    @IBOutlet weak var restMoneyLabel: UILabel!
    @IBOutlet weak var bidMoneyLabel: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var payPasswordLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var yourNameLabel: UILabel!
    @IBOutlet weak var yourMoneyLabel: UILabel!
    @IBOutlet weak var second: UILabel!
    @IBOutlet weak var first: UILabel!
    @IBOutlet weak var third: UILabel!
    
    var id:String?
    var type:String?
    var duration:String = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        resignAll()
        
        // Do any additional setup after loading the view, typically from a nib.
        bidMoney.delegate = self
        reward.delegate = self
        experience.delegate = self
        payPassword.delegate = self
        //payBtn.layer.cornerRadius = 5
        
        Common.customerButton(payBtn)
        Common.addBorder(yourMoneyLabel)
        Common.addBorder(usermoney)
        Common.addBorder(yourNameLabel)
        Common.addBorder(bidName)
        Common.addBorder(currentRateLabel)
        Common.addBorder(bidRate)
        Common.addBorder(restMoney)
        Common.addBorder(restMoneyLabel)
        Common.addBorder(bidMoneyLabel)
        Common.addBorder(bidMoney)
        Common.addBorder(reward)
        Common.addBorder(rewardLabel)
        Common.addBorder(experience)
        Common.addBorder(experienceLabel)
        Common.addBorder(first)
        Common.addBorder(second)
        Common.addBorder(third)
        
        self.scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "resignAll"))
    
        //加载数据
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let url = Common.serverHost+"/app-invest-detailcontent-id-"+self.id!
        let afnet = AFHTTPRequestOperationManager()
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
                afnet.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                afnet.GET(url, parameters: nil, success: { (operation:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                    loading.stopLoading()
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
                                self.bidMoneyLabel.text = "认购份数："
                                self.first.text = "份"
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
                        loading.stopLoading()
                        AlertView.alert("提示", message: "服务器错误，请稍候再试", buttonTitle: "确定", viewController: self, callback: { (action:UIAlertAction!) -> Void in
                            self.navigationController?.popViewControllerAnimated(true)
                        })
                })
            })
        }
        reach.startNotifier()
        
    }
    @IBAction func confirm(sender: AnyObject) {
        confirmAction()
    }
    
    func confirmAction(){
        
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
        
        if bidMoney.text.isEmpty {
            //bidMoney.becomeFirstResponder()
            if self.type != "8" {
                AlertView.showMsg("请填写认购份数", parentView: self.view)
            }else{
                AlertView.showMsg("请填写投标金额", parentView: self.view)
            }
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
                        //AlertView.alert("提示", message: "请先登录", buttonTitle: "确定", viewController: self )
                        AlertView.alert("提示", message: "请先登录", okButtonTitle: "确定", cancelButtonTitle: "取消", viewController: self, okCallback: { (action:UIAlertAction!) -> Void in
                            var loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                            self.presentViewController(loginViewController, animated: true, completion: nil)
                            }, cancelCallback: { (action:UIAlertAction!) -> Void in
                                
                        })
                        
                    }else if code == 0 {
                        AlertView.alert("提示", message: res["message"] as! String, buttonTitle: "确定", viewController: self)
                    }else if code == 50 {
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
        if textField == bidMoney {
            reward.becomeFirstResponder()
        }else if textField == reward {
            experience.becomeFirstResponder()
        }else if textField == experience {
            payPassword.becomeFirstResponder()
        }else if textField == payPassword {
            confirmAction()
        }
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

