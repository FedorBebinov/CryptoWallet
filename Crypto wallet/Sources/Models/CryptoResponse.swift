//
//  CryptoResponse.swift
//  Crypto wallet
//
//  Created by Fedor Bebinov on 11.05.2025.
//

import Foundation

struct CryptoResponse: Decodable {
    let data: CryptoData
}

struct CryptoData: Decodable {
    let name: String
    let symbol: String
    let market_data: MarketData
    let marketcap: MarketCap
    let supply: Supply
}

struct MarketData: Decodable {
    let price_usd: Double
    let percent_change_usd_last_24_hours: Double
}

struct MarketCap: Decodable {
    let current_marketcap_usd: Double?
}

struct Supply: Decodable {
    let circulating: Double?
}
