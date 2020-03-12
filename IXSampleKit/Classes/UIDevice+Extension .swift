//
//  UIDevice+Extension .swift
//  IXSampleKit
//
//  Created by CIFCL on 12/03/20.
//

import UIKit

public enum DeviceModel:CustomStringConvertible {
    
    case none,se,normal,plus,x
    
    public var description: String{
        switch self {
        case .se:
            return "iPhone 5 or 5S or 5C"
        case .normal:
            return "iPhone 6/6S/7/8"
        case .plus:
            return "iPhone 6+/6S+/7+/8+"
        case .x:
            return "iPhone X"
        default:
            return "none"
        }
    }
}
public extension UIDevice{
    
    var deviceModel:DeviceModel{
//        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136,640:
                return .se
            case 1334:
                return .normal
            case 1920, 2208:
                return .plus
            case 2436:
                return .x
            default:
                return .none
            }
//        }
    }
}
