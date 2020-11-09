//
//  HomeCoordinatorRobot.swift
//  QueroSerMBDesafioUITests
//
//  Created by Felipe Perius on 09/11/20.
//
import Nimble
import Nimble_Snapshots
import UIKit

@testable import QueroSerMBDesafio

final class HomeCoordinatorRobotFactory {
      static func make(_ controllerSpec: BaseTest) -> HomeCoordinatorRobot {
          return HomeCoordinatorRobot(controllerSpec: controllerSpec)
      }
}

final class HomeCoordinatorRobot: BaseRobot {
    
    func load(service: AssetService) -> Self {
        let navigationController = UINavigationController()
        
        HomeCoordinator(navigationController: navigationController, service: service).start()
        
        controllerSpec.rootViewController = navigationController
        
        return self
    }
    
    func wiat() -> Self {
        tester.waitForAnimationsToFinish(withTimeout: 1)
        
        return self
    }
    
    func tapCell() -> Self {
        tester.tapView(withAccessibilityLabel: R.string.accessibility.assetCell())

        return self
    }
    
    func result() -> AssetCoordinatorResult {
        return AssetCoordinatorResult(controllerSpec: controllerSpec)
    }
    
}

final class AssetCoordinatorResult: BaseRobot {
    
    @discardableResult
    func checkExchangesList() -> AssetCoordinatorResult {
        let productList: UIView = tester.waitForView(withAccessibilityLabel: R.string.accessibility.exchangeList())
        
        expect(productList) == snapshot("assets_list")
        
        return self
    }
    
    @discardableResult
    func checkEmptyStateList() -> AssetCoordinatorResult {
        let productList: UIView = tester.waitForView(withAccessibilityLabel: R.string.accessibility.assetListList())
        
        expect(productList) == snapshot("assets_list_empty_state")
        
        return self
    }
    
    @discardableResult
    func checkErrorStateList() -> AssetCoordinatorResult {
        let productList: UIView = tester.waitForView(withAccessibilityLabel: R.string.accessibility.assetList())
        
        expect(productList) == snapshot("assets_list_list_error")
        
        return self
    }
    
    @discardableResult
    func checkExchangeDetail() -> AssetCoordinatorResult {
        let assetList: UIView = tester.waitForView(withAccessibilityLabel: R.string.accessibility.assetDetail())
        
        expect(exchangesList) == snapshot("application_asset_detail")
        
        return self
    }
    
}
