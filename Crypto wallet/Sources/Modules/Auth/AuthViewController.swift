//
//  AuthViewController.swift
//  Crypto wallet
//
//  Created by Fedor Bebinov on 08.05.2025.
//

import UIKit
import SnapKit

final class AuthViewController: UIViewController {
    
    let viewModel: AuthViewModel
    var onLoginSuccess: (() -> Void)?

    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(resource: .roboLogo)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let usernameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.font = .poppinsRegular(size: 15)
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 25
        tf.clearButtonMode = .whileEditing
        tf.leftViewMode = .always
        return tf
    }()
    
    private let userIconView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(resource: .userIcon)
        iv.contentMode = .scaleAspectFit
        iv.snp.makeConstraints { $0.size.equalTo(32) }
        return iv
    }()
    
    private let passwordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.font = .poppinsRegular(size: 15)
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 25
        tf.isSecureTextEntry = true
        tf.clearButtonMode = .whileEditing
        tf.leftViewMode = .always
        return tf
    }()
    
    private let passwordIconView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(resource: .passwordIcon)
        iv.contentMode = .scaleAspectFit
        iv.snp.makeConstraints { $0.size.equalTo(32) }
        return iv
    }()
    
    private let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Login", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(red: 19/255, green: 22/255, blue: 34/255, alpha: 1)
        btn.layer.cornerRadius = 25
        btn.titleLabel?.font = .poppinsRegular(size: 15)
        btn.addTarget(nil, action: #selector(loginTapped), for: .touchUpInside)
        return btn
    }()
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 240/255, green: 243/255, blue: 245/255, alpha: 1)
        setupFields()
        setupLayout()
        
        viewModel.onAuthSuccess = { [weak self] in
            self?.onLoginSuccess?()
        }
        viewModel.onAuthFailure = { [weak self] message in
            self?.showError(message)
        }
    }
    
    private func setupFields() {
        let iconSize: CGFloat = 32
        let leftPadding: CGFloat = 10
        let rightPadding: CGFloat = 10
        let containerWidth = leftPadding + iconSize + rightPadding
        let containerHeight: CGFloat = 55
        
        let userIconView = UIImageView(image: UIImage(resource: .userIcon))
        userIconView.contentMode = .scaleAspectFit
        userIconView.isUserInteractionEnabled = false
        
        let userIconWrapper = UIView()
        userIconWrapper.isUserInteractionEnabled = false 
        userIconWrapper.addSubview(userIconView)
        userIconView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(leftPadding)
            make.centerY.equalToSuperview()
            make.size.equalTo(iconSize)
        }
        userIconWrapper.snp.makeConstraints { make in
            make.width.equalTo(containerWidth)
            make.height.equalTo(containerHeight)
        }
        usernameField.leftView = userIconWrapper
        usernameField.leftViewMode = .always
        
        let passwordIconView = UIImageView(image: UIImage(resource: .passwordIcon))
        passwordIconView.contentMode = .scaleAspectFit
        passwordIconView.isUserInteractionEnabled = false
        
        let passIconWrapper = UIView()
        passIconWrapper.isUserInteractionEnabled = false
        passIconWrapper.addSubview(passwordIconView)
        passwordIconView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(leftPadding)
            make.centerY.equalToSuperview()
            make.size.equalTo(iconSize)
        }
        passIconWrapper.snp.makeConstraints { make in
            make.width.equalTo(containerWidth)
            make.height.equalTo(containerHeight)
        }
        passwordField.leftView = passIconWrapper
        passwordField.leftViewMode = .always
    }
    
    private func setupLayout() {
        view.addSubview(imageView)
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(13)
            make.left.equalToSuperview().offset(44)
            make.right.equalToSuperview().offset(-44)
        }
        
        usernameField.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(174)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.height.equalTo(55)
        }
        
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(usernameField.snp.bottom).offset(15)
            make.left.right.height.equalTo(usernameField)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.height.equalTo(55)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
        }
    }
    
    @objc private func loginTapped() {
        viewModel.username = usernameField.text ?? ""
        viewModel.password = passwordField.text ?? ""
        viewModel.login()
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Введены неправильный логин или пароль.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Отменить", style: .destructive, handler: { [weak self] _ in
            self?.usernameField.text = ""
            self?.passwordField.text = ""
        }))
        
        present(alert, animated: true, completion: nil)
    }
}
