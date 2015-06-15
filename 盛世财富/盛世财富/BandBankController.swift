//
//  BandBankController.swift
//  盛世财富
//
//  Created by 云笺 on 15/5/25.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit
/**
*  修改银行卡
*/
class BandBankController: UIViewController,UITableViewDelegate,UITextFieldDelegate {
    @IBOutlet weak var styleView: UIView!
    @IBOutlet weak var addTapped: UIButton!
    @IBOutlet weak var bankCardNoTextField: UITextField!
    @IBOutlet weak var bankNameTextField: UITextField!
    @IBOutlet weak var bankBranchTextField: UITextField!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var bankCardNoLabel: UILabel!
    @IBOutlet weak var ProvincePick: UIPickerView!
    var listData :NSArray = [] //存储json数据的
    var province:NSMutableArray =  []
    var city:NSMutableArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        ProvincePick.delegate = self
        ProvincePick.dataSource = self
        bankCardNoTextField.delegate = self
        bankNameTextField.delegate = self
        bankBranchTextField.delegate = self
    
        
        
        Common.customerBgView(styleView)
        Common.customerButton(addTapped)
        Common.addBorder(bankNameTextField)
        Common.addBorder(bankCardNoTextField)
        Common.addBorder(bankNameLabel)
        Common.addBorder(bankCardNoLabel)
        
        
        //获取json数据
        var path = NSBundle.mainBundle().pathForResource("area", ofType: "json")
        var jsonData:NSData = NSData(contentsOfFile: path!)!
        var jsonDic = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil)
        listData = jsonDic as! NSArray
        var count = self.listData.count
        println(listData)
        for row in 0...listData.count-1{
            var provinces = listData[row].valueForKey("province") as! String
            province.addObject(provinces)
        }
        

        
        var userDefaults = NSUserDefaults.standardUserDefaults()
        var bankCardNo = userDefaults.objectForKey("bankCardNo") as? String
        println("bankCardNo\(bankCardNo)")
        if bankCardNo == "" || bankCardNo == nil{
            addTapped.setTitle("添加", forState: UIControlState.Normal)
            self.title = "添加银行卡"
            
            var curCity = listData[0].valueForKey("cities") as! NSArray
            city.removeAllObjects()
            city.addObjectsFromArray(curCity as [AnyObject])
            
        }else{
            bankCardNoTextField.text = userDefaults.objectForKey("bankCardNo") as? String
            bankNameTextField.text = userDefaults.objectForKey("bankName") as? String
            bankBranchTextField.text = userDefaults.objectForKey("bankBranch") as? String
            
            var provinceStr = userDefaults.objectForKey("bankProvince") as! String
            var cityStr = userDefaults.objectForKey("bankCity") as! String
            var provinceIndex = 0
            for(var i=0;i<self.province.count;i++){
                if province[i] as! String == provinceStr {
                    provinceIndex = i
                }
            }
            self.ProvincePick.selectRow(provinceIndex, inComponent: 0, animated: true)
            
            var curCity = listData[provinceIndex].valueForKey("cities") as! NSArray
            city.removeAllObjects()
            city.addObjectsFromArray(curCity as [AnyObject])
            
            //var cityIndex = curCity.indexOfObjectIdenticalTo(cityStr!)
            var cityIndex = 0
            for(var i=0;i<self.city.count;i++){
                if city[i] as! String == provinceStr {
                    cityIndex = i
                }
            }
            self.ProvincePick.selectRow(cityIndex, inComponent: 1, animated: true)
            
            
            addTapped.setTitle("修改", forState: UIControlState.Normal)
            self.title = "修改银行卡"
       }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }

    @IBAction func AddTapped(sender: AnyObject) {
        //绑定银行卡
        resignAll()
        var userDefaults = NSUserDefaults.standardUserDefaults()
        var bankCardNoUserDefaults = userDefaults.objectForKey("bankCardNo") as? String
        
        var bankCardNo = bankCardNoTextField.text
        var bankName = bankNameTextField.text
        var bankBranch = bankBranchTextField.text
        
        if bankCardNoUserDefaults == nil || bankCardNoUserDefaults == "" {
            
            if bankCardNo.isEmpty {
                AlertView.showMsg("请输入银行卡账号", parentView: self.view)
                return
            }
            if !Common.isBank(bankCardNo){
                AlertView.showMsg(Common.bankErrorTip, parentView: self.view)
                }
            if bankName.isEmpty {
                AlertView.showMsg("请输入银行名称", parentView: self.view)
                return
            }
            if bankBranch.isEmpty {
                AlertView.showMsg("请输入银行支行", parentView: self.view)
                return
            }
            //其他输入限制再加
            //检查手机网络
    //        var reach = Reachability(hostName: Common.domain)
    //        reach.unreachableBlock = {(r:Reachability!) -> Void in
    //            //NSLog("网络不可用")
    //            dispatch_async(dispatch_get_main_queue(), {
    //                
    //                AlertView.alert("提示", message: "网络连接有问题，请检查手机网络", buttonTitle: "确定", viewController: self)
    //            })
    //        }
            var province = self.province[ProvincePick.selectedRowInComponent(0)] as! String
            var city = self.city[ProvincePick.selectedRowInComponent(1)] as! String
            let manager = AFHTTPRequestOperationManager()
            var url = Common.serverHost + "/App-Ucenter-bindBank"
            var token = userDefaults.objectForKey("token") as! String
            println(token)
            let params = ["to":token,"txt_account":bankCardNo,"bank_name":bankName,"province":province,"city":city,"txt_bankName":bankBranch]
            manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
            loading.startLoading(self.view)
            manager.POST(url, parameters: params,
                 success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                    loading.stopLoading()
                    var result = data as! NSDictionary
                    println("银行卡绑定\(result)")
                    var code = result["code"] as! Int
                    if code == -1 {
                        AlertView.showMsg("请登录后再试", parentView: self.view)
                    }else if code == 0 {
                        AlertView.showMsg(result["message"] as! String, parentView: self.view)
                    }else if code == 200 {
                        
                        AlertView.alert("提示", message: "绑定银行卡成功", buttonTitle: "确定", viewController: self, callback: { (action:UIAlertAction!) -> Void in
                            userDefaults.setObject(bankCardNo, forKey: "bankCardNo")
                            userDefaults.setObject(bankName, forKey: "bankName")
                            userDefaults.setObject(province, forKey: "bankProvince")
                            userDefaults.setObject(city, forKey: "bankCity")
                            userDefaults.setObject(bankBranch, forKey: "bankBranch")
                            self.navigationController?.popViewControllerAnimated(true)
                        })
                        
                    }
                },failure: { (op:AFHTTPRequestOperation!, error:NSError!) -> Void in
                    loading.stopLoading()
                    AlertView.alert("提示", message: "服务器错误", buttonTitle: "确定", viewController: self)
                }
            )
    }
    //修改银行卡账号
    else {
            if bankCardNoTextField.text.isEmpty {
                AlertView.showMsg("请输入银行卡账号", parentView: self.view)
                return
            }
            if bankNameTextField.text.isEmpty {
                AlertView.showMsg("请输入银行名称", parentView: self.view)
                return
            }
            if bankBranchTextField.text.isEmpty {
                AlertView.showMsg("请输入银行支行", parentView: self.view)
                return
            }
            var province = self.province[ProvincePick.selectedRowInComponent(0)] as! String
            var city = self.city[ProvincePick.selectedRowInComponent(1)] as! String
     
            let manager = AFHTTPRequestOperationManager()
            var url = Common.serverHost + "/App-Ucenter-bindBank"
            var token = userDefaults.objectForKey("token") as? String
            var bankCardNo = userDefaults.objectForKey("bankCardNo") as? String
            let params = ["to":token,"txt_account":bankCardNoTextField.text,"bank_name":bankNameTextField.text,"province":province,"city":city,"txt_bankName":bankBranchTextField.text,"txt_oldaccount":bankCardNo]
            loading.startLoading(self.view)
            manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
            manager.POST(url, parameters: params,
            success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                loading.stopLoading()
                var result = data as! NSDictionary
                println("银行卡修改\(result)")
                var code = result["code"] as! Int
                if code == -1 {
                    AlertView.showMsg("请登录后再试", parentView: self.view)
                }else if code == 0 {
                    AlertView.showMsg(result["message"] as! String, parentView: self.view)
                }else if code == 200 {
                    AlertView.alert("提示", message: "绑定银行卡成功", buttonTitle: "确定", viewController: self, callback: { (action:UIAlertAction!) -> Void in
                        userDefaults.setObject(bankCardNo, forKey: "bankCardNo")
                        userDefaults.setObject(bankName, forKey: "bankName")
                        userDefaults.setObject(province, forKey: "bankProvince")
                        userDefaults.setObject(city, forKey: "bankCity")
                        userDefaults.setObject(bankBranch, forKey: "bankBranch")
                        self.navigationController?.popViewControllerAnimated(true)
                    })
           }
    },failure: { (op:AFHTTPRequestOperation!, error:NSError!) -> Void in
        loading.stopLoading()
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
        bankBranchTextField.resignFirstResponder()
    }

}
