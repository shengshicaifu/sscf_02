//
//  EmptyView.swift
//  study
//
//  Created by 肖典 on 15/6/10.
//  Copyright (c) 2015年 xiao. All rights reserved.
//

import UIKit

class EmptyView {
    class func showEmptyView(view:UIView){
        let emptyView = UIView(frame: view.frame)
        emptyView.backgroundColor = UIColor.grayColor()
        let label = UILabel(frame: CGRect(x: (emptyView.frame.width-300)/2, y: 100, width: 300, height: 100))
        label.textAlignment = NSTextAlignment.Center
        label.text = "暂无记录"
        emptyView.addSubview(label)
        view.addSubview(emptyView) 
    }
    
}
