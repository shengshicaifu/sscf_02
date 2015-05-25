//
//  UserGuideViewController.swift
//  盛世财富
//  用户引导页
//  Created by 云笺 on 15/5/25.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit

class UserGuideViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var viewWidth = self.view.frame.width
        var viewHeight = self.view.frame.height
        
        var scrollView = UIScrollView(frame: CGRectMake(0, 0, viewWidth, viewHeight))
        scrollView.contentSize = CGSizeMake(viewWidth * 2, viewHeight)
        scrollView.pagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        
        var guideImage1 = UIImageView(frame: CGRectMake(0, 0, viewWidth, viewHeight))
        guideImage1.image = UIImage(named: "guide_1.jpg")
        scrollView.addSubview(guideImage1)
        
        var guideImage2 = UIImageView(frame: CGRectMake(viewWidth, 0, viewWidth, viewHeight))
        guideImage2.image = UIImage(named: "guide_2.jpg")
        guideImage2.userInteractionEnabled = true
        
        var startButton = UIButton(frame: CGRectMake((viewWidth-120)/2, viewHeight - 100, 120, 40))
        startButton.setTitle("立即开始", forState: UIControlState.Normal)
        startButton.layer.cornerRadius = 20
        startButton.backgroundColor = UIColor(red: 242/255.0, green: 37/255.0, blue: 95/255.0, alpha: 1.0)
        startButton.addTarget(self, action: "toRootView", forControlEvents: UIControlEvents.TouchUpInside)
        guideImage2.addSubview(startButton)
        
        scrollView.addSubview(guideImage2)
        
        self.view.addSubview(scrollView)
        
    }
    
    func toRootView(){
        var tabBarViewController = self.storyboard?.instantiateViewControllerWithIdentifier("tabBarViewController") as! TabBarViewController
        self.presentViewController(tabBarViewController, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
