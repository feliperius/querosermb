//
//  BaseCoordinator.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 05/11/20.
//
import UIKit

class BaseCoordinator: MBCoordinatorProtocol {
    var currentViewController: BaseViewController?
    var currentNavigationController: MBNavigationController?
    
    func start(with controller: BaseViewController) -> BaseViewController {
        currentViewController = controller
        return controller
    }
}
