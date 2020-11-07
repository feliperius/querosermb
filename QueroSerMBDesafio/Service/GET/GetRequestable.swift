//
//  GetRequestable.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 06/11/20.
//

import UIKit

protocol GetRequestable {
    func get(url: String, completionHandler: @escaping (Data?, NetworkError?) -> Void)
}
