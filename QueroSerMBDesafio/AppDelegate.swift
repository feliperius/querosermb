//
//  AppDelegate.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 05/11/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        ApplicationCoordinator(with: window, service: AssetService(getRequest: GetRequest())).start()
        return true
    }
}

