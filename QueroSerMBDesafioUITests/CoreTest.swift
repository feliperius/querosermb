//
//  CoreTest.swift
//  QueroSerMBDesafioUITests
//
//  Created by Felipe Perius on 09/11/20.
//
import Quick
import Nimble
import UIKit

class BaseTest: QuickSpec {
    var rootViewController: UIViewController? {
        didSet {
            if let _ = rootViewController {
                loadRootViewController()
            }
        }
    }

    private func loadRootViewController() {
        UIApplication.shared.windows.first?.rootViewController = rootViewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        if #available(iOS 13.0, *) {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
        } else {
            // Fallback on earlier versions
        }
    }
}

