//
//  HomeCoordinator.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 05/11/20.
//

import UIKit

final class HomeCoordinator {
    private let navigationController: UINavigationController
    private let assetService: AssetService
    private lazy var homeViewController: HomeViewController = {
        let viewController = HomeViewController(delegate: self, assetService: assetService)
        return viewController
    }()
    
    init(navigationController: UINavigationController,service: AssetService) {
        self.navigationController = navigationController
        self.assetService = service
        setupNavigationView()
    }
    
    private func setupNavigationView() {
        navigationController.view.accessibilityLabel = R.string.accessibility.navigationApplicaton()
    }
}

extension HomeCoordinator: Coordinator {
    func start() {
        navigationController.pushViewController(homeViewController, animated: true)
    }
}
extension HomeCoordinator: HomeDelegate {
    func didSelect(viewModel: AssetViewModel) {
        
    }
}

