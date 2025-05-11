//
//  CryptoListViewModel.swift
//  Crypto wallet
//
//  Created by Fedor Bebinov on 09.05.2025.
//

import Foundation

enum CryptoSortType {
    case price
    case topGrowth
    case topDrop
}

final class CryptoListViewModel {
    private(set) var cryptos: [Crypto] = []
    private(set) var sortType: CryptoSortType = .price
    var isLoading: Bool = false

    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLogout: (() -> Void)?
    var onCoinSelect: ((Crypto) -> Void)?
    
    // MARK: - Public API

    func start() {
        fetchData()
    }

    func reload() {
        fetchData()
    }

    var count: Int { cryptos.count }
    func crypto(at index: Int) -> Crypto {
        cryptos[index]
    }
        
    func setSort(_ type: CryptoSortType) {
        sortType = type
        applySort()
        onUpdate?()
    }

    func didSelectCoin(at index: Int) {
        guard cryptos.indices.contains(index) else { return }
        onCoinSelect?(cryptos[index])
    }

    func logout() {
        onLogout?()
    }
    
    // MARK: - Data simulation and logic
    
    private func fetchData() {
        isLoading = true
        onUpdate?()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            // SAMPLE DATA
            self.cryptos = [
                Crypto(name: "Bitcoin", symbol: "BTC", iconName: "bitcoin", price: 32128.8, priceChange: 0.025),
                Crypto(name: "Neo", symbol: "NEO", iconName: "neo", price: 13221.55, priceChange: 0.022),
                Crypto(name: "Achain", symbol: "ACT", iconName: "achain", price: 28312.22, priceChange: -0.022)
            ]
            self.applySort()
            self.isLoading = false
            self.onUpdate?()
        }
    }
    
    private func applySort() {
        switch sortType {
        case .price:
            cryptos.sort { $0.price > $1.price }
        case .topGrowth:
            cryptos.sort { $0.priceChange > $1.priceChange }
        case .topDrop:
            cryptos.sort { $0.priceChange < $1.priceChange }
        }
    }
}
