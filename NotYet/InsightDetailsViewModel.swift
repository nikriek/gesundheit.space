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
    case chart(image: UIImage)
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
    
    init() {
        
        insightItems.value = [InsightItem.chart(image: UIImage()), InsightItem.info(text: "Lol"), InsightItem.detail(name: "KK", value: NSAttributedString(string: "sdfjsf"))]
        
        insightItems.asObservable()
            .map { [InsightSection(items: $0)] }
            .bindTo(sections)
            .addDisposableTo(disposeBag)
    }
}
