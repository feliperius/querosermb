//
//  NetworkError.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 06/11/20.
//
import Alamofire

enum NetworkError: Error {
    case mapping
    case weakConnection
    case offline
    case other(AFError?)
    var localizedDescription: String {
        switch self {
        case .mapping:
            return R.string.app.mapping()
        case .offline:
            return R.string.app.offline()
        default:
            return R.string.app.other()
        }
    }
}
