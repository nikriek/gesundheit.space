//
//  InsightDetailsViewModel.swift
//  NotYet
//
//  Created by Niklas Riekenbrauck on 26.11.16.
//  Copyright © 2016 Niklas Riekenbrauck. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift

enum InsightItem {
    case info(text: String)
    case detail(name: String, value: NSAttributedString)
    case chart(url: URL)
}

struct InsightSection: SectionModelType {
    var items: [Item]
    
    typealias Item = InsightItem
    
    init(original: InsightSection, items: [Item]) {
        self = original
        self.items = items
    }
    
    init(items: [Item]) {
        self.items = items
    }
}


class InsightDetailsViewModel {
    var sections = Variable<[InsightSection]>([])
    
    private var insightItems = Variable<[InsightItem]>([])
    
    let disposeBag = DisposeBag()
    
    init(recommendationId: Int) {
        
        WebService.shared.fetchEvidences(for: recommendationId)
            .map {
                [InsightItem.info(text: "Recommended values are based on a group of people who share a lot of similarities with you e.g. age and weight.\n\nPowered by Kanta, Localtapiola and Isaac")] + $0.flatMap {
                    if let url = $0.url {
                        return InsightItem.chart(url: URL(string: url)!)
                    } else {
                        return InsightItem.detail(name: $0.measurementName, value: NSAttributedString(string: "\($0.measurementValue) / \($0.cohortMeasurementValue)"))
                    }
                }
            }
            .bindTo(insightItems)
            .addDisposableTo(disposeBag)
                
        insightItems.asObservable()
            .map { [InsightSection(items: $0)] }
            .bindTo(sections)
            .addDisposableTo(disposeBag)
    }
}
