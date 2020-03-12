//
//  UIImageView+Extension.swift
//  IXSampleKit
//
//  Created by CIFCL on 12/03/20.
//


import UIKit


public extension UIImageView{
    
    func changeImageTint(_ color: UIColor){
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
}
