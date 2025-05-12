//
//  CryptoTableViewCell.swift
//  Crypto wallet
//
//  Created by Fedor Bebinov on 09.05.2025.
//

import UIKit
import SnapKit

final class CryptoTableViewCell: UITableViewCell {

    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return iv
    }()

    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .poppinsRegular(size: 18)
        lbl.textColor = UIColor(red: 19/255, green: 22/255, blue: 34/255, alpha: 1)
        return lbl
    }()

    private let symbolLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .poppinsRegular(size: 14)
        lbl.textColor = .systemGray
        return lbl
    }()

    private let priceLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .poppinsRegular(size: 18)
        lbl.textColor = UIColor(red: 38/255, green: 39/255, blue: 60/255, alpha: 1)
        lbl.textAlignment = .right
        return lbl
    }()

    private let changeLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .poppinsRegular(size: 14)
        lbl.textAlignment = .right
        return lbl
    }()

    private let arrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupLayout() {
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(changeLabel)
        contentView.addSubview(arrowImageView)

        iconView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.left.equalToSuperview().offset(25)
            make.centerY.equalToSuperview()
        }

        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(19)
            make.top.equalTo(iconView).offset(2)
        }

        symbolLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
        }

        priceLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(24)
            make.top.equalTo(nameLabel)
        }

        changeLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(2)
            make.right.equalTo(priceLabel)
        }

        arrowImageView.snp.makeConstraints { make in
            make.right.equalTo(changeLabel.snp.left).offset(-4)
            make.centerY.equalTo(changeLabel)
            make.size.equalTo(12)
        }
    }
    
    func configure(with crypto: Crypto) {
        iconView.image = UIImage(named: crypto.iconName)
            nameLabel.text = crypto.name
            symbolLabel.text = crypto.symbol

            let priceFormatter = NumberFormatter()
            priceFormatter.numberStyle = .decimal
            priceFormatter.locale = Locale(identifier: "en_US")
            priceFormatter.minimumFractionDigits = 2
            priceFormatter.maximumFractionDigits = 2

            let priceString = priceFormatter.string(from: NSNumber(value: crypto.price)) ?? "\(crypto.price)"
            priceLabel.text = "$\(priceString)"

            let isUp = crypto.priceChange >= 0

            let percentFormatter = NumberFormatter()
            percentFormatter.minimumFractionDigits = 1
            percentFormatter.maximumFractionDigits = 1
            percentFormatter.numberStyle = .decimal
            percentFormatter.locale = Locale(identifier: "en_US")
            let percentString = percentFormatter.string(from: NSNumber(value: abs(crypto.priceChange))) ?? "\(abs(crypto.priceChange))"

            changeLabel.text = "\(percentString)%"
            changeLabel.textColor = UIColor(red: 147/255, green: 149/255, blue: 164/255, alpha: 1)

            let arrowName = isUp ? "arrow.up" : "arrow.down"
            arrowImageView.image = UIImage(systemName: arrowName)
            arrowImageView.tintColor = isUp ? .systemGreen : .systemRed
    }
}
