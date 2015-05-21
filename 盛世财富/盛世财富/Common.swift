//
//  Common.swift
//  盛世财富
//  公共方法
//  Created by 云笺 on 15/5/20.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
class Common {
    
    //用户是否登录
    class func isLogin() -> Bool {
        if let userName = NSUserDefaults.standardUserDefaults().objectForKey("username") as? String {
            return true
        }
        
        return false
        
    }
    
    //是否合法用户名
    class func isUserName(userName:String) -> Bool {
        var regex = "(^[A-Za-z0-9]{6,20}$)"
        var pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluateWithObject(userName)
    }
    
    //是否合法密码
    class func isPassword(password:String) -> Bool {
        var regex = "(^[A-Za-z0-9]{6,20}$)"
        var pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluateWithObject(password)
    }
    
    //是否是手机号码
    class func isTelephone(telephone:String) -> Bool {
        var regex = "^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$"
        var pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluateWithObject(telephone)
    }
    
    //是否是最多两位小数的金额
    class func isMoney(money:String) -> Bool {
        var regex = "^(([1-9]\\d{0,9})|0)(\\.\\d{1,2})?$"
        var pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluateWithObject(money)
    }
    
    //任意字符串是否在指定的长度范围内，闭区间
    class func lengthIn(str:String,start:Int,end:Int) -> Bool {
        var regex = "^.{\(start),\(end)}$"
        var pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluateWithObject(str)
    }
    
}