//
//  LoadingViewController.swift
//  NotYet
//
//  Created by Niklas Riekenbrauck on 26.11.16.
//  Copyright © 2016 Niklas Riekenbrauck. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    weak var coordinator: Coordinator?
    
    var textGenerator = [
        "Receiving your health data...",
        "Examining your daily activities...",
        "Analyzing your sleep...",
        "Comparing to average data...",
        "Preparing personalized recommendations..."
    ].makeIterator()
    
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        self.view.addSubview(label)
    
        label.snp.makeConstraints { make in
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.view.snp.centerY)
        }
        
        return label
    }()
    
    private lazy var loadingView: LoadingView = {
        let loadingView = LoadingView(icons: [#imageLiteral(resourceName: "Shoe"), #imageLiteral(resourceName: "Sun"), #imageLiteral(resourceName: "Weight"), #imageLiteral(resourceName: "Coffee"), #imageLiteral(resourceName: "Heart")])
        self.view.addSubview(loadingView)
       
        loadingView.snp.makeConstraints { make in
            make.width.equalTo(64)
            make.height.equalTo(64)
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(self.view.snp.centerY)
        }
        
        return loadingView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = titleLabel
        _ = loadingView
        
        view.applyGradient(topRightColor: UIColor.customLightGreen, bottomLeftColor: UIColor.customGreen)
        
        loadingView.startAnimating()
        
        titleLabel.text = textGenerator.next()
        
        startTextSwitiching()
    }
    
    
    
    var timer: Timer?
    func startTextSwitiching() {
        timer = Timer.scheduledTimer(timeInterval: 1.8, target: self, selector: #selector(LoadingViewController.updateText), userInfo: nil, repeats: true)
    }
    
    func updateText() {
        if let text = textGenerator.next() {
            titleLabel.text = text
        } else {
            timer?.invalidate()
            timer = nil
            coordinator?.done(with: self)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
