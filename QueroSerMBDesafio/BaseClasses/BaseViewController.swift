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
        //navigationItem.leftBarButtonItem = closeBarButtonItem
    }
    
    func configMenuButton() {
        let button = UIButton(type: .custom)
        button.setImage(R.image.ic_menu()?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = ColorTheme.primary
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.applyNavBarConstraints(size: (width: 25, height: 30))
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = barButton
    }
    
    func configFilterButton() {
        let button = UIButton(type: .custom)
        button.setImage(R.image.ic_filter()?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = ColorTheme.primary
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.applyNavBarConstraints(size: (width: 25, height: 30))
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButton
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
