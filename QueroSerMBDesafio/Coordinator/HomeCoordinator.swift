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
    }
}

extension HomeCoordinator: Coordinator {
    func start() {
        navigationController.pushViewController(homeViewController, animated: true)
    }
}
extension HomeCoordinator: HomeDelegate {
    func didSelect(viewModel: AssetViewModel) {
        let assetDetailViewController = AssetDetailViewController()
        assetDetailViewController.viewModel = viewModel
        assetDetailViewController.title = viewModel.asssetId
        navigationController.pushViewController(assetDetailViewController, animated: true)
    }
}

