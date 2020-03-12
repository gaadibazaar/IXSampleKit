//
//  RequestManager.swift
//  IXSampleKit
//
//  Created by CIFCL on 12/03/20.
//

import Foundation


/// http method type
///
/// - get: get method for get
/// - post: post method for insert
/// - put: put method for update
/// - delete: delete method for delete
public enum HTTPMethod:String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}


/// ResponseStatus validation
public struct ResponseStatus {
    
    /// status code
    public var code : Int!
    /// status key
    public var key : String!
    /// error message
    public var messsage : String!
    
    public init(code:Int,key:String,messsage:String="message"){
        self.code = code
        self.key = key
        self.messsage = messsage
    }
}
public typealias ResponseObject = ObjectMapper & Response
/// RequestManager, It's help to used for api integration and object mapping
open class RequestManager:NSObject{
    
    /// headers, defalut empty
    private var _headers = Dictionary<String,String>()
    /// defalut session is URLSession.shared
    private var session:URLSession!
    /// defalut configuration is URLSessionConfiguration.shared
    public var configuration:URLSessionConfiguration!

    /// validate howmany time  retried , default 0
    private var _retriedCount : Int = 0

    /// defalut timeout is 30
    public var timeoutInterval:TimeInterval = 60
    
    /// it's allowed status to validate api response
    internal var _statusCode  = [ResponseStatus]()
    
    /// it's help to parse json response to map data
    internal var _parseKey =  Array<String>()
    
    /// current datatask
    internal var _dataTask : URLSessionDataTask?
  
    /// current datatask
    internal var _responseData = Data()
    
    /// urlrequest
    open var urlRequest : URLRequest!
    
    /// retry api hit, default 0
    open var retry : Int = 0
    
    open var httpMethod = HTTPMethod.get

    open var body : Data?
 
    //internal purpose of callback
    internal var _internalJSONCallback : (( JSONResponse)->Void)?
    internal var _progressHandler : (( Int64, Int64,Float)->Void)?
    
    /// current data task
    public var dataTask:URLSessionDataTask?{
        return _dataTask
    }
    
    /// init
    ///
    /// - Parameters:
    ///   - url: base api url
    ///   - session: session for api, if session ignored defalut URLSessionConfiguration.shared
    public init(url:URL,configuration:URLSessionConfiguration=URLSessionConfiguration.default) {
        super.init()
        self.configuration = configuration
        self.session = URLSession.init(configuration: configuration, delegate: self, delegateQueue: OperationQueue.init())
        urlRequest = URLRequest.init(url: url)
    }
    /// header field
    ///
    /// - Parameters:
    ///   - key: header key
    ///   - value: header value
    public func addHeader(_ key:String,_ value:String){
        _headers[key] = value
    }
   
}
public extension RequestManager{
    
    /// json response
    ///
    /// - Parameter handler: JSONResponse
    public func responseJSON(_  handler:(( JSONResponse)->Void)?){
        for (key,value) in _headers {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.timeoutInterval = timeoutInterval
        urlRequest.httpBody = body
        _dataTask = session.dataTask(with: urlRequest)
        _start();
        self._internalJSONCallback = handler
    }
    
    /// response model, comfortable to ObjectMapper
    ///
    /// - Parameter handler: ResponseModel<ObjectMapper>
    public func responseModel<T>(_  handler:(( ResponseModel<T>)->Void)?){
        responseJSON { (object) in
            if object.sucess{
                /// parse ResponseModel
                handler?(self.parserJSON(object.data!, classModel: T.self))
            }else{
                handler?(ResponseModel<T>.init(object.data, object.error))
            }
        }
    }
    public func progressHandler(_ handler:(( Int64, Int64,Float)->Void)?){
        _progressHandler = handler
    }
}

extension RequestManager{
    
    private func _start(){
          _dataTask?.resume()
    }
    
    internal func completeRequest( error:Error?=nil){
        if error != nil {
            if self._retriedCount < self.retry{
                self._retriedCount += 1
                OperationQueue.main.addOperation {
                    self._start()
                }
            }else{
                OperationQueue.main.addOperation {
                    let json =  self.jsonParser(nil, error)
                    self._internalJSONCallback?(json)
                }
            }
            return
        }
        let json =  self.jsonParser(self._responseData, error)
        _internalJSONCallback?(json)
    }
}
extension RequestManager {
   override open var debugDescription: String {
        return "URL: \(String(describing: urlRequest.url)) \n Method: \(httpMethod.rawValue)"
    }
}

