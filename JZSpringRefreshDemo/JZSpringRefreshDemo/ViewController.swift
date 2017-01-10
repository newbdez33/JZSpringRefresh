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
        
        // top
        let top = self.scrollView!.addSpringRefresh(position: .top) { (v:JZSpringRefresh) in
            print("top")
        }
        top.setText(text: "REFRESH")
        // bottom
        let bottom = self.scrollView!.addSpringRefresh(position: .bottom) { (v:JZSpringRefresh) in
            print("bottom")
        }
        bottom.setSize(size: CGSize(width: 120.0, height: 40.0))
        bottom.setText(text: "Size property customized")
        // left
        let left = self.scrollView!.addSpringRefresh(position: .left) { (v:JZSpringRefresh) in
            print("left")
        }
        left.unExpandedColor = UIColor(red: 0.80, green: 0.93, blue: 0.93, alpha: 1.0)
        left.expandedColor = UIColor(red: 0.50, green: 0.81, blue: 1.0, alpha: 1.0)
        left.readyColor = UIColor(red: 0.00, green: 0.42, blue: 1.0, alpha: 1.0)
        // right
        let right = self.scrollView!.addSpringRefresh(position: .right) { (v:JZSpringRefresh) in
            print("right")
        }
        right.setBorderThickness(borderThickness: 2.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

