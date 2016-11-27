//
//  InsightsViewModel.swift
//  NotYet
//
//  Created by Niklas Riekenbrauck on 26.11.16.
//  Copyright © 2016 Niklas Riekenbrauck. All rights reserved.
//

import RxSwift
import Foundation
import UIKit

class InsightViewModel {
    let disposeBag = DisposeBag()
    let title = Variable<String?>(nil)
    let insightText = Variable<NSAttributedString?>(NSAttributedString(string: ""))
    let recommendationId: Int
    
    init(recommendationId: Int) {
        self.recommendationId = recommendationId
        
        let evidence = WebService.shared.fetchEvidences(for: recommendationId)
            .map { $0.first }
            .shareReplay(2)
        
        evidence
            .map { $0?.measurementName }
            .bindTo(title)
            .addDisposableTo(disposeBag)
        
        evidence
            .map { ev in
                guard let measurementValue = ev?.measurementValue, let cohortMeasurementValue =  ev?.cohortMeasurementValue else {
                    return NSAttributedString(string: "No Data found")
                }
                let hightlightText = NSMutableAttributedString(string: "\(measurementValue)", attributes: [
                    NSForegroundColorAttributeName: UIColor.customGreen])
                let string = NSAttributedString(string:" / \(cohortMeasurementValue)")
                hightlightText.append(string)
                return hightlightText
            }
            .bindTo(insightText)
            .addDisposableTo(disposeBag)
    }
}
