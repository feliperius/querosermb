//
//  BaseViewController.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 05/11/20.
//

import UIKit

class BaseViewController: UIViewController {
    var delegateAction: MBBaseAction?
    
    private var rootViewController: UIViewController? {
        let window = UIApplication.shared.delegate?.window
        let controller = window??.rootViewController
        if let viewControllerPresented = controller?.presentedViewController {
            return viewControllerPresented.visibleController
        }
        return controller
    }
    
    init() {
        delegateAction = nil
        super.init(nibName: nil, bundle: nil)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    init(delegate: MBBaseAction) {
        delegateAction = delegate
        super.init(nibName: nil, bundle: nil)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}
