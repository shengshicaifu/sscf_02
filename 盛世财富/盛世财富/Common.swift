//
//  Common.swift
//  盛世财富
//  公共方法
//  Created by 云笺 on 15/5/20.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
/**
*  系统公共方法类
*/
class Common {
    
    /**
    判断用户是否登录
    
    :returns: true表示登录，false表示未登录
    */
    class func isLogin() -> Bool {
        if let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String {
            return true
        }
        
        return false
        
    }
    //MARK:- 系统常量
    /// 转接服务器地址
    static let serverHost:String = "http://www.sscf88.com"//"http://61.183.178.86:10888/MidServer"
    //
    static let domain:String = "www.baidu.com"
    
    
    //MARK:- 正则表达式验证

    //是否合法用户名
    static let userNameErrorTip:String = "用户名为英文字母和数字，长度在6到20之间"
    
    class func isUserName(userName:String) -> Bool {
        var regex = "(^[A-Za-z0-9]{6,20}$)"
        var pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluateWithObject(userName)
    }
    
    static let passwordErrorTip:String = "密码为英文字母和数字，长度在6到20之间"
    //是否合法密码
    class func isPassword(password:String) -> Bool {
        var regex = "(^[A-Za-z0-9]{6,20}$)"
        var pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluateWithObject(password)
    }
    
    static let telephoneErrorTip:String = "手机号码无效"
    //是否是手机号码
    class func isTelephone(telephone:String) -> Bool {
        var regex = "^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$"
        var pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluateWithObject(telephone)
    }

    static let moneyErrorTip:String = "金额为最多两位小数的数字"
    //是否是最多两位小数的金额
    class func isMoney(money:String) -> Bool {
        var regex = "^(([1-9]\\d{0,9})|0)(\\.\\d{1,2})?$"
        var pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluateWithObject(money)
    }
    static let bankErrorTip:String = "银行卡号不正确"
    //是否最低8位数
    class func isBank(bankCardNo:String) ->Bool {
        var regex = "^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$"
        var pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluateWithObject(bankCardNo)
    }
    
    static let stringLengthInErrorTip:String = "字符串长度不在指定的区间内"
    
    /**
    任意字符串是否在指定的长度范围内，闭区间
    
    :param: str   待测试字符串
    :param: start 长度区间开始数
    :param: end   长度区间截至数
    
    :returns: true待测试字符串在指定的长度范围内；false待测试字符串不在指定的长度范围内
    */
    class func stringLengthIn(str:String,start:Int,end:Int) -> Bool {
        var regex = "^.{\(start),\(end)}$"
        var pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluateWithObject(str)
    }
    //MARK:- 字符串操作
    /**
    将指定位置的字符替换为*
    
    :param: str   待处理的字符串
    :param: start 开始位置
    :param: end   结束为止
    
    :returns: 处理后的字符串
    */
    class func replaceStringToX(str:NSString,start:Int,end:Int) -> String{
        if str.length < start {
            return "****"
        }
        var f = str.substringToIndex(start)
        var e = str.substringFromIndex(end)
        return f + "****" + e
    }

    //MARK:- 时间处理
    /**
    将时间戳转换为yyyy-MM-dd HH:mm:ss格式的时间字符串
    
    :param: timestamp 待转换的时间戳
    
    :returns:yyyy-MM-dd HH:mm:ss格式的时间字符串
    */
    class func dateFromTimestamp(timestamp:Double) -> String{
        var date = NSDate(timeIntervalSince1970: timestamp)
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.stringFromDate(date)
    }
    //MARK:- 时间处理
    /**
    将时间戳转换为MM-dd HH:mm格式的时间字符串
    
    :param: timestamp 待转换的时间戳
    
    :returns:MM-dd HH:mm格式的时间字符串
    */
    class func twoDateFromTimestamp(timestamp:Double) -> String{
        var date = NSDate(timeIntervalSince1970: timestamp)
        var formatter = NSDateFormatter()
        formatter.dateFormat = "MM-dd HH:mm"
        return formatter.stringFromDate(date)
    }

    
}
//MARK:- md5
extension String {
    var md5 : NSString{
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen);
        
        CC_MD5(str!, strLen, result);
        
        var hash = NSMutableString();
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i]);
        }
        result.destroy();
        
        return String(format: hash as String)
    }
}
