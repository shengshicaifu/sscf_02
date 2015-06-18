//
//  GetCashViewController.swift
//  盛世财富
//  提现
//  Created by 肖典 on 15/5/25.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit
class GetCashViewController:UIViewController,UITextFieldDelegate {
    @IBOutlet weak var money: UITextField!
    @IBOutlet weak var payPassword: UITextField!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        money.delegate = self
        payPassword.delegate = self
        
        Common.customerBgView(bgView)
        Common.addBorder(moneyLabel)
        Common.addBorder(money)
        Common.customerButton(okButton)
    }
    @IBAction func submit(sender: UIButton) {
        submitAction()
    }
    
    func submitAction(){
        resignAll()
        if money.text.isEmpty {
            AlertView.showMsg("请输入金额", parentView: self.view)
            return
        }
        if !Common.isMoney(money.text) {
            AlertView.showMsg(Common.moneyErrorTip, parentView: self.view)
            return
        }
        if payPassword.text.isEmpty {
            AlertView.showMsg("请输入支付密码", parentView: self.view)
            return
        }
        if !Common.isPassword(payPassword.text) {
            AlertView.showMsg("支付密码为英文字母和数字，长度在6到20之间", parentView: self.view)
            return
        }
        
        let user = NSUserDefaults.standardUserDefaults()
        let url = Common.serverHost+"/App-Ucenter-actwithdraw"
        let afnet = AFHTTPRequestOperationManager()
        var param = ["to":user.stringForKey("token"),"txt_Amount":money.text,"txtPassword":payPassword.text]
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
                afnet.POST(url, parameters: param, success: { (opration:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                    loading.stopLoading()
                    var code = data["code"] as! Int
                    if code == 200 {
                        AlertView.alert("提示", message: "提现申请提交成功，请等待审核", buttonTitle: "确定", viewController: self, callback: { (action:UIAlertAction!) -> Void in
                            self.navigationController?.popViewControllerAnimated(true)
                        })
                    }else {
                        AlertView.alert("提示", message: data["message"] as! String, buttonTitle: "确定", viewController: self)
                    }
                    }) { (opration:AFHTTPRequestOperation!, error:NSError!) -> Void in
                        loading.stopLoading()
                        AlertView.alert("提示", message: "服务器异常，请稍候再试", buttonTitle: "确定", viewController: self)
                }
            })
        }
        reach.startNotifier()
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        resignAll()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == payPassword {
            submitAction()
        }
        return true
    }
    
    func resignAll(){
        
        money.resignFirstResponder()
        payPassword.resignFirstResponder()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if range.location > 19 {
            return false
        }
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