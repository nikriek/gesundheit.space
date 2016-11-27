//
//  ChartCell.swift
//  NotYet
//
//  Created by Niklas Riekenbrauck on 26.11.16.
//  Copyright © 2016 Niklas Riekenbrauck. All rights reserved.
//

import UIKit
import WebKit

class ChartCell: UITableViewCell {
    static let identifier = "ImageCell"
    
    lazy var chartView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()

        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        
        self.contentView.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.leading.equalTo(self.contentView.snp.leading)
            make.trailing.equalTo(self.contentView.snp.trailing)
            make.top.equalTo(self.contentView.snp.top)
            make.height.equalTo(240)
            make.bottom.equalTo(self.contentView.snp.bottom)
        }
        webView.isUserInteractionEnabled = false
        
        return webView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
