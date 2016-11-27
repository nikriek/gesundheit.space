//
//  InsightDetailsViewController.swift
//  NotYet
//
//  Created by Niklas Riekenbrauck on 26.11.16.
//  Copyright © 2016 Niklas Riekenbrauck. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class InsightDetailsViewController: UIViewController {
    weak var coordinator: Coordinator?
    
    let viewModel: InsightDetailsViewModel
    
    init(viewModel: InsightDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let disposeBag = DisposeBag()
    
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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 240
        tableView.register(ChartCell.self, forCellReuseIdentifier: ChartCell.identifier)
        tableView.register(InfoCell.self, forCellReuseIdentifier: InfoCell.identifier)
        tableView.register(DetailCell.self, forCellReuseIdentifier: DetailCell.identifier)
        tableView.backgroundColor = UIColor.customBackgroundGray
        tableView.allowsSelection = false
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 24, 0)
        
        self.containerStackView.insertArrangedSubview(tableView, at: 1)
       
        return tableView
    }()
    
    private lazy var seeLessButton: UIButton = {
        let button = UIButton()
        
        button.setTitleColor(UIColor.customGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        
        self.containerStackView.insertArrangedSubview(button, at: 0)
        button.snp.makeConstraints { make in
            make.height.equalTo(96)
        }
        button.setTitle("See less", for: .normal)
        button.backgroundColor = UIColor.customBackgroundGray
        button.setImage(#imageLiteral(resourceName: "Chevron-Up"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        seeLessButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.coordinator?.done(on: self)
            })
            .addDisposableTo(disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<InsightSection>()
        
        dataSource.configureCell = { (ds, tv, ip, item) in
            switch item {
            case .info(let text):
                let cell = tv.dequeueReusableCell(withIdentifier: InfoCell.identifier, for: ip) as? InfoCell ?? InfoCell()
                cell.textLabel?.text = text
                return cell
            case .chart(let url):
                let cell = tv.dequeueReusableCell(withIdentifier: ChartCell.identifier, for: ip) as? ChartCell ?? ChartCell()
                cell.chartView.load(URLRequest(url: url))
                return cell
            case .detail(let name, let value):
                let cell = tv.dequeueReusableCell(withIdentifier: DetailCell.identifier, for: ip) as? DetailCell ?? DetailCell()
                cell.nameLabel.text = name
                cell.measurementLabel.attributedText = value
                return cell
            }
        }
        
        viewModel.sections.asObservable()
            .bindTo(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        seeLessButton.centerVertically(imageTop: false)
    }
}
