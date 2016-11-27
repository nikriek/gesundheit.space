//
//  Router.swift
//  NotYet
//
//  Created by Niklas Riekenbrauck on 25.11.16.
//  Copyright © 2016 Niklas Riekenbrauck. All rights reserved.
//

import Alamofire


enum Router: URLRequestConvertible {
    static let baseURLString = "https://hidden-sands-36117.herokuapp.com"

    case recommendations
    case action(recommendationId: Int)
    case evidences(recommendationId: Int)
    
    var method: HTTPMethod {
        switch self {
        case .recommendations:
            return .get
        case .action:
            return .post
        case .evidences:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .recommendations:
            return "/recommendations"
        case .action(let recommendationId):
            return "/recommendations/\(recommendationId)/action"
        case .evidences(let recommendationId):
            return "/recommendations/\(recommendationId)/evidences"
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
