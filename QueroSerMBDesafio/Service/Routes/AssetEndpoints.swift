//
//  AssetServiceRouter.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 06/11/20.
//

import UIKit

enum AssetEndpoints: String {
    case getAssets
    case getIcons
    
    var path: String {
        switch self {
        case .getAssets:
            return  ApiConstants.baseURL + ApiConstants.version + ApiConstants.assets
        case .getIcons:
            return ApiConstants.baseURL + ApiConstants.version + ApiConstants.assetIcon
        }
    }
}
