//
//  OffLineChargeViewController.swift
//  盛世财富
//  线下充值
//  Created by 肖典 on 15/5/23.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit
class OffLineChargeViewController:UIViewController,UITextFieldDelegate,BaofooSdkDelegate,
NSURLConnectionDelegate,NSURLConnectionDataDelegate {
    @IBOutlet weak var choose: UISegmentedControl!
    
    //pos机转账
    @IBOutlet weak var pos: UIView!//pos机视图
    @IBOutlet weak var p_money: UITextField!//pos机 金额
    @IBOutlet weak var p_money_label: UILabel!//pos机 金额
    @IBOutlet weak var p_id: UITextField!//pos机
    @IBOutlet weak var pBgView: UIView!//pos机
    @IBOutlet weak var btn1: UIButton!//pos机
    @IBOutlet weak var pl1: UILabel!
    @IBOutlet weak var pl2: UILabel!//收款人
    @IBOutlet weak var pl3: UILabel!
    @IBOutlet weak var pl4: UILabel!//开户行
    @IBOutlet weak var pl5: UILabel!
    @IBOutlet weak var pl6: UILabel!//收款账户
    
    //银行转账
    @IBOutlet weak var transfer: UIView!//银行转账视图
    @IBOutlet weak var t_money: UITextField!//银行转账 金额
    @IBOutlet weak var t_account: UITextField!//银行转账 账号
    @IBOutlet weak var t_id: UITextField!//银行转账 汇款单号
    @IBOutlet weak var btn2: UIButton!//银行转账 提交按钮
    @IBOutlet weak var bgView1: UIView!//银行转账 背景视图
    @IBOutlet weak var t_account_label: UILabel!//银行转账
    @IBOutlet weak var t_money_label: UILabel!//银行转账
    @IBOutlet weak var tl1: UILabel!
    @IBOutlet weak var tl2: UILabel!//收款人
    @IBOutlet weak var tl3: UILabel!
    @IBOutlet weak var tl4: UILabel!//开户行
    @IBOutlet weak var tl5: UILabel!
    @IBOutlet weak var tl6: UILabel!//收款账户
    
    
    
    //宝付充值
    @IBOutlet weak var onlineView: UIView!
    @IBOutlet weak var bgView3: UIView!
    @IBOutlet weak var onlineButton: UIButton!
    
    @IBOutlet weak var bl1: UILabel!
    @IBOutlet weak var bl2: UILabel!
    @IBOutlet weak var bl3: UILabel!
    @IBOutlet weak var bl4: UILabel!
    @IBOutlet weak var bl5: UILabel!
    @IBOutlet weak var bl6: UILabel!
    @IBOutlet weak var bl7: UILabel!
    
    @IBOutlet weak var bt1: UITextField!//银行卡号
    @IBOutlet weak var bt2: UITextField!//银行
    @IBOutlet weak var bt3: UITextField!//手机号
    @IBOutlet weak var bt4: UITextField!//充值金额
    @IBOutlet weak var bt5: UITextField!//姓名
    @IBOutlet weak var bt6: UITextField!//身份证
    
    var choosedBankId = "0"//选中的银行id
    var choosedBankCode = "0"//选中的银行编码
    var choosedBankName = "0"//选中的银行名称
    

    var receiveData:NSMutableData?
    var flag = ""//用于标示是测试还是真实环境
    
    var bankId:String?//银行id
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        choose.selectedSegmentIndex = 0
        t_account.delegate = self
        t_id.delegate = self
        p_money.delegate = self
        p_id.delegate = self
        
        
        bt1.delegate = self
        bt2.delegate = self
        bt3.delegate = self
        bt4.delegate = self
        
        //银行转账
        Common.customerBgView(bgView1)
        Common.customerButton(btn2)
        Common.addBorder(t_money)
        Common.addBorder(t_account)
        Common.addBorder(t_account_label)
        Common.addBorder(t_money_label)
        Common.addBorder(tl1)
        Common.addBorder(tl2)
        Common.addBorder(tl3)
        Common.addBorder(tl4)
        Common.addBorder(tl5)
        Common.addBorder(tl6)

        //pos机
        Common.customerBgView(pBgView)
        Common.customerButton(btn1)
        Common.addBorder(p_money_label)
        Common.addBorder(p_money)
        Common.addBorder(pl1)
        Common.addBorder(pl2)
        Common.addBorder(pl3)
        Common.addBorder(pl4)
        Common.addBorder(pl5)
        Common.addBorder(pl6)

        //宝付充值
        Common.customerBgView(bgView3)
        Common.customerButton(onlineButton)
        Common.addBorder(bl1)
        Common.addBorder(bl2)
        Common.addBorder(bl3)
        Common.addBorder(bl4)
        Common.addBorder(bl5)
        Common.addBorder(bl6)
        Common.addBorder(bl7)
        Common.addBorder(bt1)
        Common.addBorder(bt2)
        Common.addBorder(bt3)
        Common.addBorder(bt4)
        Common.addBorder(bt5)
        Common.addBorder(bt6)
        

        bt2.rightView = UIImageView(image: UIImage(named: "1_75"))
        bt2.rightViewMode = UITextFieldViewMode.Always
        
        
        //获取收款人信息
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
                var manager = AFHTTPRequestOperationManager()
                var url = Common.serverHost + "/App-Pay-companyInfo"
                var params = [:]
                
                manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                manager.POST(url, parameters: params,
                    success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                  
                        var result = data as! NSDictionary
                        var company = result["data"]?["company"] as! String
                        var khhwd = result["data"]?["khhwd"] as! String
                        var account = result["data"]?["account"] as! String
                        
                        self.tl2.text = company
                        self.tl4.text = khhwd
                        self.tl6.text = account
                        
                        self.pl2.text = company
                        self.pl4.text = khhwd
                        self.pl6.text = account
                        
                        
                    },failure: { (op:AFHTTPRequestOperation!, error:NSError!) -> Void in

                        AlertView.showMsg("服务器异常!", parentView: self.view)
                    }
                )
                
            })
        }
        reach.startNotifier()
        
    }
    
    
    //MARK:- 在线支付
    @IBAction func onlinePayTapped(sender: UIButton) {
        onlinePayAction()
    }
    
    func onlinePayAction(){
        resignAll()
        
        if !Common.isLogin() {
            AlertView.alert("提示", message: "请先登录", okButtonTitle: "确定", cancelButtonTitle: "取消", viewController: self, okCallback: { (action:UIAlertAction!) -> Void in
                var loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("loginViewController") as! LoginViewController
                self.presentViewController(loginViewController, animated: true, completion: nil)
                }, cancelCallback: { (action:UIAlertAction!) -> Void in
                    
            })
        }
        
        
        var to = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        
        var id_card = bt6.text//身份证号
        
        var id_holder = bt5.text//持卡人姓名
        
        var acc_no = bt1.text//银行卡号
        
        var pay_code = self.choosedBankCode//银行编码
        
        var mobile = bt3.text//银行预留手机号
        
        var moneyString = bt4.text//充值金额
        
        if id_holder.isEmpty {
            AlertView.showMsg("姓名不能为空", parentView: self.view)
            return
        }
        
        if id_card.isEmpty {
            AlertView.showMsg("身份证号不能为空", parentView: self.view)
            return
        }
        
//        var isVerify = NSUserDefaults.standardUserDefaults().objectForKey("isVerify") as? String
//        if id_card == "" || isVerify == "0" {
//            //还未实名认证
//            AlertView.alert("提示", message: "请完成实名认证后再充值", buttonTitle: "确定", viewController: self)
//            return
//        }
        
        if acc_no.isEmpty {
            AlertView.showMsg("银行卡号不能为空", parentView: self.view)
            return
        }
        
        if pay_code == "0" {
            AlertView.showMsg("请选中银行", parentView: self.view)
            return
        }
        
        if mobile.isEmpty {
            AlertView.showMsg("银行预留手机号不能为空", parentView: self.view)
            return
        }
        
        if !Common.isTelephone(mobile) {
            AlertView.showMsg(Common.telephoneErrorTip, parentView: self.view)
            return
        }
        
        if moneyString.isEmpty {
            AlertView.showMsg("请填写充值金额", parentView: self.view)
            return
        }
        
        if !Common.isMoney(moneyString){
            AlertView.showMsg(Common.moneyErrorTip, parentView: self.view)
            return
        }
        
        var moneyNum = (moneyString as NSString).doubleValue * 100
        var moneyNumStr:String!
        moneyNumStr = "\(moneyNum)"
        

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
                var manager = AFHTTPRequestOperationManager()
                var url = Common.serverHost + "/App-Pay-baofoovip"
                
                var params = ["to":to,"id_card":id_card,"id_holder":id_holder,
                    "mobile":mobile,"txn_amt":moneyNumStr,"pay_code":pay_code,"acc_no":acc_no]
                
                //NSLog("宝付url = %@", url)
                //NSLog("宝付params = %@", params)
                
                manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                manager.POST(url, parameters: params,
                    success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                        loading.stopLoading()
                        var result = data as! NSDictionary
                        //NSLog("宝付充值获取交易单号结果 ＝ %@", result)
                        var code = result["code"] as! Int
                        var message = result["message"] as! String
                        if code == -1 {
                            AlertView.alert("提示", message: "请先登录", okButtonTitle: "确定", cancelButtonTitle: "取消", viewController: self, okCallback: { (action:UIAlertAction!) -> Void in
                                var loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("loginViewController") as! LoginViewController//loginViewController
                                self.presentViewController(loginViewController, animated: true, completion: nil)
                                }, cancelCallback: { (action:UIAlertAction!) -> Void in
                                    
                            })
                        }else if code == 0 {
                            AlertView.alert("提示", message:message, buttonTitle: "确定", viewController: self)
                            
                        }else if code == 100 {
                            AlertView.alert("提示", message: "交易单号已经存在，不用重复提交", buttonTitle: "确定", viewController: self)
                        }else if code == 200 {
                            
                            var tradeNo = result["data"]?["tradeNo"] as! String//交易单号
                        
                            var baofooView = BaoFooPayController()
                            baofooView.PAY_TOKEN = tradeNo
                            baofooView.delegate = self
                            baofooView.PAY_BUSINESS = result["data"]?["isOfficial"] as! String
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
    
    
    //MARK:- BaofooDelegate
    func callBack(params: String!) {
        //NSLog("宝付返回的参数是：%@",params)
        var paramsStr = NSString(string: params)
        var code = paramsStr.substringToIndex(1)
        var message = paramsStr.substringFromIndex(2)
        if code == "1" {
            AlertView.showMsg(message, parentView: self.onlineView)
            self.bt4.text = ""
        }else if code == "0" {
            AlertView.alert("提示", message: message, buttonTitle: "确定", viewController: self)
        }
    }
    
    
    
    //MARK:- 线下充值
    @IBAction func submit(sender: UIButton) {
        submitAction()
    }
    
    func submitAction(){
        if Common.isLogin() == false {
            AlertView.alert("提示", message: "请先登录", okButtonTitle: "确定", cancelButtonTitle: "取消", viewController: self, okCallback: { (action:UIAlertAction!) -> Void in
                var loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("loginViewController") as! LoginViewController
                self.presentViewController(loginViewController, animated: true, completion: nil)
                }, cancelCallback: { (action:UIAlertAction!) -> Void in
                    
            })
            return
        }
        
        resignAll()
        
        
        let user = NSUserDefaults.standardUserDefaults()
        let url = Common.serverHost+"/App-Pay-offline"
        let afnet = AFHTTPRequestOperationManager()
        var param = [:]
        if choose.selectedSegmentIndex == 1{
            //NSLog("银行账号%@", t_account.text!)
            if t_account.text.isEmpty {
                AlertView.showMsg("请输入银行账号", parentView: self.view)
                return
            }
            if !Common.stringLengthIn(t_account.text!, start: 1, end: 50) {
                AlertView.showMsg("银行账号长度不能超过50", parentView: self.view)
                return
            }
            if t_money.text.isEmpty {
                AlertView.showMsg("请输入金额", parentView: self.view)
                return
            }
            if !Common.isMoney(t_money.text) {
                AlertView.showMsg(Common.moneyErrorTip, parentView: self.view)
                return
            }
            if t_id.text.isEmpty {
                AlertView.showMsg("请输入汇款单号", parentView: self.view)
                return
            }
            if !Common.stringLengthIn(t_id.text!, start: 1, end: 50) {
                AlertView.showMsg("汇款单号长度不能超过50", parentView: self.view)
                return
            }
            param = ["to":user.stringForKey("token")!,"money_off":t_money.text,"off_bank":"兴业银行","off_way":t_account.text,"tran_id":t_id.text]
        }
        if choose.selectedSegmentIndex == 2{
            
            if p_money.text.isEmpty {
                AlertView.showMsg("请输入金额", parentView: self.view)
                return
            }
            if !Common.isMoney(p_money.text) {
                AlertView.showMsg(Common.moneyErrorTip, parentView: self.view)
                return
            }
            if p_id.text.isEmpty {
                AlertView.showMsg("请输入交易参考号", parentView: self.view)
                return
            }
            if !Common.stringLengthIn(p_id.text!, start: 1, end: 50) {
                AlertView.showMsg("交易单号长度不能超过50", parentView: self.view)
                return
            }
            param = ["to":user.stringForKey("token")!,"money_off":p_money.text,"off_bank":"无","off_way":"pos机刷卡","tran_id":p_id.text]
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
                //NSLog("线下充值")
                //NSLog("url = %@", url)
                //NSLog("param = %@", param)
                afnet.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                afnet.POST(url, parameters: param, success: { (opration:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                    loading.stopLoading()
                    
                    AlertView.alert("提示", message: data["message"] as! String, buttonTitle: "确定", viewController: self, callback: { (action:UIAlertAction!) -> Void in
                        //self.navigationController?.popViewControllerAnimated(true)
                        self.t_account.text = ""
                        self.t_id.text = ""
                        self.t_money.text = ""
                        self.p_id.text = ""
                        self.p_money.text = ""
                    })
                    }) { (opration:AFHTTPRequestOperation!, error:NSError!) -> Void in
                        loading.stopLoading()
                        AlertView.alert("错误", message: error.localizedDescription, buttonTitle: "确定", viewController: self)
                }
            })
        }
        reach.startNotifier()
    }
    
    @IBAction func segChange(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                self.view.bringSubviewToFront(onlineView)
                break
            case 1:self.view.bringSubviewToFront(transfer)
                break
            case 2:self.view.bringSubviewToFront(pos)
                break
            
            default:break
        }
    }
   

    
    //MARK:- hide keyboard
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        resignAll()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        resignAll()
        if textField == t_id {
            submitAction()
        }else if textField == t_account {
            t_money.becomeFirstResponder()
        }else if textField == p_money {
            p_id.becomeFirstResponder()
        }else if textField == p_id {
            submitAction()
        }else if textField == bt5 {
            bt6.becomeFirstResponder()
        }else if textField == bt6 {
            bt1.becomeFirstResponder()
        }else if textField == bt1 {
            bt2.becomeFirstResponder()
        }else if textField == bt2 {
            bt3.becomeFirstResponder()
        }else if textField == bt3 {
            bt4.becomeFirstResponder()
        }else if textField == bt4 {
            onlinePayAction()
        }
        
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if range.location > 30 {
            return false
        }
        return true
    }
    
    
    func resignAll(){
        t_money.resignFirstResponder()
        t_account.resignFirstResponder()
        t_id.resignFirstResponder()
        p_money.resignFirstResponder()
        p_id.resignFirstResponder()
        bt1.resignFirstResponder()
        bt2.resignFirstResponder()
        bt3.resignFirstResponder()
        bt4.resignFirstResponder()
        bt5.resignFirstResponder()
        bt6.resignFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        DaiDodgeKeyboard.addRegisterTheViewNeedDodgeKeyboard(self.view)
        super.viewWillAppear(animated)
        if self.choosedBankId != "0" {
            //NSLog("选中的银行：%@,%@", choosedBankId,choosedBankCode)
            bt2.text = choosedBankName
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        DaiDodgeKeyboard.removeRegisterTheViewNeedDodgeKeyboard()
        super.viewWillDisappear(animated)
    }

    //选择银行
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == bt2 {
            self.view.endEditing(true)
            self.performSegueWithIdentifier("chooseBank", sender: nil)
            return false
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "chooseBank" {
            var chooseBankTableViewController = segue.destinationViewController as! ChooseBankTableViewController
            chooseBankTableViewController.choosedBankId = self.choosedBankId
            chooseBankTableViewController.viewController = self
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}