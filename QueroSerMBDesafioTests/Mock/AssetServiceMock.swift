//
//  AssetServiceMock.swift
//  QueroSerMBDesafioTests
//
//  Created by Felipe Perius on 09/11/20.
//

@testable import QueroSerMBDesafio

final class AssetServiceMock: ApiClient {
    var invokedExchanges = false
    var invokedExchangesCount = 0
    var stubbedExchangesOnSuccessResult: ([Asset], Void)?
    var stubbedExchangesOnErrorResult: (NetworkError, Void)?
    
    init(assets: [Asset], assetsIcon: [AssetIcon]) {
        stubbedExchangesOnSuccessResult = (assets, ())
        stubbedIconsOnSuccessResult = (assetsIcon, ())
    }

    init(error: NetworkError) {
        stubbedExchangesOnErrorResult = (error, ())
    }
    
    func assets(onSuccess: @escaping ([Asset]) -> (), onError: @escaping (NetworkError) -> ()) {
        invokedExchanges = true
        invokedExchangesCount += 1
        if let result = stubbedExchangesOnSuccessResult {
            onSuccess(result.0)
        }
        if let result = stubbedExchangesOnErrorResult {
            onError(result.0)
        }
    }
    
    var invokedIcons = false
    var invokedIconsCount = 0
    var stubbedIconsOnSuccessResult: ([AssetIcon], Void)?

    func icons(onSuccess: @escaping ([AssetIcon]) -> ()) {
        invokedIcons = true
        invokedIconsCount += 1
        if let result = stubbedIconsOnSuccessResult {
            onSuccess(result.0)
        }
    }
}
