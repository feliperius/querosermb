//
//  BaseViewController.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 05/11/20.
//

import UIKit
import SVProgressHUD
class BaseViewController: UIViewController {
    
    private var rootViewController: UIViewController? {
        let window = UIApplication.shared.delegate?.window
        let controller = window??.rootViewController
        if let viewControllerPresented = controller?.presentedViewController {
            return viewControllerPresented.visibleController
        }
        return controller
    }
    
    func configCloseButton() {
            //let closeBarButtonItem = UIBarButtonItem(image: Images.iconWhiteClose, style: .plain, target: self, action: #selector(closeModal))
           // navigationItem.leftBarButtonItem = closeBarButtonItem
    }
        
    func configBackButton() {
            //let backBarButtonItem = UIBarButtonItem(image: Images.iconBack, style: .plain, target: self, action: #selector(popView))
//            navigationItem.leftBarButtonItem = backBarButtonItem
//            backBarButtonItem.isAccessibilityElement = true
//            backBarButtonItem.accessibilityIdentifier = R.string.localizable.btnBackIdentifier()
//            backBarButtonItem.accessibilityLabel = R.string.localizable.btnBackIdentifier()
    }
    func displayLoading() {
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            window.isUserInteractionEnabled = false
        }
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setBackgroundColor(UIColor.orange)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setCornerRadius(4)
        SVProgressHUD.show()
    }
    
    func dismissLoading() {
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            window.isUserInteractionEnabled = true
        }
        SVProgressHUD.dismiss()
    }
}
