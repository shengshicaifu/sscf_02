//
//  TransRecordViewController.swift
//  盛世财富
//
//  Created by zengchang on 15-3-17.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit

class ShowAlertView {
    
    var timer:NSTimer = NSTimer()
    var flag:Bool = false
    var time:Int = 0
    
    func practice(){
        var arr = NSMutableArray()
        arr.addObject("abc")
        arr.addObject(true)
        arr.addObject(Array<String>())
        arr.addObject(1)
        arr.addObject("a")
        arr.addObject(["abc"])
        
        for temp in arr{
            println(temp)
        }
        
        var arr1 = ["abc"]
        arr1[0] = "aaa"
        arr1[1] = "bbb"
        println(arr1.count)
    }
    
    class func hideAlertView(inout flag:Bool,inout time:Int,view:UIView){
        if flag {
            time++
            if time >= 30 {
                FVCustomAlertView.shareInstance.hideAlertFromView(view, fading: true)
                time = 0
                flag = false
            }
        }
    }
    
    class func startTimer(inout timer:NSTimer,uvc:UIViewController){
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: uvc, selector: "hideAlertView", userInfo: nil, repeats: true)
    }
    
    class func getInfo() -> String {
        var sp = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,  NSSearchPathDomainMask.AllDomainsMask, true)
        
        if sp.count > 0{
            var url = NSURL(fileURLWithPath: "\(sp[0])/data.txt")
            println("url:\((url?.path)!)")
            
            //写出文件
            var data = NSMutableData()
            data.appendData("Hello Swift".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
            data.writeToFile((url?.path)!, atomically: true)
            println("write end ...")
            
            //读入文件
            var str = NSString(contentsOfFile: (url?.path)!, encoding: NSUTF8StringEncoding, error: nil)
//            println("content:\(str!)")
            return str!
        }
        
        return ""
    }
}
