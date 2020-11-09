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
    let price: String
    let asssetId: String
    var extras: [(String, String)] = []
    var allTitles: [(String, String)] = []
    
    init(entity: Asset) {
        name = entity.name
        asssetId = entity.assetId
        price = "\(entity.priceUsd)".dolar()
       
        let lastTrade = (R.string.app.lastNegotiation(), "\(entity.dataTradeEnd.date())")
        let totalSymbols = (R.string.app.totalSymbols(), "\(entity.dataSymbolsCount)")
        let volume1Hr = (R.string.app.sumAnHour(), "\(entity.volume1HrsUsd)".dolar())
        
        extras.append(contentsOf: [lastTrade, totalSymbols, volume1Hr])
        
        allTitles.append((R.string.app.firstQuotation(), "\(entity.dataQuoteStart.date())"))
        allTitles.append((R.string.app.lastQuotation(), "\(entity.dataQuoteEnd.date())"))
        allTitles.append((R.string.app.firstNegotiation(), "\(entity.dataOrderbookStart.date())"))
        allTitles.append((R.string.app.lastPurchaseOrder(), "\(entity.dataOrderbookEnd.date())"))
        allTitles.append((R.string.app.firstNegotiation(), "\(entity.dataTradeStart.date())"))
        allTitles.append(contentsOf: [lastTrade, totalSymbols, volume1Hr])
        allTitles.append((R.string.app.sumAnday(), "\(entity.volume1DayUsd)".dolar()))
        allTitles.append((R.string.app.sumMonth(), "\(entity.volume1MthUsd)".dolar()))
    }
    
    init(entity: AssetIcon?, viewModel: AssetViewModel) {
        icon = entity?.url
        name = viewModel.name
        price = viewModel.price
        asssetId = viewModel.asssetId
        extras = viewModel.extras
        allTitles = viewModel.allTitles
    }
    
}
