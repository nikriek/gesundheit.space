//
//  OverviewViewController.swift
//  NotYet
//
//  Created by Niklas Riekenbrauck on 25.11.16.
//  Copyright © 2016 Niklas Riekenbrauck. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift


class OverviewViewController: UIViewController {
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        self.view.addSubview(label)
        
        label.snp.makeConstraints { make in
            
        }
        return label
    }()
    
    private lazy var tipLabel: UILabel = {
        let label = UILabel()
        self.view.addSubview(label)
        label.snp.makeConstraints { make in
            
        }
        return label
    }()
    
    let viewModel: OverviewViewModel
    
    let disposeBag = DisposeBag()
    
    init(viewModel: OverviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.statusText.asDriver()
            .drive(statusLabel.rx.text)
            .addDisposable(disposeBag)
        
        viewModel.tipText.asDriver()
            .drive(tipLabel.rx.text)
            .addDisposable(disposeBag)
    }
}
