//
//  InsightViewController.swift
//  NotYet
//
//  Created by Niklas Riekenbrauck on 26.11.16.
//  Copyright © 2016 Niklas Riekenbrauck. All rights reserved.
//

import UIKit
import RxSwift

class InsightViewController: UIViewController{
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
    }
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = UIColor.white
        
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.top).offset(self.navigationController?.navigationBar.frame.size.height ?? CGFloat(0))
            make.bottom.equalTo(self.view.snp.bottom)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
        }
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        
        self.containerStackView.insertArrangedSubview(label, at: 0)
        
        return label
    }()
    
    private lazy var insightLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        
        self.containerStackView.insertArrangedSubview(label, at: 1)
        
        return label
    }()
    
    private lazy var seeMoreButton: UIButton = {
        let button = UIButton()
        return button
    }()
}
