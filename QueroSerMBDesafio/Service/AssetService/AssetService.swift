//
//  AssetService.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 06/11/20.
//
import Foundation

final class AssetService {
    private let getRequest: GetRequestable
    
    init(getRequest: GetRequestable) {
        self.getRequest = getRequest
    }
}

extension AssetService: ApiClient {
    func assets(onSuccess: @escaping ([Asset]) -> (), onError: @escaping (NetworkError) -> ()) {
        getRequest.get(url: AssetEndpoints.getAssets.path) { (data, error) in
            let result = RequestManager<Asset>().generate(data, error)
            switch result {
            case .success(let assets):
                onSuccess(assets)
            case .failure(let error):
                onError(error)
            }
        }
    }
    
    func icons(onSuccess: @escaping ([AssetIcon]) -> ()) {
        getRequest.get(url: AssetEndpoints.getIcons.path)  { (data, error) in
            let result = RequestManager<AssetIcon>().generate(data, error)
            switch result {
            case .success(let icons):
                onSuccess(icons)
            case .failure(_): break
            }
        }
    }
    
}
