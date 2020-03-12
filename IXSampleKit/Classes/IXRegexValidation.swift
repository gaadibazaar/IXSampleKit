//
//  IXRegexValidation.swift
//  IXSampleKit
//
//  Created by CIFCL on 12/03/20.
//

import Foundation


/// IXRegexValidation, It's help to validate text, based on regular expression
public struct IXRegexValidation:Equatable{
    //regex text
    public var rawValue:String!
    
    /// contructor to create regex based validation
    ///
    /// - Parameter rawValue: regex expression
    public init(rawValue:String) {
        self.rawValue = rawValue
    }
    
    /// Equatable to two object, compare using regex expression
    ///
    /// - Parameters:
    ///   - lhs: comparing rawvalue
    ///   - rhs: comparing rawvalue
    /// - Returns: is both are same, retue true
    public static func == (lhs: IXRegexValidation, rhs: IXRegexValidation) -> Bool {
        return lhs.rawValue == rhs.rawValue
        
    }
}


// MARK: -  Defined Regex expression Validation
extension IXRegexValidation{
    public static var email = IXRegexValidation.init(rawValue: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    public static var panNumber = IXRegexValidation.init(rawValue: "[A-Z]{5}[0-9]{4}[A-Z]{1}")
    public static var alphaNumeric = IXRegexValidation.init(rawValue: "[a-zA-Z0-9]*")
    public static var alphabet = IXRegexValidation.init(rawValue: "[a-zA-Z]*")
    public static var alphabetWithSpace = IXRegexValidation.init(rawValue: "[a-zA-Z\\s]*")
    public static var numeric = IXRegexValidation.init(rawValue: "[0-9]*")
    public static var isNotEmpty = IXRegexValidation.init(rawValue: "^.{1,}$")
    public static func minLength(_ length:Int)->IXRegexValidation{
        return IXRegexValidation.init(rawValue:"^.{\(length),}$")
    }
    public static func maxLength(_ length:Int)->IXRegexValidation{
        return IXRegexValidation.init(rawValue:"^.{0,\(length)}$")
    }
    public static func restricedLength(_ from:Int,to:Int)->IXRegexValidation{
        return IXRegexValidation.init(rawValue:"^.{\(from),\(to)}$")
    }
}


// MARK: - NSRegularExpression
public extension NSRegularExpression{
    
    /// evalute regex expression to true or false using predicate->evaluate (SELF MATCHES %@)
    class public func evaluate(text:String, regex:String)->Bool{
        let regex = NSPredicate.init(format: "SELF MATCHES %@", regex)
        return regex.evaluate(with:text)
    }
}


