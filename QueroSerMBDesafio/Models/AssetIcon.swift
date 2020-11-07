//
//  AssetIcon.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 05/11/20.
//

import UIKit

struct AssetIcon: Decodable {
    
    let assetId: String
    let url: URL
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        assetId = try container.decode(String.self, forKey: .assetId)
        url = try container.decode(URL.self, forKey: .url)
    }
    
    enum CodingKeys: String, CodingKey {
        case assetId = "asset_id"
        case url
    }
    
}
