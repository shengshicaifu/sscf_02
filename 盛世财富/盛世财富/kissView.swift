//
//  kissView.swift
//  customerViewDemo
//
//  Created by 莫文琼 on 15/7/2.
//  Copyright (c) 2015年 莫文琼. All rights reserved.
//

import UIKit
/**
*  自定义加载提示视图
*/
class kissView: UIView {
    var l1 = UIView()
    var l2 = UIView()
    
    var frame1:CGRect!
    var frame2:CGRect!
    
    var flag = true
    
    var color:UIColor = UIColor.grayColor()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        l1.frame = CGRectMake(0, 0, self.frame.width, 2)
        l2.frame = CGRectMake(l1.frame.origin.x, l1.frame.origin.y+l1.frame.height+10, self.frame.width, 2)
        
        l1.backgroundColor = color
        l2.backgroundColor = color
        
        frame1 = l1.frame
        frame2 = l2.frame
        
        self.addSubview(l1)
        self.addSubview(l2)
        
        repeat()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    func repeat(){
        UIView.animateWithDuration(0.5, delay:0,usingSpringWithDamping: 0.6,initialSpringVelocity: 0.2,  options: UIViewAnimationOptions.CurveEaseInOut,animations: {
            if self.flag {
                self.l1.frame = CGRectMake(self.frame1.origin.x, self.frame1.origin.y + 10, self.frame1.width, self.frame1.height)
                self.l2.frame = CGRectMake(self.frame2.origin.x, self.frame2.origin.y - 10, self.frame2.width, self.frame2.height)
                self.flag = false
            }else{
                self.l1.frame = self.frame1
                self.l2.frame = self.frame2
                self.flag = true
            }
            
            },completion:{(completed:Bool) -> Void in
                self.repeat()
        })
    }
}
