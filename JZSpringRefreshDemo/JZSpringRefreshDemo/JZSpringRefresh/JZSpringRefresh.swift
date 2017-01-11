//
//  JZSpringRefresh.swift
//  JZSpringRefreshDemo
//
//  Created by JackyZ on 2017/01/09.
//  Copyright © 2017年 Salmonapps. All rights reserved.
//

import UIKit

public enum JZSpringRefreshPosition {
    case top
    case bottom
    case left
    case right
}

public extension UIScrollView {
    public func addSpringRefresh(position:JZSpringRefreshPosition, actionHandlere handler: @escaping (_ springRefresh:JZSpringRefresh) -> Void ) -> JZSpringRefresh {
        
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
        springRefresh.showed = true
        addSubview(springRefresh)
        return springRefresh
    }
}

public class JZSpringRefresh: UIView {

    public var unExpandedColor = UIColor.gray
    public var expandedColor = UIColor.black
    public var readyColor = UIColor.red
    public var text:String? = nil {
        didSet {
            if text != "" && ( self.position == .top || self.position == .bottom ) {
                // dont add multiple margin per change text.
                if oldValue == nil {
                    self.affordanceMargin = self.affordanceMargin + 20.0
                }
                self.label.text = text
                self.addSubview(self.label)
            } else {
                if self.text != nil {
                    self.affordanceMargin = self.affordanceMargin - 20.0
                }
                self.label.removeFromSuperview()
            }
            self.setNeedsLayout()
        }
    }// available for position Top or Bottom.
    public var borderThickness:CGFloat = 6.0 {
        didSet {
            self.setNeedsLayout()
        }
    } // default: 6.0.
    public var affordanceMargin:CGFloat = 10.0 // default: 10.0. to adjust space between scrollView edge and affordanceView.
    public var offsetMargin:CGFloat = 30.0 // default: 30.0. to adjust threshold of offset.
    public var threshold:CGFloat = 0.0 // default is width or height of size.
    public var size = CGSize.zero {
        didSet {
            self.setNeedsLayout()
        }
    } // to adjust expanded size and each interval space.
    public var showed:Bool = false {
        didSet {
            self.isHidden = !showed
            if self.showed != oldValue {
                if showed {
                    self.scrollView!.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
                    self.scrollView!.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
                    self.scrollView!.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
                }else {
                    self.scrollView!.removeObserver(self, forKeyPath: "contentOffset")
                    self.scrollView!.removeObserver(self, forKeyPath: "contentSize")
                    self.scrollView!.removeObserver(self, forKeyPath: "frame")
                }
            }
        }
    }
    public var isShowed:Bool {  // dynamic show/hide affordanceView and add/remove KVO observer.
        return showed
    }
    public var pullToRefreshHandler:((_ springRefresh:JZSpringRefresh)->Void)? = nil
    public var progress:CGFloat = 0.0 {

        didSet {
            var p:CGFloat = 0.0
            if progress > 0 {
                p = progress
            }
            let progressInterval = 1.0 / CGFloat(self.springExpandViews.count)
            var index = 1
            for springExpandView in self.springExpandViews {
                let expanded = (CGFloat(index) * progressInterval) <= p
                if p >= 1.0 {
                    springExpandView.setColor(color: self.readyColor)
                    self.label.textColor = self.readyColor
                } else if (expanded) {
                    springExpandView.setColor(color: expandedColor)
                } else {
                    springExpandView.setColor(color: self.unExpandedColor)
                    self.label.textColor = self.expandedColor
                }
                springExpandView.setExpanded(expanded: expanded, animated: true)
                index += 1
            }
        }
    }
    private(set) var position:JZSpringRefreshPosition = .top
    
    public var isUserAction:Bool = false
    var springExpandViews:[JZSpringExpandView] = []
    var scrollView:UIScrollView? = nil
    public var label:UILabel = UILabel(frame: CGRect.zero)
    
    // - MARK: init
    public init(position:JZSpringRefreshPosition) {
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
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - MARK: override
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        switch position {
        case .top:
            let frame = CGRect(x: scrollView!.bounds.midX - size.width / 2.0,
                               y: -self.affordanceMargin,
                               width: size.width,
                               height: size.height)
            if self.text != nil {
                label.frame = CGRect(x: (-self.scrollView!.bounds.size.width+self.size.width)/2.0,
                                     y: 5,
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
                springExpandView.frame = CGRect(x: 0.0, y: -interItemSpace * index, width: Double(self.bounds.width), height: Double(self.borderThickness));
                break;
            case .bottom:
                springExpandView.frame = CGRect(x: 0.0, y: interItemSpace * index, width: Double(self.bounds.width), height: Double(self.borderThickness));
                break;
            case .left:
                springExpandView.frame = CGRect(x: -interItemSpace * index, y: 0.0, width: Double(self.borderThickness), height: Double(self.bounds.height));
                break;
            case .right:
                springExpandView.frame = CGRect(x: interItemSpace * index, y: 0.0, width: Double(self.borderThickness), height: Double(self.bounds.height));
                break;
            }
            index += 1
        }
    }
    
    override public func willMove(toSuperview newSuperview: UIView?) {
        if self.superview != nil && newSuperview == nil {
            if isShowed {
                self.showed = false
            }
        }
    }
    
    // - MARK: KVO
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            if change == nil  {
                return
            }
            guard let v = change?[.newKey] as? NSValue else {
                return
            }
            self.scrollViewDidScroll(contentOffset: v.cgPointValue)
        } else if (keyPath == "contentSize") {
            self.setNeedsLayout()
        } else if (keyPath == "frame") {
            self.setNeedsLayout()
        }
    }
    
    func scrollViewDidScroll(contentOffset:CGPoint) {
        
        if self.scrollView == nil {
            return
        }
        
        // Do Action prev progress value.
        if self.isUserAction && !self.scrollView!.isDragging && !self.scrollView!.isZooming && self.progress > 0.99  {
            if self.pullToRefreshHandler != nil {
                self.pullToRefreshHandler!(self)
            }
        }
        
        let yOffset = contentOffset.y
        let xOffset = contentOffset.x
        
        switch self.position {
        case .top:
            let threshold = self.threshold != 0 ? self.threshold : self.bounds.height
            self.progress = (-yOffset - self.offsetMargin - self.scrollView!.contentInset.top) / threshold
            if self.text != nil {
                self.label.alpha = (-yOffset - self.scrollView!.contentInset.top) / 40.0
            }
            self.alpha = (-yOffset - self.scrollView!.contentInset.top) / 40.0
            break
        case .bottom:
            var overBottomOffsetY = yOffset
            let threshold = self.threshold != 0 ? self.threshold : self.bounds.height
            if self.scrollView!.contentSize.height > self.scrollView!.frame.size.height {
                overBottomOffsetY += -self.scrollView!.contentSize.height + self.scrollView!.frame.size.height
                self.progress = (overBottomOffsetY - self.offsetMargin - self.scrollView!.contentInset.bottom) / threshold
                if self.text != nil {
                    self.label.alpha = (overBottomOffsetY - self.scrollView!.contentInset.bottom) / threshold
                }
            }else {
                overBottomOffsetY += 20.0 + self.scrollView!.contentInset.bottom
                self.progress = (overBottomOffsetY - self.offsetMargin) / threshold
                if self.text != nil {
                    self.label.alpha = (overBottomOffsetY) / threshold
                }
            }
            break
        case .left:
            let threshold = self.threshold != 0 ? self.threshold : self.bounds.width;
            self.progress = (-xOffset - self.offsetMargin) / threshold;
            break
        case .right:
            let rightEdgeOffset = self.scrollView!.contentSize.width - self.scrollView!.bounds.size.width;
            let threshold = self.threshold != 0 ? self.threshold : self.bounds.width;
            self.progress = (xOffset - rightEdgeOffset - self.offsetMargin) / threshold;
            break
        }
        
        self.isUserAction = self.scrollView!.isDragging
    }
    
}

