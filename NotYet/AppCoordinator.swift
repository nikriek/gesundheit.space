//
//  AppCoordinator.swift
//  NotYet
//
//  Created by Niklas Riekenbrauck on 25.11.16.
//  Copyright © 2016 Niklas Riekenbrauck. All rights reserved.
//

import UIKit

class AppCoordinator {
    func start(on window: UIWindow?) {
        guard let window = window else { return }
        
        let rootViewController = UIViewController()
        
        window.rootViewController = rootViewController
    }
}
