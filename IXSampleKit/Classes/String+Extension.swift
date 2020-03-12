//
//  String+Extension.swift
//  IXSampleKit
//
//  Created by CIFCL on 12/03/20.
//

import Foundation


public extension String{
    
    /// remove white space and new lines
   public var removeWhiteSpace:String{
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
    }
    
    public func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedStringKey.font: font]
        return self.size(withAttributes: fontAttributes)
    }
   public  var prefixPath : String{
        return "/" + self
    }
   public var suffixPath : String{
        return  self + "/"
    }
 
}

