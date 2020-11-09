//
//  AssetsMock.swift
//  QueroSerMBDesafioTests
//
//  Created by Felipe Perius on 09/11/20.
//
import Foundation

@testable import QueroSerMBDesafio

struct AssetsMock {
    static let assets = try? JSONDecoder().decode([Asset].self, from: MappperDataJson.dataJSON(file: "assets"))
    
    static let icons = try? JSONDecoder().decode([AssetIcon].self, from: MappperDataJson.dataJSON(file: "iconAssets"))
}
