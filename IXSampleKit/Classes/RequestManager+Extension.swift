//
//  RequestManager+Extension.swift
//  IXSampleKit
//
//  Created by CIFCL on 12/03/20.
//

import Foundation


extension RequestManager:URLSessionDelegate,URLSessionDataDelegate{
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        completeRequest(error: error)
    }
    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        
    }
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential,nil)
    }
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let uploadProgress:Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        let progressPercent = Int(uploadProgress*100)
        self._progressHandler?(totalBytesSent,totalBytesExpectedToSend,uploadProgress)
        print("\(uploadProgress)  :  \(progressPercent)%")
    }
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        completionHandler(.allow)
    }
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self._responseData.append(data)
    }
    @available(iOS 10.0, *)
    public func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        completeRequest()
    }
}

