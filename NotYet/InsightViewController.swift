//
//  InsightViewController.swift
//  NotYet
//
//  Created by Niklas Riekenbrauck on 26.11.16.
//  Copyright © 2016 Niklas Riekenbrauck. All rights reserved.
//

import UIKit
import RxSwift

class InsightViewController: UIViewController {
    weak var coordinator: Coordinator?
    
    let viewModel: InsightViewModel
    
    let disposeBag = DisposeBag()
    
    init(viewModel: InsightViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.applyGradient(topRightColor: UIColor.customLightGreen, bottomLeftColor: UIColor.customGreen)
        
        navigationController?.navigationBar.topItem?.title = ""
        
        viewModel.title.asObservable()
            .bindTo(titleLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel.insightText.asObservable()
            .bindTo(insightLabel.rx.attributedText)
            .addDisposableTo(disposeBag)
        
        seeMoreButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.coordinator?.presentInsightDetails(on: self, recommendationId: self.viewModel.recommendationId)
            }).addDisposableTo(disposeBag)
    }
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        let wrapper = UIView()
        wrapper.backgroundColor = UIColor.white
        self.view.addSubview(wrapper)
        wrapper.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.top).offset(self.navigationController?.navigationBar.frame.size.height ?? CGFloat(0))
            make.bottom.equalTo(self.view.snp.bottom)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
        }
        wrapper.addSubview(stackView)
        stackView.snp.makeConstraints({ (make) in
            make.edges.equalTo(wrapper.snp.edges)
        })

        return stackView
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 38
        
        self.containerStackView.insertArrangedSubview(stackView, at: 0)
        
        return stackView
    }()

    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        
        self.containerStackView.insertArrangedSubview(stackView, at: 1)
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = UIColor.customGray

        self.topStackView.insertArrangedSubview(label, at: 0)
        
        return label
    }()
    
    private lazy var insightLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 120, weight: UIFontWeightThin)
        label.textColor = UIColor.customGray
        label.numberOfLines = 0

        self.topStackView.insertArrangedSubview(label, at: 1)
        
        return label
    }()
    
    private lazy var seeMoreButton: UIButton = {
        let button = UIButton()
    
        button.setTitleColor(UIColor.customGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        
        self.bottomStackView.insertArrangedSubview(button, at: 0)
        button.snp.makeConstraints { make in
            make.height.equalTo(96)
        }
        button.setTitle("See more", for: .normal)
        button.setImage(#imageLiteral(resourceName: "Chevron-Down"), for: .normal)
        
        button.backgroundColor = UIColor.customBackgroundGray
        return button
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        seeMoreButton.centerVertically(imageTop: true)
    }
    
}
