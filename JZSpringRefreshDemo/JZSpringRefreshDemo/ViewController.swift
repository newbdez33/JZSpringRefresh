//
//  ViewController.swift
//  JZSpringRefreshDemo
//
//  Created by JackyZ on 2017/01/09.
//  Copyright © 2017年 Salmonapps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var scrollView:UIScrollView? = nil
    var textView:UITextView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView(frame: self.view.bounds)
        scrollView?.backgroundColor = UIColor.white
        scrollView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView?.alwaysBounceHorizontal = true
        scrollView?.alwaysBounceVertical = true
        scrollView?.contentSize = view.bounds.size
        view.addSubview(scrollView!)
        
        textView = UITextView(frame: view.bounds, textContainer: nil)
        textView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textView?.textContainerInset = UIEdgeInsetsMake(40, 20, 20, 20)
        textView?.font = UIFont(name: "AvenirNext-Regular", size: 16)
        textView?.textColor = UIColor.darkGray
        textView?.isEditable = false
        textView?.text = "AASpringRefresh\n\n AASpringRefresh is Unread.app like pull-to-refresh library that can put to 4 direction (top/bottom/left/right).\n\n License under the MIT License."
        scrollView?.addSubview(textView!)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

