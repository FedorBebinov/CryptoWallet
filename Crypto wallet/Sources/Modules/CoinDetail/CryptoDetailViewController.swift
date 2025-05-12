//
//  CryptoDetailViewController.swift
//  Crypto wallet
//
//  Created by Fedor Bebinov on 08.05.2025.
//

import UIKit
import SnapKit

class CryptoDetailViewController: UIViewController {
    
    // MARK: - Public
    
    var onBack: (() -> Void)?
    
    // MARK: - Private
    
    private let viewModel: CryptoDetailViewModel
    
    // MARK: - UI Elements
    
    private let backBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 24
        return v
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .black
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsRegular(size: 14)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsRegular(size: 28)
        label.textColor = .priceText
        return label
    }()
    
    private let percentLabel: UILabel = {
        let label = UILabel()
        label.font = .poppinsRegular(size: 14)
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemGreen
        return iv
    }()
    
    private let periodControl: UISegmentedControl = {
        let control = UISegmentedControl(items: CryptoPeriod.allCases.map { $0.title })
        control.selectedSegmentIndex = 0
        control.backgroundColor = UIColor(white: 0.95, alpha: 1)
        if #available(iOS 13.0, *) {
            control.selectedSegmentTintColor = .white
        }
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor.lightGray
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor.black
        ]
        control.setTitleTextAttributes(normalAttributes, for: .normal)
        control.setTitleTextAttributes(selectedAttributes, for: .selected)
        return control
    }()
    
    private let statisticCard: UIView = {
        let v = UIView()
        v.backgroundColor = .statsColor
        v.layer.cornerRadius = 40
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        v.layer.masksToBounds = true
        return v
    }()
    
    private let statTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Market Statistic"
        l.font = .poppinsRegular(size: 20)
        l.textColor = .black
        return l
    }()
    
    private let marketCapTitle: UILabel = {
        let l = UILabel()
        l.text = "Market capitalization"
        l.font = .poppinsRegular(size: 14)
        l.textColor = .lightGray
        return l
    }()
    
    private let marketCapValue: UILabel = {
        let l = UILabel()
        l.font = .poppinsSemiBold(size: 14)
        l.textColor = .black
        l.textAlignment = .right
        return l
    }()
    
    private let circulatingTitle: UILabel = {
        let l = UILabel()
        l.text = "Circulating Supply"
        l.font = .poppinsRegular(size: 14)
        l.textColor = .lightGray
        return l
    }()
    
    private let circulatingValue: UILabel = {
        let l = UILabel()
        l.font = .poppinsSemiBold(size: 14)
        l.textColor = .black
        l.textAlignment = .right
        return l
    }()
    
    // MARK: - Init
    
    init(viewModel: CryptoDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        setupUI()
        bindViewModel()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.addSubview(backBackground)
        backBackground.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(18)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.width.height.equalTo(48)
        }
        backBackground.addSubview(backButton)
        backButton.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        
        view.addSubview(titleLabel)
        view.addSubview(priceLabel)
        view.addSubview(percentLabel)
        view.addSubview(periodControl)
        view.addSubview(statisticCard)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backBackground.snp.centerY)
            $0.centerX.equalToSuperview()
        }
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(22)
            $0.centerX.equalToSuperview()
        }
        percentLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints {
            $0.centerY.equalTo(percentLabel)
            $0.right.equalTo(percentLabel.snp.left).offset(-8)
            $0.size.equalTo(16)
        }
        
        periodControl.addTarget(self, action: #selector(periodChanged), for: .valueChanged)
        periodControl.snp.makeConstraints {
            $0.top.equalTo(percentLabel.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(280)
            $0.height.equalTo(38)
        }
        
        statisticCard.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(0)
            $0.height.equalTo(160)
        }
        
        statisticCard.addSubview(statTitleLabel)
        statisticCard.addSubview(marketCapTitle)
        statisticCard.addSubview(marketCapValue)
        statisticCard.addSubview(circulatingTitle)
        statisticCard.addSubview(circulatingValue)
        
        statTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.left.equalToSuperview().offset(25)
        }
        marketCapTitle.snp.makeConstraints {
            $0.left.equalTo(statTitleLabel.snp.left)
            $0.top.equalTo(statTitleLabel.snp.bottom).offset(15)
            $0.right.lessThanOrEqualTo(statisticCard.snp.centerX)
        }
        marketCapValue.snp.makeConstraints {
            $0.centerY.equalTo(marketCapTitle.snp.centerY)
            $0.right.equalToSuperview().inset(25)
        }
        circulatingTitle.snp.makeConstraints {
            $0.left.equalTo(statTitleLabel.snp.left)
            $0.top.equalTo(marketCapTitle.snp.bottom).offset(15)
            $0.right.lessThanOrEqualTo(statisticCard.snp.centerX)
        }
        circulatingValue.snp.makeConstraints {
            $0.centerY.equalTo(circulatingTitle.snp.centerY)
            $0.right.equalToSuperview().inset(25)
        }
    }
    
    private func bindViewModel() {
        titleLabel.text = "\(viewModel.name) (\(viewModel.symbol))"
        priceLabel.text = viewModel.priceFormatted
        percentLabel.text = viewModel.percentFormatted
        percentLabel.textColor = viewModel.percentColor
        arrowImageView.image = UIImage(named: viewModel.arrowImageName)
        arrowImageView.tintColor = viewModel.arrowColor
        marketCapValue.text = viewModel.marketCapFormatted
        circulatingValue.text = viewModel.circulatingSupplyFormatted
        
        viewModel.onPeriodChanged = { period in
            // Если появятся графики, для последующего расширения
            print("Period selected: \(period.title)")
        }
    }
    
    // MARK: - Actions
    
    @objc private func backTapped() {
        onBack?()
    }
    
    @objc private func periodChanged() {
        viewModel.setPeriod(index: periodControl.selectedSegmentIndex)
    }
}
