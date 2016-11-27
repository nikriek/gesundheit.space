//
//  Recommendation.swift
//  NotYet
//
//  Created by Niklas Riekenbrauck on 26.11.16.
//  Copyright © 2016 Niklas Riekenbrauck. All rights reserved.
//

import Foundation

final class Recommendation: ResponseObjectSerializable, ResponseCollectionSerializable {
    enum ActionType {
        case none
        case url(String)
        case action(String)
    }
    
    var id: Int
    var title: String
    var advice: String
    var actionTitle: String
    var media: String?
    var type: ActionType
    
    required init?(response: HTTPURLResponse, representation: Any) {
        guard let representation = representation as? [String: Any],
            let id = representation["id"] as? Int,
            let title = representation["title"] as? String,
            let advice = representation["advice"] as? String,
            let actionTitle = representation["button_label"] as? String else {
                return nil
        }
        
        self.id = id
        self.title = title
        self.advice = advice
        self.actionTitle = actionTitle
        
        self.media = representation["media"] as? String

        if let link = representation["link"] as? String {
            self.type = .url(link)
        } else if let action = representation["action"] as? String {
            self.type = .action(action)
        } else {
            self.type = .none
        }
    }
}
