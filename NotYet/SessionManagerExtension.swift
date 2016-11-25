//
//  AlamofireExtension.swift
//  Hearts4
//
//  Created by Niklas Riekenbrauck on 08.11.16.
//  Copyright © 2016 Niklas Riekenbrauck. All rights reserved.
//

import Alamofire
import RxSwift


extension SessionManager {
    /// Sends a request and parses the response into an object that conforms ResponseObjectSerializable
    func requestObject<T: ResponseObjectSerializable> (_ urlRequest: URLRequestConvertible) -> Observable<T> {
        return Observable.create { observer in
            let request = self.request(urlRequest)
                .validate()
                .responseObject { (response: DataResponse<T>) in
                    switch response.result {
                    case .success(let value):
                        observer.on(.next(value))
                    case .failure(let error):
                        observer.on(.error(error))
                    }
                    observer.on(.completed)
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    /// Sends a request and parses the response into a collection of objects that conform ResponseCollectionSerializable
    func requestCollection<T: ResponseCollectionSerializable> (_ urlRequest: URLRequestConvertible) -> Observable<[T]> {
        return Observable.create { observer in
            let request = self.request(urlRequest)
                .validate()
                .responseCollection { (response: DataResponse<[T]>) in
                    switch response.result {
                    case .success(let value):
                        observer.on(.next(value))
                    case .failure(let error):
                        observer.on(.error(error))
                    }
                    observer.on(.completed)
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    /// Sends a request and ignores the data (useful for deletions with empty response bodies)
    func requestEmpty(_ urlRequest: URLRequestConvertible) -> Observable<Void> {
        return Observable.create { observer in
            let request = self.request(urlRequest)
                .validate()
                .response(queue: nil) { response in
                    if let error = response.error {
                        observer.on(.error(error))
                    } else {
                        observer.on(.next(()))
                    }
                    observer.on(.completed)
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
