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
    let dispoeBag = DisposeBag()
    let title = Variable<String?>(nil)
    let insightText = Variable<NSAttributedString?>(NSAttributedString(string: ""))
    
    init(recommendationId: Int) {
        let evidence = WebService.shared.fetchEvidences(for: recommendationId)
            .map { $0.first }
            .shareReplay(2)
        
        evidence
            .map { $0?.measurementName }
            .bindTo(title)
            .addDisposableTo(dispoeBag)
        
        evidence
            .map { "\($0?.measurementValue ?? "") / \($0?.cohortMeasurementValue ?? "")" }
            .map { NSAttributedString(string: $0 ?? "")}
            .bindTo(insightText)
            .addDisposableTo(dispoeBag)

    }
}
