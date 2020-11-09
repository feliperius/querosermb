//
//  MappperDataJson.swift
//  QueroSerMBDesafioTests
//
//  Created by Felipe Perius on 09/11/20.
//
import UIKit

final class MappperDataJson {
    static func dataJSON(file: String) -> Data {
        let bundle = Bundle(for: MappperDataJson.self)
        let path = bundle.path(forResource: file, ofType: "json")!
        let url = URL(fileURLWithPath: path)

        guard let data = try? Data(contentsOf: url, options: .alwaysMapped) else {
            assertionFailure("We cannot load data from this file: \(file)")

            return Data()
        }
        return data
    }
}
