//
//  GuideFeatureView.swift
//  MobileAudioGuide
//
//  Created by Aleksei Pavlov on 17.05.2022.
//

import UIKit

/// Вью с описанием одной из характеристик экскурсии (продолжительность, километраж, транспорт, количество объектов)
final class GuideFeatureView: UIView {
    
    private let secondaryText: String
    private let primaryText: String
    private let iconName: String
    
    private lazy var secondaryTextLabel: UILabel = {
        let secondaryLabel = UILabel()
        secondaryLabel.text = secondaryText
        secondaryLabel.textColor = .systemGray
        secondaryLabel.font = UIFont.systemFont(ofSize: 13)
        secondaryLabel.textAlignment = .left
        return secondaryLabel
    }()
    
    private lazy var primaryTextLabel: UILabel = {
        let primaryLabel = UILabel()
        primaryLabel.text = primaryText
        primaryLabel.textColor = .black
        primaryLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        primaryLabel.textAlignment = .left
        return primaryLabel
    }()
    
    private lazy var iconImageView: UIImageView = {
        guard let image = UIImage(named: iconName) else { return UIImageView() }
        let iconView = UIImageView(image: image)
        iconView.contentMode = .scaleAspectFill
        return iconView
    }()
    
    /// Инициализатор
    /// - Parameters:
    ///   - secondaryText: серый текст наверху вью (описание)
    ///   - primaryText: черный текст со значением выбранной характеристики
    ///   - iconName: имя файла иконки
    init(secondaryText: String, primaryText: String, iconName: String) {
        self.secondaryText = secondaryText
        self.primaryText = primaryText
        self.iconName = iconName
        super.init(frame: .zero)
        setupViews()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Initializing from Storyboard isn't supported")
    }
    
    private func setupViews() {
        backgroundColor = .white
        
        [secondaryTextLabel, primaryTextLabel, iconImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 36),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconImageView.topAnchor.constraint(equalTo: topAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            secondaryTextLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            secondaryTextLabel.topAnchor.constraint(equalTo: topAnchor),
            
            primaryTextLabel.leadingAnchor.constraint(equalTo: secondaryTextLabel.leadingAnchor),
            primaryTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
