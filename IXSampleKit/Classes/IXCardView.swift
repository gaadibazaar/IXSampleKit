//
//  IXCardView.swift
//  IXSampleKit
//
//  Created by CIFCL on 12/03/20.
//

import UIKit

@IBDesignable open class IXCardView: UIView {

    
    @IBInspectable open var cornerRadius: CGFloat = 2{
        didSet{
            self.layoutSubviews()
         }
    }
    @IBInspectable open var borderWidth: CGFloat = 0 {
        didSet{
            self.layoutSubviews()
         }
    }
    @IBInspectable open var borderColor: UIColor? = UIColor.black{
        didSet{
            self.layoutSubviews()
         }
    }

    @IBInspectable open var shadowOffsetWidth: CGFloat = 0{
        didSet{
            self.layoutSubviews()
         }
    }
    @IBInspectable open var shadowOffsetHeight: CGFloat = 3{
        didSet{
            self.layoutSubviews()
         }
    }
    @IBInspectable open var shadowColor: UIColor? = UIColor.black{
        didSet{
            self.layoutSubviews()
         }
    }
    @IBInspectable open var shadowOpacity: CGFloat = 0.5{
        didSet{
            self.layoutSubviews()
         }
    }

    /// enable IXCardView shadow
    @IBInspectable var masksToBounds = false

    public override init(frame:CGRect) {
        super.init(frame:frame)
        self.setNeedsLayout()
    }
    
   public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
         self.setNeedsLayout()
    }
    override open  func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
        
        /// adjust full layer of shadow
        let roundedRect = CGRect.init(origin: CGPoint.init(x: -(shadowOffsetWidth/2), y: -(shadowOffsetHeight/2)), size: bounds.size)
        let shadowPath = UIBezierPath(roundedRect: roundedRect, cornerRadius: cornerRadius)
        layer.masksToBounds = masksToBounds
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = Float(shadowOpacity)
        layer.shadowPath = shadowPath.cgPath
        
    }

}



