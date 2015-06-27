//
//  OffLineChargeViewController.swift
//  盛世财富
//  线下充值
//  Created by 肖典 on 15/5/23.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit
class OffLineChargeViewController:UIViewController,UITextFieldDelegate,
    //BaofooSdkDelegate,
NSURLConnectionDelegate,NSURLConnectionDataDelegate,GopayNewPlatformDelegate {
    @IBOutlet weak var choose: UISegmentedControl!
    @IBOutlet weak var pos: UIView!//pos机视图
    @IBOutlet weak var p_money: UITextField!//pos机 金额
    @IBOutlet weak var p_money_label: UILabel!//pos机 金额
    @IBOutlet weak var p_id: UITextField!//pos机
    @IBOutlet weak var pBgView: UIView!//pos机
    @IBOutlet weak var btn1: UIButton!//pos机
    
    
    @IBOutlet weak var transfer: UIView!//银行转账视图
    @IBOutlet weak var t_money: UITextField!//银行转账 金额
    @IBOutlet weak var t_account: UITextField!//银行转账 账号
    @IBOutlet weak var t_id: UITextField!//银行转账 汇款单号
    @IBOutlet weak var btn2: UIButton!//银行转账 提交按钮
    @IBOutlet weak var bgView1: UIView!//银行转账 背景视图
    
    @IBOutlet weak var t_account_label: UILabel!//银行转账
    @IBOutlet weak var t_money_label: UILabel!//银行转账
    //线上充值
    @IBOutlet weak var onlineView: UIView!
    @IBOutlet weak var onlineMoneyTextField: UITextField!
    @IBOutlet weak var bgView3: UIView!
    @IBOutlet weak var onlineButton: UIButton!
    @IBOutlet weak var chargeTypeLabe: UILabel!
    @IBOutlet weak var onlineRealPayMoneyLabel: UILabel!
    var receiveData:NSMutableData?
    var flag = ""//用于标示是测试还是真实环境
    
    @IBOutlet weak var chargeTypeSegment: UISegmentedControl!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        choose.selectedSegmentIndex = 0
        t_account.delegate = self
        t_id.delegate = self
        p_money.delegate = self
        p_id.delegate = self
        onlineMoneyTextField.delegate = self
        
        
        
        
        //银行转账
        Common.customerBgView(bgView1)
        Common.customerButton(btn2)
        Common.addBorder(t_money)
        Common.addBorder(t_account)
        Common.addBorder(t_account_label)
        Common.addBorder(t_money_label)
        //pos机
        Common.customerBgView(pBgView)
        Common.customerButton(btn1)
        Common.addBorder(p_money_label)
        Common.addBorder(p_money)
        //充值
        Common.customerBgView(bgView3)
        Common.customerButton(onlineButton)
        
        var border = CALayer()
        border.frame = CGRectMake(chargeTypeLabe.frame.origin.x, chargeTypeLabe.frame.height - 1, bgView3.frame.width - chargeTypeLabe.frame.origin.x, 1)
        border.backgroundColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1.0).CGColor
        bgView3.layer.addSublayer(border)
        
    }
    
    //MARK:- 在线支付
    @IBAction func onlinePayTapped(sender: UIButton) {
        onlinePayAction()
    }
    
    func onlinePayAction(){
        resignAll()
        var moneyString = onlineMoneyTextField.text
        
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
        
        if chargeTypeSegment.selectedSegmentIndex == 0 {
            //宝付
            
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
                    var url = Common.serverHost + "/App-Pay-baofoo"
                    var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String
                    var params = ["to":token,"money":moneyNumStr]
                    manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                    manager.POST(url, parameters: params,
                        success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                            loading.stopLoading()
                            var result = data as! NSDictionary
                            //NSLog("交易单号%@", result)
                            var code = result["code"] as! Int
                            if code == -1 {
                                AlertView.alert("提示", message: "请登录后再使用", buttonTitle: "确定", viewController: self)
                                
                            }else if code == 0 {
                                AlertView.alert("提示", message: "服务器异常,请稍候再试", buttonTitle: "确定", viewController: self)
                                
                            }else if code == 100 {
                                AlertView.alert("提示", message: "交易单号已经存在，不用重复提交", buttonTitle: "确定", viewController: self)
                            }else if code == 200 {
                                
                                var tradeNo = result["data"]?["tradeNo"] as! String//交易单号
                                //
//                                var baofooView = BaoFooPayController()
//                                baofooView.PAY_TOKEN = tradeNo
//                                baofooView.delegate = self
//                                baofooView.PAY_BUSINESS = "false"
//                                self.presentViewController(baofooView, animated: true, completion: nil)
//                                
                                
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
                    var url = Common.serverHost + "/App-Pay-guofubao"
                    var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String
                    var phone_token = GopayNewPlatform.getGopayIdentifierForPayment()
                    var params = ["to":token,"money":moneyNumStr,"phone_token":phone_token]
                    manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                    manager.POST(url, parameters: params,
                        success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                            loading.stopLoading()
                            var result = data as! NSDictionary
                            //NSLog("国付宝信息%@", result)
                            //                                {
                            //                                    code = 200;
                            //                                    data =     {
                            //                                        submitdata =         {
                            //                                            backgroundMerUrl = "http://61.183.178.86:10888/MidServer/App-Payres-paynotice?payid=guofubao";
                            //                                            buyerContact = 21d0c6ee8ae6f5c6055a131b64c84747;
                            //                                            buyerName = MWAP;
                            //                                            charset = 2;
                            //                                            currencyType = 156;
                            //                                            feeAmt = 0;
                            //                                            frontMerUrl = "";
                            //                                            goodsName = "\U76db\U4e16\U8d22\U5bcc\U5e10\U6237\U5145\U503c";
                            //                                            isRepeatSubmit = 0;
                            //                                            language = 1;
                            //                                            merOrderNum = guofu1433326253339529;
                            //                                            merchantID = 0000001502;
                            //                                            mobileSighValue = 4791c6224b334704eedb1d8dee5782b0;
                            //                                            "sign_value" = b53ee11b50d9df308aaaaca600d3ea8c;
                            //                                            singType = 1;
                            //                                            tranAmt = "20.00";
                            //                                            tranCode = 8888;
                            //                                            tranDateTime = 20150603181053;
                            //                                            tranIP = "192.168.1.253";
                            //                                            version = "2.1";
                            //                                            virCardNoIn = 0000000002000000257;
                            //                                        };
                            //                                        url = "http://www.gopay.com.cn/PGServer/mtrans.do";
                            //                                    };
                            //                                    message = "\U8ba2\U5355\U53f7\U83b7\U53d6\U6210\U529f";
                            //                            }
                            
                            
                            var code = result["code"] as! Int
                            if code == -1 {
                                AlertView.alert("提示", message: "请登录后再使用", buttonTitle: "确定", viewController: self)
                                
                            }else if code == 200 {
                                var url = ""
                                var sendParameters = result["data"]?["submitdata"] as! NSDictionary
                                var gopayNewPlatform = GopayNewPlatform()
                                gopayNewPlatform.delegate = self
                                gopayNewPlatform.startGopayWithParameters(sendParameters as! [NSString : NSString])
                                
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

    }
    
    
    //MARK:- BaofooDelegate
    func callBack(params: String!) {
        //NSLog("返回的参数是：%@",params)
        var paramsStr = NSString(string: params)
        var code = paramsStr.substringToIndex(1)
        var message = paramsStr.substringFromIndex(2)
        if code == "1" {
            AlertView.showMsg(message, parentView: self.onlineView)
            self.onlineMoneyTextField.text = ""
        }else if code == "0" {
            AlertView.alert("提示", message: message, buttonTitle: "确定", viewController: self)
        }
    }
    
    //MARK:- GopayDelegate
    func gopayDidClosed(){
        
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
        //开始动画
//        UIView.beginAnimations("test",context: nil)
        //动画时长
//        UIView.setAnimationDuration(1)
        // FlipFromRight
        // CurlUp
        //动画样式
//        UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromRight,
//            forView :self.view,
//            cache:true)
        //更改view顺序
        //self.view.exchangeSubviewAtIndex(0,withSubviewAtIndex :1)
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
        
        //提交动画
        //UIView.commitAnimations()
        
        
    }
   

    
    //MARK:- hide keyboard
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        resignAll()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        resignAll()
        //NSLog("textFieldShouldReturn")
        if textField == t_id {
            submitAction()
        }
        if textField == t_account {
            t_money.becomeFirstResponder()
        }
        if textField == p_money {
            p_id.becomeFirstResponder()
        }
        if textField == p_id {
            submitAction()
        }
        if textField == onlineMoneyTextField {
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