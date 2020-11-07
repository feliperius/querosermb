//
//  BaseCoordinator.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 05/11/20.
//
import UIKit

protocol MBBaseAction: class {}

class BaseCoordinator: MBCoordinatorProtocol, MBBaseAction {
    var currentViewController: BaseViewController?
    var currentNavigationController: MBNavigationController?

    func start() -> BaseViewController {
        let controller = BaseViewController(delegate: self)
        currentViewController = controller
        return controller
    }
    
    func start(with controller: BaseViewController) -> BaseViewController {
        currentViewController = controller
        return controller
    }
}
