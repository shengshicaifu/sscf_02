
//
//  AlertView.swift
//  盛世财富
//  Alert和Toast框
//  Created by 肖典 on 15/5/8.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
/**
*  系统使用弹框
*/
class AlertView {
    /**
    提示信息框，3秒后自动消失
    
    :param: msg        “提示信息”
    :param: parentView “展现该提示信息框的父视图”
    */
    class func showMsg(msg:String,parentView:UIView){
        
//        var hintLabel = UILabel()
//        hintLabel.textAlignment = NSTextAlignment.Center
//        hintLabel.backgroundColor = UIColor.blackColor()
//        hintLabel.layer.masksToBounds = true
//        hintLabel.layer.cornerRadius = 10.0
//        hintLabel.alpha = 0.0
//        hintLabel.text = msg
//        hintLabel.textColor = UIColor.whiteColor()
//        hintLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
//        hintLabel.numberOfLines = 0
//        hintLabel.sizeToFit()
//    
//        hintLabel.frame = CGRectMake(parentView.frame.size.width/2-80, parentView.frame.size.height-100, 160, 30)
//        parentView.addSubview(hintLabel)
//        
//        UIView.animateWithDuration(1.0, delay: 0.0, options: nil, animations: {
//            hintLabel.alpha = 1
//            }, completion: {(finished:Bool) -> Void in
//                NSThread.sleepForTimeInterval(2)
//                hintLabel.removeFromSuperview()
//        })
        //CSToastDisplayShadow ＝ false
        var screenBounds = UIScreen.mainScreen().bounds
        var x = screenBounds.width / 2
        var y = screenBounds.height / 2
        var position = NSValue(CGPoint: CGPointMake(x, y))
        
        parentView.makeToast(msg, duration: 3, position: position)
    }
    /**
    模态提示框
    
    :param: title          “对话框标题”
    :param: message        “提示信息”
    :param: buttonTitle    “按钮标题”
    :param: viewController “展示该对话框的控制器”
    */
    class func alert(title:String,message:String,buttonTitle:String,viewController:UIViewController){
        var alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .Cancel, handler: nil))
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    /**
    模态提示框,带回调函数
    
    :param: title          “对话框标题”
    :param: message        “提示信息”
    :param: buttonTitle    “按钮标题”
    :param: viewController “展示该对话框的控制器”
    :param: callback       “点击按钮的回调函数”
    */
    class func alert(title:String,message:String,buttonTitle:String,viewController:UIViewController,callback:((UIAlertAction!) -> Void)!){
        var alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .Cancel, handler: callback))
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    /**
    模态提示框,带回调函数
    
    :param: title             “对话框标题”
    :param: message           “提示信息”
    :param: okButtonTitle     “ok按钮标题”
    :param: cancelButtonTitle “cancel按钮标题”
    :param: viewController    “展示该对话框的控制器”
    :param: okCallback        “点击ok按钮的回调函数”
    :param: cancelCallback    “点击cancel按钮的回调函数”
    */
    class func alert(title:String,message:String,okButtonTitle:String,cancelButtonTitle:String,viewController:UIViewController,okCallback:((UIAlertAction!) -> Void)!,cancelCallback:((UIAlertAction!) -> Void)!){
        var alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: okButtonTitle, style: UIAlertActionStyle.Default, handler: okCallback))
        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: UIAlertActionStyle.Cancel, handler: cancelCallback))
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
}