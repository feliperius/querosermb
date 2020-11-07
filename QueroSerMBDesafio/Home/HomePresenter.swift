//
//  HomePresenter.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 06/11/20.
//

import Foundation

protocol HomePresenter: class {
    func fetchAssets(viewModels: [AssetViewModel])
    func onError(message: String)
    func showLoading()
    func hideLoading()
}
