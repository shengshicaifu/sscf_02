//
//  Constant.swift
//  盛世财富
//  定义系统的常量
//  Created by 莫文琼 on 15-5-10.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
class Constant{
    //let ServerHost = "http://61.183.178.86:10888"
    //内网：http://192.168.1.253:8080
    //外网：http://61.183.178.86:10888
    //http://www.sscf88.com
    class func getServerHost() -> String {
        return "http://61.183.178.86:10888/MidServer"
    }
    class func getDomain() -> String {
        return "www.baidu.com"
    }
}