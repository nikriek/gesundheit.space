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
import RxCocoa


protocol BaseOverviewViewModel {
    var statusText: Variable<NSAttributedString?> { get }
    var tipText: Variable<String?> { get }
    var actionTapped: PublishSubject<Void> { get }
    var skipTapped: PublishSubject<Void> { get }
    var actionTitle: Variable<String?> { get }
    var skipTitle: Variable<String?> { get }
    var done: PublishSubject<Void> { get }
    var infoTapped: PublishSubject<Void> { get }
}

class BaseOverviewViewController<ViewModel: BaseOverviewViewModel>: UIViewController {
    weak var coordinator: Coordinator?
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 42)
        label.numberOfLines = 0
        
        let wrapperView = UIView()
        self.topStackView.insertArrangedSubview(wrapperView, at: 0)
        wrapperView.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalTo(wrapperView.snp.leading).offset(38)
            make.trailing.equalTo(wrapperView.snp.trailing).offset(-38)
            make.bottom.equalTo(wrapperView.snp.bottom)
        }
        return label
    }()
    
    private lazy var tipLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 30)
        label.numberOfLines = 0
        
        let wrapperView = UIView()
        self.topStackView.insertArrangedSubview(wrapperView, at: 1)
        wrapperView.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalTo(wrapperView.snp.leading).offset(38)
            make.trailing.equalTo(wrapperView.snp.trailing).offset(-38)
            make.top.equalTo(wrapperView.snp.top)
        }
        
        return label
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        
        button.setTitleColor(UIColor.customLightGreen, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)

        self.bottomStackView.insertArrangedSubview(button, at: 0)
        button.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        return button
    }()
    
    private lazy var skipButton: UIButton = {
        let button = UIButton()
        
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        self.bottomStackView.insertArrangedSubview(button, at: 1)
        
        return button
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.snp.edges)
        }
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 38
        
        self.containerStackView.insertArrangedSubview(stackView, at: 0)
        
        return stackView
    }()
    
    
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .infoLight)
        let barItem = UIBarButtonItem(customView: button)
        button.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = barItem
        
        return button
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        
        self.containerStackView.insertArrangedSubview(stackView, at: 1)
        stackView.layoutMargins = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }()
    
    let viewModel: ViewModel
    
    let disposeBag = DisposeBag()
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.statusText.asDriver()
            .drive(statusLabel.rx.attributedText)
            .addDisposableTo(disposeBag)
        
        viewModel.tipText.asDriver()
            .drive(tipLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel.actionTitle.asDriver()
            .drive(actionButton.rx.title())
            .addDisposableTo(disposeBag)
        
        viewModel.skipTitle.asDriver()
            .drive(skipButton.rx.title())
            .addDisposableTo(disposeBag)
        
        viewModel.skipTitle.asDriver()
            .map { $0 == nil }
            .drive(skipButton.rx.isHidden)
            .addDisposableTo(disposeBag)
        
        actionButton.rx.tap.asObservable()
            .bindTo(viewModel.actionTapped)
            .addDisposableTo(disposeBag)
        
        skipButton.rx.tap.asObservable()
            .bindTo(viewModel.skipTapped)
            .addDisposableTo(disposeBag)
        
        viewModel.done.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.coordinator?.done(with: self)
            })
            .addDisposableTo(disposeBag)
        
        infoButton.rx.tap
            .bindTo(viewModel.infoTapped)
            .addDisposableTo(disposeBag)
        
        if let vm = (viewModel as? OverviewViewModel) {
            vm.presentInsight
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] _ in
                    guard let `self` = self, let recommendationId = vm.currentRecommendation.value?.id else { return }
                    self.coordinator?.presentInsight(on: self, recommendationId: recommendationId)
                })
                .addDisposableTo(disposeBag)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topStackView.applyGradient(topRightColor: UIColor.customLightGreen, bottomLeftColor: UIColor.customGreen)
    }
}


