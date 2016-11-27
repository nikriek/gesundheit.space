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
    var statusText = Variable<NSAttributedString?>(NSAttributedString(string: "You look tired today."))
    var tipText = Variable<String?>("Lowering your room temperature could improve your sleep.")
    var actionTapped = PublishSubject<Void>()
    var skipTapped = PublishSubject<Void>()
    var actionTitle = Variable<String?>(nil)
    var skipTitle = Variable<String?>("Skip")
    var done = PublishSubject<Void>()
    var infoTapped = PublishSubject<Void>()
    var presentInsight = PublishSubject<Void>()
    var recommendations = Array<Recommendation>().makeIterator()
    var currentRecommendation = Variable<Recommendation?>(nil)
    
    let disposeBag = DisposeBag()
    
    init() {
        infoTapped
            .bindTo(presentInsight)
            .addDisposableTo(disposeBag)
        
        WebService.shared.fetchRecommendations()
            .subscribe(onNext: { [weak self] it in
                self?.recommendations = it.makeIterator()
                self?.currentRecommendation.value = self?.recommendations.next()
            })
            .addDisposableTo(disposeBag)
        
        currentRecommendation.asObservable()
            .map { recommendation -> NSAttributedString? in
                return NSAttributedString(string: recommendation?.title ?? "No more advices :(")
            }
            .bindTo(statusText)
            .addDisposableTo(disposeBag)
        
        currentRecommendation.asObservable()
            .map { $0?.advice }
            .bindTo(tipText)
            .addDisposableTo(disposeBag)
        
        currentRecommendation.asObservable()
            .map { rec -> String? in
                return rec?.actionTitle ?? " "
            }
            .bindTo(actionTitle)
            .addDisposableTo(disposeBag)
    
        currentRecommendation.asObservable()
            .map { $0?.type }
            .map { type -> String? in
                guard let type = type else { return nil }
                switch type {
                case .action, .url:
                    return "Skip"
                default:
                    return nil
                }
            }
            .bindTo(skipTitle)
            .addDisposableTo(disposeBag)
        
        skipTapped.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.currentRecommendation.value = self?.recommendations.next()
            }).addDisposableTo(disposeBag)
        
        actionTapped.withLatestFrom(currentRecommendation.asObservable())
            .filter {
                guard case .action(_)? = $0?.type else { return false }
                return true
            }
            .map { $0?.id }
            .flatMap { WebService.shared.doAction(recommendationId: $0 ?? 1) }
            .subscribe({ [weak self] (event) in
                self?.currentRecommendation.value = self?.recommendations.next()
            })
            .addDisposableTo(disposeBag)
        
         actionTapped.withLatestFrom(currentRecommendation.asObservable())
            .map { rec -> String? in
                guard let rec = rec else { return nil }
                switch rec.type {
                case .url(let link):
                    return link
                default:
                    return nil
                }
            }.filter { $0 != nil }
            .subscribe(onNext: { [weak self] link in
                guard let link = link, let url = URL(string: link) else { return }
                self?.currentRecommendation.value = self?.recommendations.next()
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }).addDisposableTo(disposeBag)
    }
}
