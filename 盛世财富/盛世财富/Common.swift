//
//  Common.swift
//  盛世财富
//
//  Created by 云笺 on 15/5/20.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
class Common {
    
    //判断用户是否登录
    class func isLogin() -> Bool {
        if let userName = NSUserDefaults.standardUserDefaults().objectForKey("username") as? String {
            return true
        }
        
        return false
        
    }
    
}