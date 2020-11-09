//
//  AssetInteractorSpec.swift
//  QueroSerMBDesafioTests
//
//  Created by Felipe Perius on 09/11/20.
//

import Quick
import Nimble

@testable import QueroSerMBDesafio

final class HomeInteractorSpec: QuickSpec {
    var service: AssetServiceMock!
    var spy: HomePresenterSpy!
    var sut: HomeInteractor!
    
    var assets: [Asset] {
        let result = service.stubbedExchangesOnSuccessResult?.0
        return result!
    }
    
    var assetsAdapters: [AssetViewModel] {
        return self.spy.invokedOnAssetsParameters!.viewModels
    }
    
    func setupAssets() {
        service = AssetServiceMock(assets: AssetsMock.assets!, assetsIcon: AssetsMock.icons!)
        spy = HomePresenterSpy()
        sut = HomeInteractor(apiClientService: service, presenter: spy)
    }
    
    func setupEmptyAssets() {
        service = AssetServiceMock(assets:[], assetsIcon: [])
        spy = HomePresenterSpy()
        sut = HomeInteractor(apiClientService: service, presenter: spy)
    }
    
    func setupErrorAssets() {
        service = AssetServiceMock(error: .offline)
        spy = HomePresenterSpy()
        sut = HomeInteractor(apiClientService: service, presenter: spy)
    }
    
    override func spec() {
        describe("loadAssets") {
            context("When assets are loaded successfully") {
                beforeEach {
                    self.setupAssets()
                    self.sut.loadAssets()
                }
                
                it("should display loading") {
                    expect(self.spy.invokedShowLoading).to(equal(true))
                }
                
                it("should display loading only once") {
                    expect(self.spy.invokedShowLoadingCount).to(equal(1))
                }
                
                it("should call the gateway method that loads the exchange list") {
                    expect(self.spy.invokedOnAssets).to(equal(true))
                }
                
                it("The loading should be removed from the screen") {
                    expect(self.spy.invokedHideLoading).to(equal(true))
                }
                
                it("The loading should be removed from the screen only once") {
                    expect(self.spy.invokedHideLoadingCount).to(equal(1))
                }
            }
            
            context("When assets are loaded with an empty list") {
                beforeEach {
                    self.setupEmptyAssets()
                    self.sut.loadAssets()
                }
                
                it("should display loading") {
                    expect(self.spy.invokedShowLoading).to(equal(true))
                }
                
                it("should display loading only once") {
                    expect(self.spy.invokedShowLoadingCount).to(equal(1))
                }
                
                it("should call the gateway method that loads the exchange list") {
                    expect(self.spy.invokedOnAssets).to(equal(true))
                }
                
                it("should call the gateway method that loads the exchange list only once") {
                    expect(self.spy.invokedShowLoadingCount).to(equal(1))
                }
                
                it("There should be no exchange") {
                    expect(self.assets.count).to(equal(0))
                }
                
                it("None exchanges should be shown in the list") {
                    expect(self.assets.count).to(equal(0))
                }
                
                it("The loading should be removed from the screen") {
                    expect(self.spy.invokedHideLoading).to(equal(true))
                }
                
                it("The loading should be removed from the screen only once") {
                    expect(self.spy.invokedHideLoadingCount).to(equal(1))
                }
            }
            
            context("When assets are not loaded") {
                beforeEach {
                    self.setupErrorAssets()
                    self.sut.loadAssets()
                }
                
                it("should display loading") {
                    expect(self.spy.invokedShowLoading).to(equal(true))
                }
                
                it("should display loading only once") {
                    expect(self.spy.invokedShowLoadingCount).to(equal(1))
                }
                
                it("should call the gateway method that loads the asset list only once") {
                    expect(self.spy.invokedShowLoadingCount).to(equal(1))
                }
                
                it("An error should be shown") {
                    expect(self.spy.invokedShowLoading).to(equal(true))
                }
                
                it("An error should be shown only once") {
                    expect(self.spy.invokedShowLoadingCount).to(equal(1))
                }
                
                it("the error message should be `You are currently offline.`") {
                    let message = self.spy.invokedOnErrorParameters?.message
                    expect(message).to(equal("You are currently offline."))
                }
                
                it("The loading should be removed from the screen") {
                    expect(self.spy.invokedHideLoading).to(equal(true))
                }
                
                it("The loading should be removed from the screen only once") {
                    expect(self.spy.invokedHideLoadingCount).to(equal(1))
                }
            }
        }
        
    }
    
}

