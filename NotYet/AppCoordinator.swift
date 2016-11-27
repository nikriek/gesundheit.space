//
//  AppCoordinator.swift
//  NotYet
//
//  Created by Niklas Riekenbrauck on 25.11.16.
//  Copyright © 2016 Niklas Riekenbrauck. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    func done<ViewModel>(with viewController: BaseOverviewViewController<ViewModel>)
    func done(with viewController: BaseOverviewViewController<HealthKitAuthorizationViewModel>)
    func done(with viewController: BaseOverviewViewController<KantaConnectViewModel>)
    func done(with viewController: LoadingViewController)
    func presentInsight(on viewController: UIViewController, recommendationId: Int)
    func presentInsightDetails(on viewController: UIViewController, recommendationId: Int)
    func done(on viewController: InsightDetailsViewController)
}

extension Coordinator {
    func done<ViewModel>(with viewController: BaseOverviewViewController<ViewModel>) {}
    func done(with viewController: BaseOverviewViewController<HealthKitAuthorizationViewModel>) {}
    func done(with viewController: BaseOverviewViewController<KantaConnectViewModel>) {}
    func done(with viewController: LoadingViewController) {}
    func presentInsight(on viewController: UIViewController, recommendationId: Int)  {}
    func presentInsightDetails(on viewController: UIViewController, recommendationId: Int) {}
    func done(on viewController: InsightDetailsViewController) {}
}

class AppCoordinator {
    func start(on window: UIWindow?) {
        guard let window = window else { return }
        
        let rootViewController = createHealthKitAuthorizationViewController()
        
        window.rootViewController = rootViewController
    }
}

extension AppCoordinator {
    fileprivate func createOverviewViewController() -> UIViewController {
        let viewModel = OverviewViewModel()
        let vc = BaseOverviewViewController(viewModel: viewModel)
        vc.coordinator = self
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        navigationController.view.backgroundColor = UIColor.clear

        return navigationController
    }
    
    fileprivate func createHealthKitAuthorizationViewController() -> UIViewController {
        let viewModel = HealthKitAuthorizationViewModel()
        let vc = BaseOverviewViewController(viewModel: viewModel)
        vc.coordinator = self
        return vc
    }
    
    fileprivate func createLoadingViewController() -> UIViewController {
        let vc = LoadingViewController()
        vc.coordinator = self
        return vc
    }
    
    fileprivate func createKantaConnectViewController() -> UIViewController {
        let viewModel = KantaConnectViewModel()
        let vc = BaseOverviewViewController(viewModel: viewModel)
        vc.coordinator = self
        return vc
    }
    
    fileprivate func createInsightViewController(recommendationId: Int) -> UIViewController {
        let viewModel = InsightViewModel(recommendationId: recommendationId)
        let vc = InsightViewController(viewModel: viewModel)
        vc.coordinator = self
        return vc
    }
    
    fileprivate func createInsightDetailsViewController(recommendationId: Int) -> UIViewController {
        let viewModel = InsightDetailsViewModel(recommendationId: recommendationId)
        let vc = InsightDetailsViewController(viewModel: viewModel)
        vc.coordinator = self
        return vc
    }
}

extension AppCoordinator: Coordinator {
    func done<ViewModel>(with viewController: BaseOverviewViewController<ViewModel>) {
        if let viewController = viewController as? BaseOverviewViewController<HealthKitAuthorizationViewModel> {
            done(with: viewController)
        } else if let viewController = viewController as? BaseOverviewViewController<KantaConnectViewModel> {
            done(with: viewController)
        }
    }
    
    func done(with viewController: BaseOverviewViewController<HealthKitAuthorizationViewModel>) {
        let kantaViewController = createKantaConnectViewController()
        viewController.present(kantaViewController, animated: false, completion: nil)
    }
    
    func done(with viewController: BaseOverviewViewController<KantaConnectViewModel>) {
        let loadingViewController = createLoadingViewController()
        viewController.present(loadingViewController, animated: false, completion: nil)
    }
    
    func done(with viewController: LoadingViewController) {
        let overviewViewController = createOverviewViewController()
        viewController.present(overviewViewController, animated: false, completion: nil)
    }
    
    func presentInsight(on viewController: UIViewController, recommendationId: Int) {
        guard (viewController as? BaseOverviewViewController<OverviewViewModel>) != nil else { return }
        let insightViewController = createInsightViewController(recommendationId: recommendationId)
        viewController.navigationController?.pushViewController(insightViewController, animated: true)
    }
    
    func presentInsightDetails(on viewController: UIViewController, recommendationId: Int) {
        guard let viewController = viewController as? InsightViewController else { return }
        let insightDetailsViewController = createInsightDetailsViewController(recommendationId: recommendationId)
        viewController.present(insightDetailsViewController, animated: true, completion: nil)
    }

    func done(on viewController: InsightDetailsViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }

}
