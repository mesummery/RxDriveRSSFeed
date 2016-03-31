//
//  RequestBase.swift
//  MAF-RSSFeed
//
//  Created by yamamotosaika on 2016/01/04.
//  Copyright © 2016年 mafmoff. All rights reserved.
//

// Frameworks
import UIKit
import RxSwift
import RxCocoa
import Alamofire
import ObjectMapper

enum Method: String {
    case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
}

/// Request Base
class RequestBase: NSObject {

    /// Alamofire Manager
    private let manager = Manager.sharedInstance

    /// Alamofire Requestオブジェクト
    private var request: Request?
    
    /// Rx破棄用dispose
    let disposeBag = DisposeBag()
    
    /**
     リクエスト生成
     
     - parameter host:       hostname
     - parameter path:       path
     - parameter method:     mothod
     - parameter parameters: param
     - parameter encoding:   encode
     - parameter headers:    header
     */
    final func createRequest(
        hostName hostName: String,
                 path: String,
                 method: Method,
                 parameters: [String: AnyObject]?,
                 encording: ParameterEncoding,
                 headers: [String: String]?) -> Request? {
        
        request = self.manager.request(
            Alamofire.Method(rawValue: method.rawValue)!,
            hostName + path,
            parameters: parameters,
            encoding: encording,
            headers: headers)
            .validate()
        
        return request
    }
    
    /**
     API通信、ObjectMapperでマッピング
     
     - returns: Observableオブジェクト
     */
    func connect<T: ResponseBase>() -> Observable<T> {
        let observable: Observable<T> = Observable.create { (observer: AnyObserver<T>) in
            self.request?.responseJSON(completionHandler: { response in
                print("\(response)")
                switch response.result {
                case .Success(let value):
                    guard let object = Mapper<T>().map(value) else {
                        return observer.onCompleted()
                    }
                    observer.onNext(object)
                    observer.onCompleted()
                case .Failure(let error):
                    observer.onError(error)
                }
            })
            return AnonymousDisposable {
                
            }
        }
        return observable
    }
}
