//
//  ChartCell.swift
//  NotYet
//
//  Created by Niklas Riekenbrauck on 26.11.16.
//  Copyright © 2016 Niklas Riekenbrauck. All rights reserved.
//

import UIKit

class ChartCell: UITableViewCell {
    static let identifier = "ImageCell"
    
    lazy var chartView: UIImageView = {
        let imageview = UIImageView()
        
        self.contentView.addSubview(imageview)
        imageview.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView.snp.edges)
        }
        
        return imageview
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
