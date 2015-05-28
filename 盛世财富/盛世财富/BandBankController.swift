//
//  BandBankController.swift
//  盛世财富
//
//  Created by 云笺 on 15/5/25.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit
class BandBankController: UIViewController,UITableViewDelegate {
    @IBOutlet weak var addTapped: UIButton!
    @IBOutlet weak var bankCardNoTextField: UITextField!
    @IBOutlet weak var bankNameTextField: UITextField!
    @IBOutlet weak var bankProviceTextField: UITextField!
    @IBOutlet weak var bankCityTextField: UITextField!
    @IBOutlet weak var bankBranchTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        var userDefaults = NSUserDefaults.standardUserDefaults()
        var bankCardNo = userDefaults.objectForKey("bankCardNo") as? String
        println("bankCardNo\(bankCardNo)")
        if bankCardNo == "" || bankCardNo == nil{
            addTapped.setTitle("添加", forState: UIControlState.Normal)
        }else{
            bankCardNoTextField.text = userDefaults.objectForKey("bankCardNo") as? String
            bankNameTextField.text = userDefaults.objectForKey("bankName") as? String
            bankProviceTextField.text = userDefaults.objectForKey("bankProvice") as? String
            bankCityTextField.text = userDefaults.objectForKey("bankCity") as? String
            bankBranchTextField.text = userDefaults.objectForKey("bankBranch") as? String
            addTapped.setTitle("修改", forState: UIControlState.Normal)
       }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }

    @IBAction func AddTapped(sender: AnyObject) {
        //绑定银行卡
        resignAll()
        var userDefaults = NSUserDefaults.standardUserDefaults()
        var bankCardNo = userDefaults.objectForKey("bankCardNo") as? String
        if bankCardNo == nil{
        var bankCardNo = bankCardNoTextField.text
        var bankName = bankNameTextField.text
        var bankProvice = bankProviceTextField.text
        var bankCity = bankCityTextField.text
        var bankBranch = bankBranchTextField.text
        if bankCardNo.isEmpty {
            AlertView.showMsg("请输入银行卡账号", parentView: self.view)
            return
        }
        if bankName.isEmpty {
            AlertView.showMsg("请输入银行名称", parentView: self.view)
            return
        }
        if bankProvice.isEmpty {
            AlertView.showMsg("请输入银行省份", parentView: self.view)
            return
        }
        if bankCity.isEmpty {
            AlertView.showMsg("请输入银行城市", parentView: self.view)
            return
        }
        if bankBranch.isEmpty {
            AlertView.showMsg("请输入银行支行", parentView: self.view)
            return
        }
        //其他输入限制再加
        //检查手机网络
        var reach = Reachability(hostName: Common.domain)
        reach.unreachableBlock = {(r:Reachability!) -> Void in
            //NSLog("网络不可用")
            dispatch_async(dispatch_get_main_queue(), {
                
                AlertView.alert("提示", message: "网络连接有问题，请检查手机网络", buttonTitle: "确定", viewController: self)
            })
        }
        let manager = AFHTTPRequestOperationManager()
        var url = Common.serverHost + "/App-Ucenter-bindBank"
        var token = userDefaults.objectForKey("token") as! String
        println(token)
        let params = ["to":token,"txt_account":bankCardNo,"bank_name":bankName,"province":bankProvice,"city":bankCity,"txt_bankName":bankBranch]
        manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
        manager.POST(url, parameters: params,
             success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                var result = data as! NSDictionary
                println("银行卡绑定\(result)")
                var code = result["code"] as! Int
                if code == -1 {
                    AlertView.showMsg("请登录后再试", parentView: self.view)
                }else if code == 0 {
                    AlertView.showMsg(result["message"] as! String, parentView: self.view)
                }else if code == 200 {
                    AlertView.showMsg("绑定银行卡成功", parentView: self.view)
                    NSThread.sleepForTimeInterval(3)
                   
                   
                    userDefaults.setObject(bankCardNo, forKey: "bankCardNo")
                    userDefaults.setObject(bankName, forKey: "bankName")
                    userDefaults.setObject(bankProvice, forKey: "bankProvice")
                    userDefaults.setObject(bankCity, forKey: "bankCity")
                    userDefaults.setObject(bankBranch, forKey: "bankBranch")
                self.navigationController?.popViewControllerAnimated(true)
                }
            },failure: { (op:AFHTTPRequestOperation!, error:NSError!) -> Void in
                AlertView.alert("提示", message: "服务器错误", buttonTitle: "确定", viewController: self)
            }
        )
    }
    //修改银行卡账号
    else {
           
        let manager = AFHTTPRequestOperationManager()
        var url = Common.serverHost + "/App-Ucenter-bindBank"
        var token = userDefaults.objectForKey("token") as? String
        var bankCardNo = userDefaults.objectForKey("bankCardNo") as? String
        println(token)
            println(bankNameTextField.text)
            println(bankCardNo)
            println(bankCardNoTextField.text)
        let params = ["to":token,"txt_account":bankCardNoTextField.text,"bank_name":bankNameTextField.text,"province":bankProviceTextField.text,"city":bankCityTextField.text,"txt_bankName":bankBranchTextField.text,"txt_oldaccount":bankCardNo]
        manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
        manager.POST(url, parameters: params,
        success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
        var result = data as! NSDictionary
        println("银行卡修改\(result)")
        var code = result["code"] as! Int
        if code == -1 {
        AlertView.showMsg("请登录后再试", parentView: self.view)
        }else if code == 0 {
        AlertView.showMsg(result["message"] as! String, parentView: self.view)
        }else if code == 200 {
        AlertView.showMsg("修改银行卡成功", parentView: self.view)
        NSThread.sleepForTimeInterval(3)
            userDefaults.setObject(self.bankCardNoTextField.text, forKey: "bankCardNo")
            userDefaults.setObject(self.bankNameTextField.text, forKey: "bankName")
            userDefaults.setObject(self.bankProviceTextField.text, forKey: "bankProvice")
            userDefaults.setObject(self.bankCityTextField.text, forKey: "bankCity")
            userDefaults.setObject(self.bankBranchTextField.text, forKey: "bankBranch")
        self.navigationController?.popViewControllerAnimated(true)
       }
    },failure: { (op:AFHTTPRequestOperation!, error:NSError!) -> Void in
    AlertView.alert("提示", message: "服务器错误", buttonTitle: "确定", viewController: self)
    }
)
}
    }
    //MARK:- 隐藏键盘
    override func viewWillAppear(animated: Bool) {
        DaiDodgeKeyboard.addRegisterTheViewNeedDodgeKeyboard(self.view)
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(animated: Bool) {
        DaiDodgeKeyboard.removeRegisterTheViewNeedDodgeKeyboard()
        super.viewWillDisappear(animated)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        resignAll()
        return true
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        resignAll()
    }
    
    func resignAll() {
        bankCardNoTextField.resignFirstResponder()
        bankNameTextField.resignFirstResponder()
        bankProviceTextField.resignFirstResponder()
        bankCityTextField.resignFirstResponder()
        bankBranchTextField.resignFirstResponder()
    }

}
