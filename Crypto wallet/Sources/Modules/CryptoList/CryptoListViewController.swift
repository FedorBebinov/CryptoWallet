//
//  CryptoListViewController.swift
//  Crypto wallet
//
//  Created by Fedor Bebinov on 08.05.2025.
//

import UIKit
import SnapKit

final class CryptoListViewController: UIViewController {
    // MARK: - Properties
    
    let viewModel: CryptoListViewModel
    private var didSetupLayout = false
    private var isMenuVisible = false
    
    // UI
    private let headerBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .topPink
        return view
    }()
    
    private let styleImageView = UIImageView(image: UIImage(named: "styleImage"))
    
    private let homeLabel: UILabel = {
        let l = UILabel()
        l.text = "Home"
        l.font = .poppinsSemiBold(size: 32)
        l.textColor = .white
        return l
    }()
    
    private let dotsButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        b.tintColor = .black
        b.backgroundColor = .tableBackground
        b.layer.cornerRadius = 24
        b.layer.masksToBounds = true
        b.layer.borderWidth = 1
        b.layer.borderColor = UIColor(white: 1, alpha: 0.16).cgColor
        return b
    }()
    
    private let affiliateLabel: UILabel = {
        let l = UILabel()
        l.text = "Affiliate program"
        l.font = .poppinsRegular(size: 20)
        l.textColor = .white
        return l
    }()
    
    private let learnMoreButton: UIButton = {
        let btn = UIButton(type: .system)
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.baseBackgroundColor = .white
            config.baseForegroundColor = .black
            config.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 23, bottom: 7, trailing: 23)
            config.cornerStyle = .capsule
            config.attributedTitle = AttributedString(
                "Learn more",
                attributes: AttributeContainer([
                    .font: UIFont.poppinsSemiBold(size: 14)
                ])
            )
            btn.configuration = config
            btn.layer.cornerRadius = 16
            btn.clipsToBounds = true
        } else {
            btn.setTitle("Learn more", for: .normal)
            btn.setTitleColor(.black, for: .normal)
            btn.titleLabel?.font = .poppinsSemiBold(size: 14)
            btn.backgroundColor = .white
            btn.layer.cornerRadius = 16
            btn.clipsToBounds = true
            btn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 18, bottom: 4, right: 18)
        }
        return btn
    }()
    
    private let tableHeaderContainer: UIView = {
        let v = UIView()
        v.backgroundColor = .tableBackground
        v.layer.cornerRadius = 32
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        v.layer.masksToBounds = true
        return v
    }()
    
    private let trendingLabel: UILabel = {
        let l = UILabel()
        l.text = "Trending"
        l.font = .poppinsRegular(size: 20)
        l.textColor = .black
        return l
    }()
    
    private let sortButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(resource: .sortList), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.backgroundColor = .tableBackground
        tv.rowHeight = 70
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let loadingLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Loading..."
        lbl.font = .poppinsRegular(size: 16)
        lbl.textColor = .gray
        return lbl
    }()
    
    private let refreshControl = UIRefreshControl()
    
    private let menuView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.07
        view.layer.shadowRadius = 16
        view.layer.shadowOffset = CGSize(width: 0, height: 8)
        view.clipsToBounds = false
        return view
    }()
    
    private let menuStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let refreshMenuButton: UIButton = {
        let btn = UIButton(type: .system)
        let icon = UIImage(named: "reloadRocket")
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.image = icon
            config.baseForegroundColor = .blackText
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
            config.imagePadding = 8
            config.attributedTitle = AttributedString(
                "  Обновить",
                attributes: AttributeContainer([
                    .font: UIFont.poppinsRegular(size: 18)
                ])
            )
            btn.configuration = config
            btn.contentHorizontalAlignment = .leading
            btn.semanticContentAttribute = .forceLeftToRight
        } else {
            btn.setTitle("  Обновить", for: .normal)
            btn.setTitleColor(.blackText, for: .normal)
            btn.titleLabel?.font = .poppinsRegular(size: 18)
            btn.setImage(icon, for: .normal)
            btn.tintColor = .grayText
            btn.contentHorizontalAlignment = .left
            btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        return btn
    }()
    
    
    private let logoutMenuButton: UIButton = {
        let btn = UIButton(type: .system)
        let icon = UIImage(named: "logoutBin")
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.image = icon
            config.baseForegroundColor = .blackText
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
            config.imagePadding = 8
            config.attributedTitle = AttributedString(
                "  Выйти",
                attributes: AttributeContainer([
                    .font: UIFont.poppinsRegular(size: 18)
                ])
            )
            btn.configuration = config
            btn.contentHorizontalAlignment = .leading
            btn.semanticContentAttribute = .forceLeftToRight
        } else {
            btn.setTitle("  Выйти", for: .normal)
            btn.setTitleColor(.blackText, for: .normal)
            btn.titleLabel?.font = .poppinsRegular(size: 18)
            btn.setImage(icon, for: .normal)
            btn.tintColor = .grayText
            btn.contentHorizontalAlignment = .left
            btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        return btn
    }()
    
    private var menuBackgroundTap: UITapGestureRecognizer?
    private var overlayView: UIView?
    
    // MARK: - Init
    
    init(viewModel: CryptoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        setupLayout()
        setupActions()
        setupTable()
        bindViewModel()
        viewModel.start()
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        
        navigationController?.isNavigationBarHidden = true
        guard !didSetupLayout else { return }
        didSetupLayout = true
        
        view.addSubview(headerBackgroundView)
        headerBackgroundView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(280)
        }
        
        headerBackgroundView.addSubview(styleImageView)
        styleImageView.snp.makeConstraints { make in
            make.width.height.equalTo(195)
            make.left.equalToSuperview().offset(200)
            make.top.equalToSuperview().offset(119)
        }
        
        headerBackgroundView.addSubview(homeLabel)
        homeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(62)
        }
        headerBackgroundView.addSubview(dotsButton)
        dotsButton.snp.makeConstraints { make in
            make.centerY.equalTo(homeLabel)
            make.right.equalToSuperview().inset(18)
            make.width.height.equalTo(48)
        }
        headerBackgroundView.addSubview(affiliateLabel)
        affiliateLabel.snp.makeConstraints { make in
            make.left.equalTo(homeLabel)
            make.top.equalTo(homeLabel.snp.bottom).offset(24)
        }
        headerBackgroundView.addSubview(learnMoreButton)
        learnMoreButton.snp.makeConstraints { make in
            make.left.equalTo(homeLabel)
            make.top.equalTo(affiliateLabel.snp.bottom).offset(14)
            make.height.equalTo(32)
        }
        view.addSubview(tableHeaderContainer)
        tableHeaderContainer.snp.makeConstraints { make in
            make.top.equalTo(headerBackgroundView.snp.bottom).offset(-24)
            make.left.right.bottom.equalToSuperview()
        }
        tableHeaderContainer.addSubview(trendingLabel)
        trendingLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(22)
            make.top.equalToSuperview().offset(22)
        }
        tableHeaderContainer.addSubview(sortButton)
        sortButton.snp.makeConstraints { make in
            make.centerY.equalTo(trendingLabel)
            make.right.equalToSuperview().inset(22)
            make.width.height.equalTo(32)
        }
        tableHeaderContainer.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(trendingLabel.snp.bottom).offset(6)
            make.left.right.bottom.equalToSuperview()
        }
        tableHeaderContainer.addSubview(activityIndicator)
        tableHeaderContainer.addSubview(loadingLabel)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        loadingLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(activityIndicator.snp.bottom).offset(14)
        }
        
        headerBackgroundView.bringSubviewToFront(dotsButton)
    }
    
    // MARK: - Actions
    
    private func setupActions() {
        dotsButton.addTarget(self, action: #selector(showCustomMenu), for: .touchUpInside)
        learnMoreButton.addTarget(self, action: #selector(learnMoreTapped), for: .touchUpInside)
        refreshMenuButton.addTarget(self, action: #selector(handleRefreshTap), for: .touchUpInside)
        logoutMenuButton.addTarget(self, action: #selector(handleLogoutTap), for: .touchUpInside)
        
        let byPrice = UIAction(title: "По цене", image: UIImage(systemName: "dollarsign.circle")) { [weak self] _ in
            self?.viewModel.setSort(.price)
        }
        let byGrowth = UIAction(title: "По росту", image: UIImage(systemName: "arrow.up.right")) { [weak self] _ in
            self?.viewModel.setSort(.topGrowth)
        }
        let byDrop = UIAction(title: "По падению", image: UIImage(systemName: "arrow.down.right")) { [weak self] _ in
            self?.viewModel.setSort(.topDrop)
        }
        let menu = UIMenu(title: "Сортировка", options: .displayInline, children: [byPrice, byGrowth, byDrop])
        sortButton.menu = menu
        sortButton.showsMenuAsPrimaryAction = true
    }
    
    @objc private func showCustomMenu() {
        if isMenuVisible {
            hideCustomMenu()
            return
        }
        
        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = UIColor.clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeMenuOnBackground))
        overlay.addGestureRecognizer(tap)
        overlay.isUserInteractionEnabled = true
        view.addSubview(overlay)
        self.overlayView = overlay
        
        if menuStack.arrangedSubviews.isEmpty {
            menuStack.addArrangedSubview(refreshMenuButton)
            menuStack.addArrangedSubview(logoutMenuButton)
        }
        menuView.addSubview(menuStack)
        menuStack.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(menuView)
        let width: CGFloat = 160
        let height: CGFloat = 86
        let buttonFrame = dotsButton.superview?.convert(dotsButton.frame, to: view) ?? .zero
        var topOffset = buttonFrame.maxY + 6
        if topOffset + height > view.bounds.height {
            topOffset = buttonFrame.minY - height - 6
        }
        menuView.snp.remakeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(height)
            make.top.equalToSuperview().offset(topOffset)
            make.right.equalToSuperview().inset(view.bounds.width - buttonFrame.maxX)
        }
        
        isMenuVisible = true
    }
    
    @objc private func closeMenuOnBackground(_ gesture: UITapGestureRecognizer) {
        hideCustomMenu()
    }
    
    private func hideCustomMenu() {
        menuView.removeFromSuperview()
        menuStack.removeFromSuperview()
        overlayView?.removeFromSuperview()
        overlayView = nil
        isMenuVisible = false
    }
    
    @objc private func handleRefreshTap() {
        hideCustomMenu()
        handleRefresh()
    }
    
    @objc private func handleLogoutTap() {
        hideCustomMenu()
        viewModel.logout()
    }
    @objc private func learnMoreTapped() {
        let alert = UIAlertController(title: "Coming soon", message: "Affiliate program will be available soon!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func handleRefresh() {
        viewModel.reload()
    }
    
    // MARK: - Table
    
    private func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CryptoTableViewCell.self, forCellReuseIdentifier: "CryptoCell")
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    // MARK: - Bindings
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            guard let self = self else { return }
            if self.viewModel.isLoading {
                self.tableView.isHidden = true
                self.activityIndicator.startAnimating()
                self.loadingLabel.isHidden = false
            } else {
                self.activityIndicator.stopAnimating()
                self.loadingLabel.isHidden = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        viewModel.onError = { [weak self] message in
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default))
            self?.present(alert, animated: true)
        }
    }
}

// MARK: - TableView

extension CryptoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCell", for: indexPath)
                as? CryptoTableViewCell else { return UITableViewCell() }
        cell.configure(with: viewModel.crypto(at: indexPath.row))
        return cell
    }
}

extension CryptoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectCoin(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

