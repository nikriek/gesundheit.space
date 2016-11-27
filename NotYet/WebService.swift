//
//  WebService.swift
//  NotYet
//
//  Created by Niklas Riekenbrauck on 25.11.16.
//  Copyright © 2016 Niklas Riekenbrauck. All rights reserved.
//

import RxSwift
import Alamofire

class WebService {
    static let shared = WebService()
    
    let sessionManager = SessionManager.default
    
    func fetchRecommendations() -> Observable<[Recommendation]> {
        let route = Router.recommendations
        return sessionManager.requestCollection(route)
    }
    
    func fetchEvidences(for recommendationId: Int) -> Observable<[Evidence]> {
        let route = Router.evidences(recommendationId: recommendationId)
        return sessionManager.requestCollection(route)
    }
    
    func doAction(recommendationId: Int) -> Observable<Void> {
        let route = Router.action(recommendationId: recommendationId)
        return sessionManager.requestEmpty(route)
    }
}
