//
//  OffLineChargeViewController.swift
//  盛世财富
//  线下充值
//  Created by 肖典 on 15/5/23.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit
class OffLineChargeViewController:UIViewController,UITextFieldDelegate,BaofooSdkDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate,GopayNewPlatformDelegate {
    @IBOutlet weak var choose: UISegmentedControl!
    @IBOutlet weak var transfer: UIView!
    @IBOutlet weak var pos: UIView!
    @IBOutlet weak var t_money: UITextField!
    @IBOutlet weak var t_account: UITextField!
    @IBOutlet weak var t_id: UITextField!
    @IBOutlet weak var p_money: UITextField!
    @IBOutlet weak var p_id: UITextField!
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    
    //线上充值
    @IBOutlet weak var onlineView: UIView!
    @IBOutlet weak var onlineMoneyTextField: UITextField!
    @IBOutlet weak var onlineRealPayMoneyLabel: UILabel!
    var receiveData:NSMutableData?
    var flag = ""//用于标示是测试还是真实环境
    
    @IBOutlet weak var chargeTypeSegment: UISegmentedControl!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btn1.layer.cornerRadius = 5
        btn2.layer.cornerRadius = 5
        choose.selectedSegmentIndex = 0
        t_id.delegate = self
    }
    
    //MARK:- 在线支付
    @IBAction func onlinePayTapped(sender: UIButton) {
        resignAll()
        if onlineMoneyTextField.text.isEmpty {
            AlertView.showMsg("请填写充值金额", parentView: self.view)
            return
        }
        
        if !Common.isMoney(onlineMoneyTextField.text){
            AlertView.showMsg(Common.moneyErrorTip, parentView: self.view)
            return
        }

        if chargeTypeSegment.selectedSegmentIndex == 0 {
            //宝付
            
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
                    var manager = AFHTTPRequestOperationManager()
                    var url = Common.serverHost + "/App-Paytest-baofoo"
                    var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String
                    var params = ["to":token,"money":self.onlineMoneyTextField.text]
                    manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                    manager.POST(url, parameters: params,
                        success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                            loading.stopLoading()
                            var result = data as! NSDictionary
                            NSLog("交易单号%@", result)
                            var code = result["code"] as! Int
                            if code == -1 {
                                AlertView.alert("提示", message: "请登录后再使用", buttonTitle: "确定", viewController: self)
                                
                            }else if code == 0 {
                                AlertView.alert("提示", message: "服务器异常,请稍候再试", buttonTitle: "确定", viewController: self)
                                
                            }else if code == 100 {
                                AlertView.alert("提示", message: "交易单号已经存在，不用重复提交", buttonTitle: "确定", viewController: self)
                            }else if code == 200 {
                                
                                var tradeNo = result["data"]?["tradeNo"] as! String//交易单号
                                
                                var baofooView = BaoFooPayController()
                                baofooView.PAY_TOKEN = tradeNo
                                baofooView.delegate = self
                                baofooView.PAY_BUSINESS = "false"
                                self.presentViewController(baofooView, animated: true, completion: nil)
                                
                                
                            }
                            
                        },failure: { (op:AFHTTPRequestOperation!, error:NSError!) -> Void in
                            loading.stopLoading()
                            AlertView.showMsg("服务器异常!", parentView: self.view)
                        }
                    )
                    
                })
            }
            reach.startNotifier()
        }
        else if chargeTypeSegment.selectedSegmentIndex == 1 {
            //国付宝
            //获取商户号
            //获取手机token
            NSLog("手机token%@",GopayNewPlatform.getGopayIdentifierForPayment())
            
            var sendParameters = ["":""]
            GopayNewPlatform().startGopayWithParameters(sendParameters)
        }
        
        
    }
    
    
    
    //MARK:- BaofooDelegate
    func callBack(params: String!) {
        NSLog("返回的参数是：%@",params)
        AlertView.alert("提示", message: NSString(format: "支付结果:%@", params) as String, buttonTitle: "确定", viewController: self)
    }
    
    //MARK:- GopayDelegate
    func gopayDidClosed(){
        
    }
    
    
    
    //MARK:- 线下充值
    @IBAction func submit(sender: UIButton) {
        resignAll()
        
        
        let user = NSUserDefaults.standardUserDefaults()
        let url = Common.serverHost+"/App-Pay-offline"
        let afnet = AFHTTPRequestOperationManager()
        var param:AnyObject?
        if choose.selectedSegmentIndex == 0{
            if t_money.text.isEmpty {
                AlertView.showMsg("请输入金额！", parentView: self.view)
                return
            }
            if !Common.isMoney(t_money.text) {
                AlertView.showMsg(Common.moneyErrorTip, parentView: self.view)
                return
            }
            if t_account.text.isEmpty {
                AlertView.showMsg("请输入银行账号！", parentView: self.view)
                return
            }
            if t_id.text.isEmpty {
                AlertView.showMsg("请输入汇款单号！", parentView: self.view)
                return
            }
            param = ["to":user.stringForKey("token"),"money_off":t_money.text,"off_bank":"兴业银行","off_way":t_account.text,"tran_id":t_id.text]
        }
        if choose.selectedSegmentIndex == 1{
            
            if p_money.text.isEmpty {
                AlertView.showMsg("请输入金额！", parentView: self.view)
                return
            }
            if !Common.isMoney(p_money.text) {
                AlertView.showMsg(Common.moneyErrorTip, parentView: self.view)
                return
            }
            if p_id.text.isEmpty {
                AlertView.showMsg("请输入交易参考号！", parentView: self.view)
                return
            }
            
            param = ["to":user.stringForKey("token"),"money_off":p_money.text,"off_bank":"无","off_way":"pos机刷卡","tran_id":p_id.text]
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
                afnet.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                afnet.POST(url, parameters: param, success: { (opration:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                    loading.stopLoading()
                    AlertView.showMsg(data["message"] as! String, parentView:  self.view)
//                    AlertView.alert("提示", message: data["message"], buttonTitle:"确定", viewController: self)
                     self.navigationController?.popViewControllerAnimated(true)
                    }) { (opration:AFHTTPRequestOperation!, error:NSError!) -> Void in
                        loading.stopLoading()
                        AlertView.alert("错误", message: error.localizedDescription, buttonTitle: "确定", viewController: self)
                }
            })
        }
        reach.startNotifier()
        
    }
    @IBAction func segChange(sender: UISegmentedControl) {
        //开始动画
        UIView.beginAnimations("test",context: nil)
        //动画时长
        UIView.setAnimationDuration(1)
        // FlipFromRight
        // CurlUp
        //动画样式
        UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromRight,
            forView :self.view,
            cache:true)
        //更改view顺序
        //self.view.exchangeSubviewAtIndex(0,withSubviewAtIndex :1)
        switch sender.selectedSegmentIndex {
            case 0:self.view.bringSubviewToFront(transfer)
                break
            case 1:self.view.bringSubviewToFront(pos)
                break
            case 2:
                self.view.bringSubviewToFront(onlineView)
            break
            default:break
        }
        
        //提交动画
        UIView.commitAnimations()
        
        
    }
   

    
    //MARK:- hide keyboard
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        resignAll()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        resignAll()
        return true
    }
    
    
    func resignAll(){
        t_money.resignFirstResponder()
        t_account.resignFirstResponder()
        t_id.resignFirstResponder()
        p_money.resignFirstResponder()
        p_id.resignFirstResponder()
        onlineMoneyTextField.resignFirstResponder()
        
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