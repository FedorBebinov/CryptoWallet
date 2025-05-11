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
        lbl.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        lbl.textColor = UIColor(red: 19/255, green: 22/255, blue: 34/255, alpha: 1)
        return lbl
    }()

    private let symbolLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        lbl.textColor = .systemGray
        return lbl
    }()

    private let priceLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        lbl.textColor = UIColor(red: 19/255, green: 22/255, blue: 34/255, alpha: 1)
        lbl.textAlignment = .right
        return lbl
    }()

    private let changeLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 13, weight: .regular)
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
            make.width.height.equalTo(40)
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }

        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(14)
            make.top.equalTo(iconView).offset(2)
        }

        symbolLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
        }

        priceLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(14)
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
        priceLabel.text = String(format: "$%.2f", crypto.price)

        let isUp = crypto.priceChange >= 0
        let sign = isUp ? "+" : ""
        changeLabel.text = "\(sign)\(String(format: "%.2f", crypto.priceChange))%"
        changeLabel.textColor = isUp ? .systemGreen : .systemRed
        let arrowName = isUp ? "arrow.up" : "arrow.down"
        arrowImageView.image = UIImage(systemName: arrowName)
        arrowImageView.tintColor = isUp ? .systemGreen : .systemRed
    }
}
