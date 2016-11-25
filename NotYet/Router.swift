//
//  Router.swift
//  NotYet
//
//  Created by Niklas Riekenbrauck on 25.11.16.
//  Copyright © 2016 Niklas Riekenbrauck. All rights reserved.
//

import Alamofire


enum Router: URLRequestConvertible {
    static let baseURLString = "https://example.com"

    case example
    
    var method: HTTPMethod {
        switch self {
        case .example:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .example:
            return "/users"
        }
    }
    
    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
}
