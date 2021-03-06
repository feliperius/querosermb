//
//  ApplicationCoordinator.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 05/11/20.
//
import UIKit

protocol Coordinator: class {
    func start()
}

final class ApplicationCoordinator: Coordinator {
    private let window: UIWindow
    private let rootNavigationViewController: MBNavigationController
    private let assetService: AssetService
    private lazy var homeCoordinator: HomeCoordinator = {
        HomeCoordinator(navigationController: rootNavigationViewController, service: assetService)
    }()
    
    init(with window: UIWindow, service: AssetService) {
        self.window = window
        assetService = service
        rootNavigationViewController = MBNavigationController()
        rootNavigationViewController.configMenuButton()
        window.rootViewController = rootNavigationViewController
    }
    
    func start() {
        window.rootViewController = rootNavigationViewController
        window.makeKeyAndVisible()
        homeCoordinator.start()
    }
}



