//
//  JZSpringExpandView.swift
//  JZSpringRefreshDemo
//
//  Created by JackyZ on 2017/01/09.
//  Copyright © 2017年 Salmonapps. All rights reserved.
//

import UIKit

class JZSpringExpandView: UIView {

    var isSidePosition:Bool = false
    private var expended:Bool = false
    var isExpanded:Bool {
        return expended
    }
    
    let stretchingView:UIView = UIView(frame: CGRect.zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(stretchingView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureViewsForExpandedState(expanded: isExpanded, animated: false)
        stretchingView.layer.cornerRadius = isSidePosition ? stretchingView.bounds.midX : stretchingView.bounds.maxY
    }
    
    // - MARK: Public
    func setExpanded(expanded:Bool, animated:Bool) {
        if isExpanded != expanded {
            configureViewsForExpandedState(expanded: expanded, animated: animated)
        }
    }
    
    func setColor(color:UIColor) {
        stretchingView.backgroundColor = color
    }

    // - MARK: Private
    func configureViewsForExpandedState(expanded:Bool, animated:Bool) {
        
        if expanded {
            expandAnimated(animated: animated)
        }else {
            collapseAnimated(animated: animated)
        }
    }
    
    func expandAnimated(animated:Bool) {
        let expandBlock = { () -> Void in
            self.stretchingView.frame = self.frameForExpandedState()
            self.expended = true
        }
        
        if animated {
            performBlockInAnimation(blockToAnimate: expandBlock)
        }else {
            expandBlock()
        }
    }
    
    func collapseAnimated(animated:Bool) {
        let collapseBlock = { () -> Void in
            self.stretchingView.frame = self.frameForCollapsedState()
            self.expended = false
        }
        
        if animated {
            performBlockInAnimation(blockToAnimate: collapseBlock)
        }else {
            collapseBlock()
        }
    }
    
    func performBlockInAnimation(blockToAnimate: @escaping () -> () ) {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.55, initialSpringVelocity: 0.4, options: [.beginFromCurrentState], animations: { 
            blockToAnimate()
        }, completion: nil)
    }
    
    // - MARK: Helpers
    func frameForCollapsedState() -> CGRect {
        if isSidePosition {
            return CGRect(x: 0.0,
                          y: bounds.midY - bounds.width / 2.0,
                          width: bounds.width,
                          height: bounds.width)
        } else {
            return CGRect(x: bounds.midX - bounds.height / 2.0,
                          y: 0.0,
                          width: bounds.height,
                          height: bounds.height)
        }
    }
    
    func frameForExpandedState() -> CGRect {
        if isSidePosition {
            return CGRect(x: 0.0,
                          y: 0.0,
                          width: bounds.width / 2.0,
                          height: bounds.height)
        } else {
            return CGRect(x: 0.0,
                          y: 0.0,
                          width: bounds.width,
                          height: bounds.height / 2.0)
        }
    }
}
