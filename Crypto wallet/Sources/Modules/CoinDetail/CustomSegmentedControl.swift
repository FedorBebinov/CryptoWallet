//
//  CustomSegmentedControl.swift
//  Crypto wallet
//
//  Created by Fedor Bebinov on 13.05.2025.
//

import UIKit

class ControlView: UIView {
    
    let items: [String]
    var index: Int = 0 {
        didSet { updateButtons() }
    }
    var indexDidChange: ((Int) -> Void)?
    private let stackView = UIStackView()
    
    private var buttons: [UIButton] = []
    
    init(items: [String]) {
        self.items = items
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor(red: 244/255, green: 246/255, blue: 251/255, alpha: 1)
        layer.cornerRadius = 24
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.shadowRadius = 24
        layer.shadowOpacity = 1
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
        setupButtons()
        updateButtons()
    }
    
    private func setupButtons() {
        buttons = []
        for (i, item) in items.enumerated() {
            let button = UIButton(type: .custom)
            button.setTitle(item, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            button.setTitleColor(UIColor(red: 176/255, green: 182/255, blue: 197/255, alpha: 1), for: .normal)
            button.setTitleColor(UIColor(red: 38/255, green: 42/255, blue: 71/255, alpha: 1), for: .selected)
            button.backgroundColor = .clear
            button.layer.cornerRadius = 20
            button.clipsToBounds = false
            button.tag = i 
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }
    }
    
    private func updateButtons() {
        for (i, button) in buttons.enumerated() {
            let selected = i == index
            button.isSelected = selected
            if selected {
                button.backgroundColor = .white
                button.layer.shadowColor = UIColor.black.withAlphaComponent(0.09).cgColor
                button.layer.shadowOffset = CGSize(width: 0, height: 2)
                button.layer.shadowOpacity = 1
                button.layer.shadowRadius = 8
            } else {
                button.backgroundColor = .clear
                button.layer.shadowOpacity = 0
            }
        }
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        index = sender.tag
        indexDidChange?(sender.tag)
    }
}
