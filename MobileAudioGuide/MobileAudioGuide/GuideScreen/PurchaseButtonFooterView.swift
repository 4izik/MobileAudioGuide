//
//  PurchaseButtonFooterView.swift
//  MobileAudioGuide
//
//  Created by Aleksei Pavlov on 10.06.2022.
//

import UIKit

/// View с кнопокой покупки полной версии
final class PurchaseButtonFooterView: UITableViewHeaderFooterView {
    
    /// Кнопка перехода на экран покупки полной версии
    let purchaseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.layer.borderColor = Colors.appAccentColor.cgColor
        button.layer.borderWidth = 1
        button.setTitle("Buy full version", for: .normal)
        button.setTitleColor(Colors.appAccentColor, for: .normal)
        button.layer.cornerRadius = 3
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Initializing from Storyboard isn't supported")
    }
    
    private func setupViews() {
        purchaseButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(purchaseButton)
        
        NSLayoutConstraint.activate([
            purchaseButton.topAnchor.constraint(equalTo: topAnchor),
            purchaseButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            purchaseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            purchaseButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            purchaseButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
