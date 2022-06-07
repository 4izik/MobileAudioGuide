//
//  PurchaseView.swift
//  MobileAudioGuide
//
//  Created by Настя on 07.06.2022.
//

import UIKit

class PurchaseView: UIView {
    
    // MARK: - Definition UIElements
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Image1")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.8
        return view
    }()
    var nameExcursionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        label.numberOfLines = 2
        label.textAlignment = .justified
        label.textColor = .white
        return label
    }()
    
    let infoAboutPurchaseTextView: UITextView = {
        let textView = UITextView()
        textView.isSelectable = false
        textView.isEditable = false
        textView.textColor = .white
        textView.textAlignment = .left
        textView.backgroundColor = .clear
        textView.showsVerticalScrollIndicator = false
        textView.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return textView
    }()
    
    private let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    let buyOneTourButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.setTitle("", for: .normal)
        return button
    }()
    
    private let buyOneTourLabel: UILabel = {
        let label = UILabel()
        label.text = "Buy one tour"
        label.textAlignment = .left
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let priceOneTourLabel: UILabel = {
        let label = UILabel()
        label.text = "5 $"
        label.textAlignment = .right
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let forOnlyOneTourLabel: UILabel = {
        let label = UILabel()
        label.text = "for only"
        label.textAlignment = .right
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    let buyThreeToursButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.setTitle("", for: .normal)
        return button
    }()
    
    private let buyThreeToursLabel: UILabel = {
        let label = UILabel()
        label.text = "Buy three tours for the price of two"
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 2
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let priceThreeToursLabel: UILabel = {
        let label = UILabel()
        label.text = "12 $"
        label.textAlignment = .right
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let forOnlyThreeToursLabel: UILabel = {
        let label = UILabel()
        label.text = "for only"
        label.textAlignment = .right
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let oldPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .black
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "14 $")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        label.attributedText = attributeString
        return label
    }()
    
    let restorePurchaseButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear
        let attributedText = NSAttributedString(string: "Restore purchase", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)])
        button.setAttributedTitle(attributedText, for: .normal)
        return button
    }()
    
    private let backThreeToursView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        return view
    }()

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        fatalError("Initializing from Storyboard isn't supported")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    // MARK: - Setup View

    private func setupViews() {
        
        [forOnlyOneTourLabel, priceOneTourLabel, buyOneTourLabel, buyOneTourButton, backThreeToursView, buyThreeToursLabel, forOnlyThreeToursLabel, priceThreeToursLabel, oldPriceLabel, buyThreeToursButton, restorePurchaseButton].forEach { view in
            footerView.addSubview(view)
        }
        
        [backgroundImageView, backgroundView, nameExcursionLabel, infoAboutPurchaseTextView, footerView].forEach { view in
            addSubview(view)
        }

        applyUIConstraints()
    }

    // MARK: - Add constraints

    func applyUIConstraints() {
        [backgroundView, backgroundImageView, nameExcursionLabel, infoAboutPurchaseTextView, footerView, buyOneTourButton, buyOneTourLabel, priceOneTourLabel, buyThreeToursButton, buyThreeToursLabel, priceThreeToursLabel, backThreeToursView, forOnlyOneTourLabel, forOnlyThreeToursLabel, oldPriceLabel, restorePurchaseButton].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImageView.leftAnchor.constraint(equalTo: leftAnchor),
            backgroundImageView.rightAnchor.constraint(equalTo: rightAnchor),
            
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.leftAnchor.constraint(equalTo: leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: rightAnchor),
            
            nameExcursionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            nameExcursionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            nameExcursionLabel.topAnchor.constraint(equalTo: topAnchor, constant: UIScreen.main.bounds.height / 8),
            nameExcursionLabel.heightAnchor.constraint(equalToConstant: 100),
            
            footerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 170),
            
            buyOneTourButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 20),
            buyOneTourButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -20),
            buyOneTourButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 10),
            buyOneTourButton.heightAnchor.constraint(equalToConstant: 40),
            
            buyOneTourLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 30),
            buyOneTourLabel.widthAnchor.constraint(equalToConstant: 150),
            buyOneTourLabel.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 10),
            buyOneTourLabel.heightAnchor.constraint(equalToConstant: 40),
            
            forOnlyOneTourLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -45),
            forOnlyOneTourLabel.widthAnchor.constraint(equalToConstant: 100),
            forOnlyOneTourLabel.topAnchor.constraint(equalTo: buyOneTourButton.topAnchor, constant: 2),
            forOnlyOneTourLabel.heightAnchor.constraint(equalToConstant: 16),
            
            priceOneTourLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -45),
            priceOneTourLabel.widthAnchor.constraint(equalToConstant: 100),
            priceOneTourLabel.topAnchor.constraint(equalTo: forOnlyOneTourLabel.bottomAnchor),
            priceOneTourLabel.heightAnchor.constraint(equalToConstant: 20),
            
            buyThreeToursButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 20),
            buyThreeToursButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -20),
            buyThreeToursButton.topAnchor.constraint(equalTo: buyOneTourButton.bottomAnchor, constant: 10),
            buyThreeToursButton.heightAnchor.constraint(equalToConstant: 50),
            
            buyThreeToursLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 30),
            buyThreeToursLabel.widthAnchor.constraint(equalToConstant: 150),
            buyThreeToursLabel.topAnchor.constraint(equalTo: buyThreeToursButton.topAnchor, constant: 5),
            buyThreeToursLabel.heightAnchor.constraint(equalToConstant: 40),
            
            oldPriceLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -45),
            oldPriceLabel.widthAnchor.constraint(equalToConstant: 30),
            oldPriceLabel.topAnchor.constraint(equalTo: buyThreeToursButton.topAnchor, constant: 6),
            oldPriceLabel.heightAnchor.constraint(equalToConstant: 16),
            
            forOnlyThreeToursLabel.trailingAnchor.constraint(equalTo: oldPriceLabel.leadingAnchor),
            forOnlyThreeToursLabel.widthAnchor.constraint(equalToConstant: 100),
            forOnlyThreeToursLabel.topAnchor.constraint(equalTo: buyThreeToursButton.topAnchor, constant: 6),
            forOnlyThreeToursLabel.heightAnchor.constraint(equalToConstant: 16),
            
            priceThreeToursLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -45),
            priceThreeToursLabel.widthAnchor.constraint(equalToConstant: 100),
            priceThreeToursLabel.topAnchor.constraint(equalTo: oldPriceLabel.bottomAnchor),
            priceThreeToursLabel.heightAnchor.constraint(equalToConstant: 20),
            
            backThreeToursView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 20),
            backThreeToursView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -20),
            backThreeToursView.topAnchor.constraint(equalTo: buyOneTourButton.bottomAnchor, constant: 10),
            backThreeToursView.heightAnchor.constraint(equalToConstant: 50),
            
            infoAboutPurchaseTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            infoAboutPurchaseTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            infoAboutPurchaseTextView.topAnchor.constraint(equalTo: nameExcursionLabel.bottomAnchor, constant: 20),
            infoAboutPurchaseTextView.bottomAnchor.constraint(equalTo: footerView.topAnchor, constant: -10),
            
            restorePurchaseButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 50),
            restorePurchaseButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -50),
            restorePurchaseButton.heightAnchor.constraint(equalToConstant: 20),
            restorePurchaseButton.topAnchor.constraint(equalTo: buyThreeToursButton.bottomAnchor, constant: 10)
        ])
    }
}
