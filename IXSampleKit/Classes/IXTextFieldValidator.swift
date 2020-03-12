//
//  IXTextFieldValidator.swift
//  IXSampleKit
//
//  Created by CIFCL on 12/03/20.
//

import Foundation


/// <#Description#>
open class IXTextFieldValidator{
    
    /// <#Description#>
    public var errorMessage:String?
    
    /// <#Description#>
    public var rule : IXRegexValidation!
    
    /// <#Description#>
    public var optinal:Bool!
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - rule: <#rule description#>
    ///   - errorMessage: <#errorMessage description#>
    ///   - optinal: <#optinal description#>
    public init(rule:IXRegexValidation,errorMessage:String,optinal:Bool=false) {
        self.rule = rule
        self.errorMessage = errorMessage
        self.optinal = optinal
    }
}
