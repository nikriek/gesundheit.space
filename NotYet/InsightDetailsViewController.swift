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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(ChartCell.self, forCellReuseIdentifier: ChartCell.identifier)
        tableView.register(InfoCell.self, forCellReuseIdentifier: InfoCell.identifier)
        tableView.register(DetailCell.self, forCellReuseIdentifier: DetailCell.identifier)
        tableView.backgroundColor = UIColor.customBackgroundGray
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.snp.edges)
        }
        
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSource = RxTableViewSectionedReloadDataSource<InsightSection>()
        
        

        dataSource.configureCell = { (ds, tv, ip, item) in
            switch item {
            case .info(let text):
                let cell = tv.dequeueReusableCell(withIdentifier: InfoCell.identifier, for: ip) as? InfoCell ?? InfoCell()
                cell.textLabel?.text = text
                return cell
            case .chart(let image):
                let cell = tv.dequeueReusableCell(withIdentifier: ChartCell.identifier, for: ip) as? ChartCell ?? ChartCell()
                cell.chartView.image = image
                return cell
            case .detail(let name, let value):
                let cell = tv.dequeueReusableCell(withIdentifier: DetailCell.identifier, for: ip) as? DetailCell ?? DetailCell()
                cell.textLabel?.text = name
                cell.detailTextLabel?.attributedText = value
                return cell
            }
        }
        
        viewModel.sections.asObservable()
            .bindTo(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
    }
}
