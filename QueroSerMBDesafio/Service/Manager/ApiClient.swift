//
//  ServiceManger.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 06/11/20.
//

import UIKit

protocol ApiClient {
    func assets(onSuccess: @escaping ([Asset]) -> (), onError: @escaping (NetworkError) -> ())
    func icons(onSuccess: @escaping ([AssetIcon]) -> ())
}
