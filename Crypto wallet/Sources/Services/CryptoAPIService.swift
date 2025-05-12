//
//  CryptoAPIService.swift
//  Crypto wallet
//
//  Created by Fedor Bebinov on 11.05.2025.
//

import Foundation

final class CryptoAPIService {
    static let shared = CryptoAPIService()
    private init() {}
    
    private let baseURL = "https://data.messari.io/api/v1/assets"
    
    func fetchCryptos(symbols: [String], completion: @escaping (Result<[Crypto], Error>) -> Void) {
        var cryptos: [Crypto] = []
        let group = DispatchGroup()
        var lastError: Error?
        
        for symbol in symbols {
            group.enter()
            fetchCrypto(symbol: symbol) { result in
                switch result {
                case .success(let crypto):
                    cryptos.append(crypto)
                case .failure(let error):
                    lastError = error
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if !cryptos.isEmpty {
                completion(.success(cryptos))
            } else if let error = lastError {
                completion(.failure(error))
            } else {
                completion(.failure(NSError(domain: "No data received", code: -1)))
            }
        }
    }
    
    private func fetchCrypto(symbol: String, completion: @escaping (Result<Crypto, Error>) -> Void) {
        let urlString = "\(baseURL)/\(symbol)/metrics"
        guard let url = URL(string: urlString) else {
            return completion(.failure(NSError(domain: "Invalid URL", code: -1)))
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }
            guard let data = data else {
                return completion(.failure(NSError(domain: "No Data", code: -1)))
            }
            
            do {
                let decoded = try JSONDecoder().decode(CryptoResponse.self, from: data)
                let data = decoded.data
                let marketData = data.market_data
                
                let marketCap = data.marketcap.current_marketcap_usd
                let circulating = data.supply.circulating
                
                let crypto = Crypto(
                    name: data.name,
                    symbol: data.symbol.uppercased(),
                    iconName: data.symbol.lowercased(),
                    price: marketData.price_usd,
                    priceChange: marketData.percent_change_usd_last_24_hours,
                    marketCap: marketCap,
                    circulatingSupply: circulating
                )
                completion(.success(crypto))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
