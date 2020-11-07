//
//  AssetViewModel.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 05/11/20.
//

import UIKit

struct AssetViewModel {
    var icon: URL? = nil
    let name: String
    let asssetId: String
    var extras: [(String, String)] = []
    var allExtras: [(String, String)] = []
    
    init(entity: Asset) {
        name = entity.name
        asssetId = entity.assetId
    }
    
    init(entity: AssetIcon?, viewModel: AssetViewModel) {
        icon = entity?.url
        name = viewModel.name
        asssetId = viewModel.asssetId
        extras = viewModel.extras
        allExtras = viewModel.allExtras
    }
    
}
