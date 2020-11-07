//
//  Asset.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 05/11/20.
//

import Foundation

struct Asset: Decodable {
    let assetId: String
    let website: String
    let name: String
    let typeIsCrypto: Int
    let dataStart: String
    let dataEnd: String
    let dataQuoteStart: String
    let dataQuoteEnd: String
    let dataOrderbookStart: String
    let dataOrderbookEnd: String
    let dataTradeStart: String
    let dataTradeEnd: String
    let dataSymbolsCount: Int
    let volume1HrsUsd: Double
    let volume1DayUsd: Double
    let volume1MthUsd: Double
    let priceUsd: Double
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        assetId = try container.decode(String.self, forKey: .assetId)
        website = try container.decode(String.self, forKey: .website)
        name = try container.decode(String.self, forKey: .name)
        typeIsCrypto = (try? container.decode(Int.self, forKey: .typeIsCrypto)) ?? 0
        dataStart = (try? container.decode(String.self, forKey: .dataStart)) ?? ""
        dataEnd = (try? container.decode(String.self, forKey: .dataEnd)) ?? ""
        dataQuoteStart = (try? container.decode(String.self, forKey: .dataQuoteStart)) ?? ""
        dataQuoteEnd = (try? container.decode(String.self, forKey: .dataQuoteEnd)) ?? ""
        dataOrderbookStart = (try? container.decode(String.self, forKey: .dataOrderbookStart)) ?? ""
        dataOrderbookEnd = (try? container.decode(String.self, forKey: .dataOrderbookEnd)) ?? ""
        dataTradeStart = (try? container.decode(String.self, forKey: .dataTradeStart)) ?? ""
        dataTradeEnd = (try? container.decode(String.self, forKey: .dataTradeEnd)) ?? ""
        dataSymbolsCount = (try? container.decode(Int.self, forKey: .dataSymbolsCount)) ?? 0
        volume1HrsUsd = (try? container.decode(Double.self, forKey: .volume1HrsUsd)) ?? 0.0
        volume1DayUsd = (try? container.decode(Double.self, forKey: .volume1DayUsd)) ?? 0.0
        volume1MthUsd = (try? container.decode(Double.self, forKey: .volume1MthUsd)) ?? 0.0
        priceUsd = (try? container.decode(Double.self, forKey: .priceUsd)) ?? 0.0
    }
    
    enum CodingKeys: String, CodingKey {
        case assetId = "asset_id"
        case website
        case name
        case typeIsCrypto = "type_is_crypto"
        case dataStart = "data_start"
        case dataEnd = "data_end"
        case dataQuoteStart = "data_quote_start"
        case dataQuoteEnd = "data_quote_end"
        case dataOrderbookStart = "data_orderbook_start"
        case dataOrderbookEnd = "data_orderbook_end"
        case dataTradeStart = "data_trade_start"
        case dataTradeEnd = "data_trade_end"
        case dataSymbolsCount = "data_symbols_count"
        case volume1HrsUsd = "volume_1hrs_usd"
        case volume1DayUsd = "volume_1day_usd"
        case volume1MthUsd = "volume_1mth_usd"
        case priceUsd = "price_usd"
    }

}
