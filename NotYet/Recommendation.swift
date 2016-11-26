//
//  Recommendation.swift
//  NotYet
//
//  Created by Niklas Riekenbrauck on 26.11.16.
//  Copyright © 2016 Niklas Riekenbrauck. All rights reserved.
//

import Foundation

final class Recommendation: ResponseObjectSerializable, ResponseCollectionSerializable {
    var id: Int
    var title: String
    var advice: String
    
    required init?(response: HTTPURLResponse, representation: Any) {
        guard let representation = representation as? [String: Any],
            let id = representation["id"] as? Int,
            let title = representation["title"] as? String,
            let advice = representation["advice"] as? String else {
                return nil
        }
        self.id = id
        self.title = title
        self.advice = advice
    }
}
