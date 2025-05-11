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
        
        CryptoAPIService.shared.fetchCryptos(symbols: CryptoList.defaultSymbols) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let cryptos):
                self.cryptos = cryptos
                self.applySort()
                self.isLoading = false
                self.onUpdate?()
            case .failure(let error):
                self.isLoading = false
                self.cryptos = []
                self.onUpdate?()
                self.onError?(error.localizedDescription)
            }
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
