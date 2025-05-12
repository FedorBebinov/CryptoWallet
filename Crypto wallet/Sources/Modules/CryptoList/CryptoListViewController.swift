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
    var onLogout: (() -> Void)?
    var onCoinSelect: ((Crypto) -> Void)?
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
        b.backgroundColor = .backgroundGray 
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
        let b = UIButton(type: .system)
        b.setTitle("Learn more", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.titleLabel?.font = .poppinsSemiBold(size: 14)
        b.backgroundColor = .white
        b.layer.cornerRadius = 16
        b.contentEdgeInsets = UIEdgeInsets(top: 4, left: 18, bottom: 4, right: 18)
        return b
    }()
    
    private let tableHeaderContainer: UIView = {
        let v = UIView()
        v.backgroundColor = .backgroundGray
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
        btn.tintColor = UIColor(red: 19/255, green: 22/255, blue: 34/255, alpha: 1)
        return btn
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.backgroundColor = .backgroundGray
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
        btn.setTitle("  Обновить", for: .normal)
        btn.setTitleColor(UIColor(red: 32/255, green: 37/255, blue: 51/255, alpha: 1), for: .normal)
        btn.titleLabel?.font = .poppinsRegular(size: 18)
        btn.setImage(UIImage(named: "reloadRocket"), for: .normal)
        btn.tintColor = UIColor(red: 180/255, green: 186/255, blue: 197/255, alpha: 1)
        btn.contentHorizontalAlignment = .left
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return btn
    }()
    
    private let logoutMenuButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("  Выйти", for: .normal)
        btn.setTitleColor(UIColor(red: 32/255, green: 37/255, blue: 51/255, alpha: 1), for: .normal)
        btn.titleLabel?.font = .poppinsRegular(size: 18)
        btn.setImage(UIImage(named: "logoutBin"), for: .normal)
        btn.tintColor = UIColor(red: 180/255, green: 186/255, blue: 197/255, alpha: 1)
        btn.contentHorizontalAlignment = .left
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return btn
    }()
    
    private var menuBackgroundTap: UITapGestureRecognizer?
    
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
            make.width.height.equalTo(212)
            make.left.equalToSuperview().offset(189)
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
        sortButton.addTarget(self, action: #selector(showSortMenu), for: .touchUpInside)
        refreshMenuButton.addTarget(self, action: #selector(handleRefreshTap), for: .touchUpInside)
        logoutMenuButton.addTarget(self, action: #selector(handleLogoutTap), for: .touchUpInside)
    }
    
    @objc private func showCustomMenu() {
        if isMenuVisible {
            hideCustomMenu()
        } else {
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
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(closeMenuOnBackground))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
            menuBackgroundTap = tap
            
            isMenuVisible = true
        }
    }
    
    @objc private func closeMenuOnBackground(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        if !menuView.frame.contains(location) {
            hideCustomMenu()
        }
    }
    
    private func hideCustomMenu() {
        menuView.removeFromSuperview()
        menuStack.removeFromSuperview()
        if let tap = menuBackgroundTap {
            view.removeGestureRecognizer(tap)
            menuBackgroundTap = nil
        }
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
    
    @objc private func showSortMenu(_ sender: UIButton) {
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
        sender.menu = menu
        sender.showsMenuAsPrimaryAction = true
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
        viewModel.onLogout = { [weak self] in self?.onLogout?() }
        viewModel.onCoinSelect = { [weak self] coin in self?.onCoinSelect?(coin) }
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

