//
//  RequestManager.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 06/11/20.
//
import Foundation

class RequestManager <Entity: Decodable> {
    func generate(_ data: Data?, _ error: NetworkError?) -> Result<[Entity], NetworkError> {
        if let data = data {
            do {
                let listCodable = try JSONDecoder().decode([Entity].self, from: data)
                return Result.success(listCodable)
            } catch {
                return Result.failure(.mapping)
            }
        } else if let error = error {
            return Result.failure(error)
        } else {
            return Result.failure(NetworkError.other(nil))
        }
    }
    
}
