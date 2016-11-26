//
//  OverviewViewModel.swift
//  NotYet
//
//  Created by Niklas Riekenbrauck on 25.11.16.
//  Copyright © 2016 Niklas Riekenbrauck. All rights reserved.
//

import RxSwift
import UIKit

class OverviewViewModel: BaseOverviewViewModel {
    var statusText = Variable<NSAttributedString?>(NSAttributedString(string:"You look tired today."))
    var tipText = Variable<String?>("Lowering your room temperature could improve your sleep.")
    var actionTapped = PublishSubject<Void>()
    var skipTapped = PublishSubject<Void>()
    var actionTitle = Variable<String?>("Do something")
    var skipTitle = Variable<String?>("Skip")
    var done = PublishSubject<Void>()
    var infoTapped = PublishSubject<Void>()
    var presentInsight = PublishSubject<Void>()
    
    let disposeBag = DisposeBag()
    
    init() {
        infoTapped
            .bindTo(presentInsight)
            .addDisposableTo(disposeBag)
        
        let recommendationsFetch = WebService.shared.fetchRecommendations()
            .map { $0.first }
            .shareReplay(2)
        
        recommendationsFetch
            .map { recommendation -> NSAttributedString? in
                return NSAttributedString(string: recommendation?.title ?? "")
            }
            .bindTo(statusText)
            .addDisposableTo(disposeBag)
        
        recommendationsFetch
            .map { $0?.advice }
            .bindTo(tipText)
            .addDisposableTo(disposeBag)
    }
}
