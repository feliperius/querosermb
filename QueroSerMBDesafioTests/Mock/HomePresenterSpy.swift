//
//  AssetPresenter.swift
//  QueroSerMBDesafioTests
//
//  Created by Felipe Perius on 09/11/20.
//

@testable import QueroSerMBDesafio

final class HomePresenterSpy: HomePresenter {
    var invokedOnAssets = false
    var invokedOnAssetsCount = 0
    var invokedOnAssetsParameters: (viewModels: [AssetViewModel], Void)?
    var invokedOnAssetsParametersList = [(viewModels: [AssetViewModel], Void)]()

    func fetchAssets(viewModels: [AssetViewModel]) {
        invokedOnAssets = true
        invokedOnAssetsCount += 1
        invokedOnAssetsParameters = (viewModels, ())
        invokedOnAssetsParametersList.append((viewModels, ()))
    }

    var invokedOnError = false
    var invokedOnErrorCount = 0
    var invokedOnErrorParameters: (message: String, Void)?
    var invokedOnErrorParametersList = [(message: String, Void)]()

    func onError(message: String) {
        invokedOnError = true
        invokedOnErrorCount += 1
        invokedOnErrorParameters = (message, ())
        invokedOnErrorParametersList.append((message, ()))
    }

    var invokedShowLoading = false
    var invokedShowLoadingCount = 0

    func showLoading() {
        invokedShowLoading = true
        invokedShowLoadingCount += 1
    }

    var invokedHideLoading = false
    var invokedHideLoadingCount = 0

    func hideLoading() {
        invokedHideLoading = true
        invokedHideLoadingCount += 1
    }
}

