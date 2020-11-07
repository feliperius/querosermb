//
//  HomeInteractor.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 06/11/20.
//

import UIKit

final class HomeInteractor {
    private let apiClientService: ApiClient
    private weak var presenter: HomePresenter?
    
    init(apiClientService: ApiClient, presenter: HomePresenter?) {
        self.apiClientService = apiClientService
        self.presenter = presenter
    }
    
    func loadAssets() {
        presenter?.showLoading()
        apiClientService.assets(onSuccess: { [weak self] assets in
            let viewModels = assets.map(AssetViewModel.init)
            self?.presenter?.fetchAssets(viewModels: viewModels)
            self?.loadAssetIcons(assetsViewModels: viewModels)
            self?.presenter?.hideLoading()
        }) { [weak self] error in
            self?.presenter?.onError(message: error.localizedDescription)
            self?.presenter?.hideLoading()
        }
    }
    
    private func loadAssetIcons(assetsViewModels: [AssetViewModel]) {
        apiClientService.icons { [weak self] (icons) in
            var viewModels: [AssetViewModel] = []
            assetsViewModels.forEach { viewModel in
                let assetIcon = icons.first { assetIcon -> Bool in
                    viewModel.asssetId == assetIcon.assetId
                }
                viewModels.append(AssetViewModel(entity: assetIcon, viewModel: viewModel))
            }
            self?.presenter?.fetchAssets(viewModels: viewModels)
        }
    }
    
}
