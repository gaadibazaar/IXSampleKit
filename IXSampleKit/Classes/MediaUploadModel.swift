//
//  MediaUploadModel.swift
//  IXSampleKit
//
//  Created by CIFCL on 12/03/20.
//

import Foundation


open class MediaUploadModel{
   public var filename:String!
    //it can represent as name or key
   public var key:String!
   public var contentType:String!
   public var fileURL:URL!
   public init(filename:String,key:String,fileURL:URL,contentType:String) {
        self.filename = filename
        self.key = key
        self.fileURL = fileURL
        self.contentType = contentType
    }
}
