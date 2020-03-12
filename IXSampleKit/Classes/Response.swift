//
//  Response.swift
//  IXSampleKit
//
//  Created by CIFCL on 12/03/20.
//

import Foundation


/// ObjectMapper, help to bind
public protocol ObjectMapper : Codable {
    func mapping(json:Dictionary<String,Any>)
    static func keyExchange(json:Dictionary<String,Any>)-> Dictionary<String,Any>
}
public extension ObjectMapper{
    
    func mapping(json:Dictionary<String,Any>){
        
    }

    static func keyExchange(json:Dictionary<String,Any>)-> Dictionary<String,Any>{
        return json
    }

}
/// ObjectMapper, help to bind
public protocol Response  {
    var data : Data? {get set}
    var error : Error?  {get set}
    var object: Any?  {get set}
    var sucess:Bool {get}
}
/// Response, it's used to api result for using object mapper
public struct ResponseModel<T:ObjectMapper>:Response {
    public var data : Data?
    public var error : Error?
    public var item: T?
    public var results: [T]?
    public var object: Any?
    public var sucess:Bool{
        return error == nil
    }
    internal init(_ data:Data?,_ error:Error?=nil) {
        self.data = data
        self.error = error
    }
}

public struct JSONResponse:Response {
    public var data : Data?
    public var error : Error?
    public var object: Any?
    public var sucess:Bool{
        return error == nil
    }
    internal init(_ data:Data?,_ error:Error?=nil) {
        self.data = data
        self.error = error
    }
}


