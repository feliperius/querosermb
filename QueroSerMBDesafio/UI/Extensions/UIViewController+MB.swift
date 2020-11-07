import UIKit

extension UIViewController {
    var isModallyPresented: Bool {
        if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }

    var visibleController: UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.visibleController
        } else if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.visibleController
        } else if let presentedViewController = presentedViewController {
            return presentedViewController.visibleController
        } else if self is UIAlertController {
            return nil
        } else {
            return self
        }
    }
}
