//
//  JZSpringRefresh.swift
//  JZSpringRefreshDemo
//
//  Created by JackyZ on 2017/01/09.
//  Copyright © 2017年 Salmonapps. All rights reserved.
//

import UIKit

enum JZSpringRefreshPosition {
    case top
    case bottom
    case left
    case right
}

extension UIScrollView {
    func addSpringRefresh(position:JZSpringRefreshPosition, actionHandlere handler: @escaping (_ springRefresh:JZSpringRefresh) -> Void ) -> JZSpringRefresh {
        
        // Don't add two instance to same position.
        for v in subviews {
            if v is JZSpringRefresh {
                if (v as? JZSpringRefresh)?.position == position {
                    return v as! JZSpringRefresh
                }
            }
        }
        
        let springRefresh = JZSpringRefresh(position: position)
        springRefresh.scrollView = self
        springRefresh.pullToRefreshHandler = handler
        springRefresh.setShowed(show: true)
        addSubview(springRefresh)
        return springRefresh
    }
}

class JZSpringRefresh: UIView {

    var unExpandedColor = UIColor.gray
    var expandedColor = UIColor.black
    var readyColor = UIColor.red
    var text:String? = nil // available for position Top or Bottom.
    var borderThickness = 6.0 // default: 6.0.
    var affordanceMargin:CGFloat = 10.0 // default: 10.0. to adjust space between scrollView edge and affordanceView.
    var offsetMargin = 30.0 // default: 30.0. to adjust threshold of offset.
    var threshold = 0.0 // default is width or height of size.
    var size = CGSize.zero // to adjust expanded size and each interval space.
    private var showed:Bool = false
    var isShowed:Bool {  // dynamic show/hide affordanceView and add/remove KVO observer.
        return showed
    }
    var pullToRefreshHandler:((_ springRefresh:JZSpringRefresh)->Void)? = nil
    private(set) var progress = 0.0
    private(set) var position:JZSpringRefreshPosition = .top
    
    var isUserAction:Bool = false
    var springExpandViews:[JZSpringExpandView] = []
    var scrollView:UIScrollView? = nil
    var label:UILabel = UILabel(frame: CGRect.zero)
    
    // - MARK: init
    init(position:JZSpringRefreshPosition) {
        super.init(frame:CGRect.zero)
        let isSidePosition = position == .left || position == .right
        self.position = position
        size = isSidePosition ? CGSize(width: 40.0, height: 60.0) : CGSize(width: 60.0, height: 40.0)
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-Regular", size: 12.0)
        label.alpha = 0.0
        
        let springExpandView1 = JZSpringExpandView(frame: CGRect.zero)
        springExpandView1.isSidePosition = isSidePosition
        addSubview(springExpandView1)
        
        let springExpandView2 = JZSpringExpandView(frame: CGRect.zero)
        springExpandView2.isSidePosition = isSidePosition
        addSubview(springExpandView2)
        
        let springExpandView3 = JZSpringExpandView(frame: CGRect.zero)
        springExpandView3.isSidePosition = isSidePosition
        addSubview(springExpandView3)
        
        springExpandViews = [springExpandView1, springExpandView2, springExpandView3]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - MARK: override
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch position {
        case .top:
            let frame = CGRect(x: scrollView!.bounds.midX - size.width / 2.0,
                               y: -self.affordanceMargin,
                               width: size.width,
                               height: size.height)
            if self.text != nil {
                label.frame = CGRect(x: (-self.scrollView!.bounds.size.width+self.size.width)/2.0,
                                     y: -20.0,
                                     width: self.scrollView!.frame.size.width,
                                     height: 15.0)
            }
            self.frame = frame
            break
        case .bottom:
            let y = self.scrollView!.contentSize.height;
            self.frame = CGRect(x:self.scrollView!.bounds.midX - (self.size.width / 2.0),
                                y: y + self.affordanceMargin,
                                width: self.size.width,
                                height: self.size.height);
            if (self.text != nil) {
                self.label.frame = CGRect(x: (-self.scrollView!.bounds.size.width+self.size.width)/2.0,
                                          y: -20.0,
                                          width: self.scrollView!.frame.size.width,
                                          height: 15.0);
            }
            if self.frame.origin.y > 100.0 {
                self.alpha = 1.0;
            }
            break
        case .left:
            self.frame = CGRect(x: -self.affordanceMargin,
                                y: self.scrollView!.bounds.midY - (self.size.height / 2.0),
                                width: self.size.width,
                                height: self.size.height)
            break
        case .right:
            let x = max(self.scrollView!.bounds.size.width, self.scrollView!.contentSize.width);
            self.frame = CGRect(x: x + self.affordanceMargin,
                                y: (self.scrollView!.bounds.midY) - (self.size.height / 2.0),
                                width: self.size.width,
                                height: self.size.height);
            break
        }
        
        //let isSidePosition = (self.position == .left || self.position == .right)
        //magic number is a ture magic (isSidePosition) ? 40.0 : 40.0
        let interItemSpace:Double = (40.0) / Double(self.springExpandViews.count)
        
        // layout affordance.
        var index:Double = 0.0
        for springExpandView in springExpandViews {
            switch self.position {
            case .top:
                springExpandView.frame = CGRect(x: 0.0, y: -interItemSpace * index, width: Double(self.bounds.width), height: self.borderThickness);
                break;
            case .bottom:
                springExpandView.frame = CGRect(x: 0.0, y: interItemSpace * index, width: Double(self.bounds.width), height: self.borderThickness);
                break;
            case .left:
                springExpandView.frame = CGRect(x: -interItemSpace * index, y: 0.0, width: self.borderThickness, height: Double(self.bounds.height));
                break;
            case .right:
                springExpandView.frame = CGRect(x: interItemSpace * index, y: 0.0, width: self.borderThickness, height: Double(self.bounds.height));
                break;
            }
            index += 1
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if self.superview != nil && newSuperview == nil {
            if isShowed {
                self.showed = false
            }
        }
    }
    
    // - MARK: KVO
    
    // - MARK: setter
    func setShowed(show:Bool) {
        
    }
    
}

