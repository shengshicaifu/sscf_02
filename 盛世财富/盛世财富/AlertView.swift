
//
//  AlertView.swift
//  盛世财富
//
//  Created by 肖典 on 15/5/8.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation

class AlertView {
    class func showMsg(msg:String,parentView:UIView){
        var hintLabel = UILabel(frame: CGRectMake(parentView.frame.size.width/2-80, parentView.frame.size.height-100, 160, 30))
        hintLabel.textAlignment = NSTextAlignment.Center
        
        hintLabel.backgroundColor = UIColor.blackColor()
        hintLabel.layer.masksToBounds = true
        hintLabel.layer.cornerRadius = 10.0
        hintLabel.alpha = 0.0
        hintLabel.text = msg
        hintLabel.textColor = UIColor.whiteColor()
        
        parentView.addSubview(hintLabel)
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: nil, animations: {
            hintLabel.alpha = 1
            }, completion: {(finished:Bool) -> Void in
                NSThread.sleepForTimeInterval(2)
                hintLabel.removeFromSuperview()
        })
    }
    
    class func alert(title:String,message:String,buttonTitle:String,viewController:UIViewController){
        var alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .Cancel, handler: nil))
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
}