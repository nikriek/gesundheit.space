//
//  DetailCell.swift
//  NotYet
//
//  Created by Niklas Riekenbrauck on 26.11.16.
//  Copyright © 2016 Niklas Riekenbrauck. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {
    static let identifier = "DetailCell"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
    }
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.customGray
        label.font = UIFont.systemFont(ofSize: 24)
        label.numberOfLines = 0
        
        self.contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView.snp.left).offset(24)
            make.right.equalTo(self.contentView.snp.centerX)
            make.top.equalTo(self.contentView.snp.top).offset(8)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-8)
        }
        
        return label
    }()
    
    lazy var measurementLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.customLightGray
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 24)
        label.numberOfLines = 0
        
        self.contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView.snp.centerX)
            make.right.equalTo(self.contentView.snp.right).offset(-24)
            make.top.equalTo(self.contentView.snp.top).offset(8)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-8)
        }
        
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
