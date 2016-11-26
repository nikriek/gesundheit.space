//
//  KantaConnectViewModel.swift
//  NotYet
//
//  Created by Niklas Riekenbrauck on 26.11.16.
//  Copyright © 2016 Niklas Riekenbrauck. All rights reserved.
//

import RxSwift
import UIKit

class KantaConnectViewModel: BaseOverviewViewModel {
    var statusText = Variable<NSAttributedString?>(KantaConnectViewModel.createKantaText())
    var tipText = Variable<String?>(nil)
    var actionTapped = PublishSubject<Void>()
    var skipTapped = PublishSubject<Void>()
    var actionTitle = Variable<String?>("Connect with Kanta")
    var skipTitle = Variable<String?>("Skip")
    var done = PublishSubject<Void>()
    var infoTapped = PublishSubject<Void>()

    private let disposeBag = DisposeBag()
    
    private static func createKantaText() -> NSAttributedString {
        let kantaLogo = NSTextAttachment()
        kantaLogo.image = #imageLiteral(resourceName: "Kanta")
        
        let connectText = NSMutableAttributedString(string: "Connect with ")
        connectText.append(NSAttributedString(attachment: kantaLogo))
        connectText.append(NSAttributedString(string: " and get even better results."))
        
        return connectText
    }
    
    init() {
        skipTapped
            .bindTo(done)
            .addDisposableTo(disposeBag)
        
        actionTapped
            .bindTo(done)
            .addDisposableTo(disposeBag)
    }
}
