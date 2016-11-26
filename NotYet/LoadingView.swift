//
//  LoadingView.swift
//  NotYet
//
//  Created by Niklas Riekenbrauck on 26.11.16.
//  Copyright © 2016 Niklas Riekenbrauck. All rights reserved.
//

import UIKit
import SnapKit


class LoopGenerator<Item>: IteratorProtocol {
    let items: [Item]
    
    var currentIndex = 0
    
    init(items: [Item]) {
        self.items = items
    }
    
    func next() -> Item? {
        let image = items[currentIndex]
        currentIndex = (currentIndex + 1) % items.count
        return image
    }
}


class LoadingView: UIView {
    let icons: [UIImage]
    
    private lazy var imageGenerator: LoopGenerator<UIImage> = {
        return LoopGenerator(items: self.icons)
    }()
    
    init(icons: [UIImage]) {
        self.icons = icons
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.alpha = 0
        
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(self.snp.edges)
        }
        
        imageView.image = self.imageGenerator.next()
        
        return imageView
    }()
    
    func startAnimating() {
        fadeIn()
    }
    
    func stopAnimating() {
        layer.removeAllAnimations()
        imageView.alpha = 0.0
    }
    
    private func fadeIn() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: { [weak self] in
            self?.imageView.alpha = 1.0
        }, completion: { [weak self] _ in
            self?.fadeOut()
        })
    }
    
    private func fadeOut() {
        UIView.animate(withDuration: 0.1, delay: 0.8, options: [], animations: { [weak self] in
            self?.imageView.alpha = 0.0
        }, completion: { [weak self] _ in
            self?.imageView.image = self?.imageGenerator.next()
            self?.fadeIn()
        })
    }
    
    
}
