//
//  MBNavigationController.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 05/11/20.
//

import UIKit

class MBNavigationController: UINavigationController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init() {
        super.init(nibName: nil, bundle: nil)
        configStyle()
    }
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        configStyle()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configStyle() {
         navigationBar.barStyle = .default
         navigationBar.tintColor = ColorTheme.navBarTint
         navigationBar.barTintColor = ColorTheme.navBarTint
         navigationBar.backgroundColor = ColorTheme.navBarTint
         navigationBar.isTranslucent = false
         navigationBar.shadowImage = UIImage()
     }
     

     func configBackButton() {
         let button = UIButton(type: .custom)
         button.setImage(UIImage(named: "")?.withRenderingMode(.alwaysTemplate), for: .normal)
         button.tintColor = ColorTheme.primary
         button.addTarget(self, action: #selector(back), for: .touchUpInside)
         button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
         button.applyNavBarConstraints(size: (width: 25, height: 30))
         let barButton = UIBarButtonItem(customView: button)
         navigationItem.leftBarButtonItem = barButton
     }

     override func viewDidLoad() {
         super.viewDidLoad()
         navigationBar.accessibilityLabel = "toolBar"
     }

     @objc func close() {
         dismiss(animated: true, completion: nil)
     }

     @objc func back() {
         navigationController?.popViewController(animated: true)
     }
}
