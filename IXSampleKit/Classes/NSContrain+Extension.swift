//
//  NSContrain+Extension.swift
//  IXSampleKit
//
//  Created by CIFCL on 12/03/20.
//

import UIKit


public extension UIView{
    /// set parent layout to child view
    ///
    /// - Parameter edge: set margin between parent and child
    public func parentLayout(_ edge:UIEdgeInsets=UIEdgeInsets.zero) {
        guard let parentView = self.superview else {
            assert(false, "please add subview")
            return
        }

        self.translatesAutoresizingMaskIntoConstraints = false
        //Some Issue in No Internet Connection view, So, Changing to anchor based
        let metric = ["left":edge.left,"top":edge.top,"right":edge.right,"bottom":edge.bottom]
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-left-[self]-right-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: metric, views: ["self" : self]))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-top-[self]-bottom-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: metric, views: ["self" : self]))
    }
    
    /// <#Description#>
    ///
    /// - Parameter padding: <#padding description#>
    public func center( _ padding:CGPoint=CGPoint.zero){
        guard let parentView = self.superview else {
            assert(false, "please add subview")
            return
        }
        parentView.addConstraint(NSLayoutConstraint.init(item: self, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: parentView, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: padding.x))
        parentView.addConstraint(NSLayoutConstraint.init(item: self, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: parentView, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: padding.y))
    }
    
    /// <#Description#>
    ///
    /// - Parameter constant: <#constant description#>
    /// - Returns: <#return value description#>
    @discardableResult public func setParentLayout(_ layout:NSLayoutAttribute, _ constant:CGFloat=0.0, _ multiplier:CGFloat=1.0)->NSLayoutConstraint{
        assert(self.superview != nil, "please add subview")
        let parentView = self.superview!
        self.translatesAutoresizingMaskIntoConstraints = false

        let layout = NSLayoutConstraint.init(item: self, attribute: layout, relatedBy: NSLayoutRelation.equal, toItem: parentView, attribute: layout, multiplier: multiplier, constant: constant)
        parentView.addConstraint(layout)
        return layout
    }
    
    /// <#Description#>
    ///
    /// - Parameter constant: <#constant description#>
    /// - Returns: <#return value description#>
    @discardableResult public func setSelfLayout( _ layout:NSLayoutAttribute, _ constant:CGFloat=0.0)->NSLayoutConstraint{
        assert(self.superview != nil, "please add subview")
        let parentView = self.superview!
        self.translatesAutoresizingMaskIntoConstraints = false

        let layout = NSLayoutConstraint.init(item: self, attribute: layout, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: constant)
        parentView.addConstraint(layout)
        return layout
    }
}
