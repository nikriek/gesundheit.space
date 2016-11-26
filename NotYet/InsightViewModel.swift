//
//  InsightsViewModel.swift
//  NotYet
//
//  Created by Niklas Riekenbrauck on 26.11.16.
//  Copyright © 2016 Niklas Riekenbrauck. All rights reserved.
//

import RxSwift
import Foundation

class InsightViewModel {
    let title = Variable<String?>("Title")
    let insightText = Variable<NSAttributedString?>(NSAttributedString(string:"Title"))
}
