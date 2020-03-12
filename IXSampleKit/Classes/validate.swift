//
//  validate.swift
//  IXSampleKit
//
//  Created by CIFCL on 12/03/20.
//

import Foundation

public extension RequestManager{
    
    
    /// validate api response using custom error code
    ///
    /// - Parameter statusCode: api code
    /// - Returns: owner self
    public func validate(status : ResponseStatus) -> Self{
        _statusCode.append(status)
        return self
    }
   
    /// parse api response key
    ///
    /// - Parameter key: custom api reponse key for object mapper
    /// - Returns: owner self
    public func parse(key:String) -> Self{
        _parseKey.append(key)
        return self
    }
    func validate(){
        
    }
}

