//
//  MediaUploadManager.swift
//  IXSampleKit
//
//  Created by CIFCL on 12/03/20.
//

import Foundation


open class MediaUploadManager{
    
    public var request : RequestManager!
    open var files = Array<MediaUploadModel>()
    public var parameters : Dictionary<String,Any>?
    
    public var count:Int{
        return files.count
    }
    
    /// init
    ///
    /// - Parameters:
    ///   - url: base api url
    ///   - session: session for api, if session ignored defalut URLSessionConfiguration.shared
    public init(url:URL,configuration:URLSessionConfiguration=URLSessionConfiguration.default) {
        request = RequestManager.init(url: url, configuration: configuration)
        request.httpMethod = .post
    }
    public func addMedia(_ media:MediaUploadModel){
        files.append(media)
    }
    public func clear(){
        files.removeAll()
    }
    
   public func prepareUpload(){
        let boundary = "Boundary-\(UUID().uuidString)"
        request.addHeader("Content-Type", "multipart/form-data; boundary=\(boundary)")
        request.body = createBody(boundary: boundary)
    }
    
    
  private  func createBody( boundary: String) -> Data {
        
        var body = Data()
        //start boundary
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in (parameters ?? [:]) {
            body.appendString(boundaryPrefix)//start form
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)")
            body.appendString("\r\n")//end form
        }
        for media in files{
            if let data  = try? Data.init(contentsOf: media.fileURL){
                body.appendString(boundaryPrefix)//start form
                body.appendString(String.init(format: "Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", media.key,media.filename))
                body.appendString("Content-Type: \(media.contentType)\r\n\r\n")
                body.append(data)
                body.appendString("\r\n")//end form
                print("====Media Form data=====>\(body.toString ?? "")")
            }
        }
        //end boundary
        body.appendString("--".appending(boundary.appending("--")))
     
        return body as Data
    }
}



extension Data {
    mutating func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}

