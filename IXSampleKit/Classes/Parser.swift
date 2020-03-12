//
//  Parser.swift
//  IXSampleKit
//
//  Created by CIFCL on 12/03/20.
//

import Foundation

public extension RequestManager{
    
    internal func parserJSON<T:ObjectMapper>(_ data:Data, classModel:T.Type)->ResponseModel<T>{
        var responseModel = ResponseModel<T>.init(data)
        do{
            //convert data to json object
            let json = try JSONSerialization.jsonObject(with: data)
            responseModel.object = try _parseUsingKey(json: json)
            let parse_object = responseModel.object
            if parse_object is Dictionary<String, Any>{
                responseModel.item = try DynamicObjectMapper.objectMapper(parse_object as! Dictionary<String, Any>)
            }else  if parse_object is Array<Any>{
                let list = parse_object as! Array<Any>
                responseModel.results = try DynamicObjectMapper.arrayObjectMapper(list)
            }else{
                // do something
            }
        }catch  {
            responseModel.error = error
            print(error)
        }
        return responseModel
    }
    internal func jsonParser(_ data:Data? ,_ err:Error?)->JSONResponse{
        var jsonResponse = JSONResponse.init(data, err)
        /// validate error
        if err != nil{
            return jsonResponse
        }
        /// if data is nil return errir
        guard let reponseData = data else{
            jsonResponse.error = NSError(domain: "internal exception", code: 1001, userInfo: [NSLocalizedDescriptionKey:"response  data is nil"])
            return jsonResponse
        }
        do{
            //json serialization
           let json = try JSONSerialization.jsonObject(with: reponseData)
            jsonResponse.object =  try _parseUsingKey(json: json)

        }catch{
            /// json serialization error
            jsonResponse.error = error
        }
        return jsonResponse
    }
    
    //MARK:- Key Parse
    private func _parseUsingKey( json:Any) throws ->Any{
        var parse_object = json
        //if parse key is availble, parse final json object
        for key in _parseKey{
            if let tmp = json as? Dictionary<String,Any>, let _parseValue = tmp[key] {
                parse_object = _parseValue
            }
        }
        for key in _statusCode{
            if let tmp = json as? Dictionary<String,Any>, let _code = tmp[key.key] as? Int {
                print(_code)
                throw NSError(domain: "internal exception", code: _code, userInfo: [NSLocalizedDescriptionKey:tmp[key.messsage] ?? "unkown error"] )
            }
        }
        return parse_object
    }
}
public struct DynamicObjectMapper{
    
    public static  func arrayObjectMapper<T:ObjectMapper>(_ list:[Any]) throws -> [T]?{
        let models  = try list.map({ (item) -> T in
            //dynamic object mapping invoke mapping function
            let model : T = try objectMapper(item as! Dictionary<String, Any>)
            return model
        })
        return models
    }
    public  static  func objectMapper<T:ObjectMapper>( _  object:Dictionary<String, Any> )  throws -> T{
        //json to data for JSONDecoder
        let modifiedJSON = T.keyExchange(json: object)
        let jsonDecoder = JSONDecoder.init()
        let finaldata = try JSONSerialization.data(withJSONObject: modifiedJSON, options: [])
        let model = try jsonDecoder.decode(T.self, from: finaldata)
        model.mapping(json: modifiedJSON )
        return model
    }
}
public extension ObjectMapper{
    func clone<T:ObjectMapper>()throws ->T?{
        let jsonEncoder = JSONEncoder()
        let data  = try jsonEncoder.encode(self)
        let jsonDecoder = JSONDecoder.init()
        return try jsonDecoder.decode(T.self, from: data)
    }
    func cloneToAnotherObject<T:ObjectMapper>(_ handler:((Dictionary<String,Any>?)->Dictionary<String,Any>)?=nil)throws -> T{
        var json = try self.json()
        
        if let closure = handler{
            json = closure(json)
        }
        let object : T  = try DynamicObjectMapper.objectMapper(json)
        return object
    }
    func json()throws->Dictionary<String,Any>  {
        let jsonEncoder = JSONEncoder()
        let data  = try jsonEncoder.encode(self)
        let jsonObj = try JSONSerialization.jsonObject(with: data)
        return jsonObj as! Dictionary<String, Any>
    }
    func data()throws->Data? {
        let jsonEncoder = JSONEncoder()
        let data  = try jsonEncoder.encode(self)
        return data
    }
    static func map<T:ObjectMapper>(data:Data)throws ->T{
        let jsonDecoder = JSONDecoder.init()
        return try jsonDecoder.decode(T.self, from: data)
    }
}

extension Array where Element == ObjectMapper{
   public func dataArray() ->Array<Data>{
        var datas = Array<Data>()
        do {
            forEach { (object) in
                if let data = try? object.data(), data != nil{
                    datas.append(data!)
                }
            }
        }
      return datas
        
    }
}
public extension Dictionary where Key==String{
    /// query string
    var query:String{
        var querystring = [String]()
        for (key,value) in self {
            let format = "\(key)=\(value)"
            querystring.append(format)
        }
        return querystring.joined(separator: "&")
    }
    var arrayObject : [Dictionary<String,Any>]{
        var items = [Dictionary<String,Any>]()
        for (key,value) in self {
            let object = ["key":key,"value":value] as [String : Any]
            items.append(object)
        }
        return items
    }
}
public extension Data{
    var toString:String?{
        return String.init(data: self, encoding: String.Encoding.utf8)
    }
    func json()throws->Any?  {
        let jsonObj = try JSONSerialization.jsonObject(with: self)
        return jsonObj
    }
}

