//
//  HealthKitAuthorizationViewModel.swift
//  NotYet
//
//  Created by Niklas Riekenbrauck on 26.11.16.
//  Copyright © 2016 Niklas Riekenbrauck. All rights reserved.
//

import RxSwift
import UIKit

class HealthKitAuthorizationViewModel: BaseOverviewViewModel {
    var infoTapped = PublishSubject<Void>()
    var statusText = Variable<NSAttributedString?>(NSAttributedString(string:"To help you we need access to your Health app"))
    var tipText = Variable<String?>(nil)
    var actionTapped = PublishSubject<Void>()
    var skipTapped = PublishSubject<Void>()
    var actionTitle = Variable<String?>("Grant Access")
    var skipTitle = Variable<String?>(nil)
    var done = PublishSubject<Void>()
    
    private let disposeBag = DisposeBag()

    init() {
        actionTapped
            .flatMap {
                HealthService.shared.authorize()
            }.map { () }
            .bindTo(done)
            .addDisposableTo(disposeBag)
    }
}
