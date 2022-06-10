//
//  GuideHeaderView.swift
//  MobileAudioGuide
//
//  Created by Aleksei Pavlov on 17.05.2022.
//

import UIKit

/// Header View для таблицы описания экскурсии
final class GuideHeaderView: UITableViewHeaderFooterView {
    
    private let reuseID = "GuideHeaderView"
    private let excursionInfo: ExcursionInfo
    private let imageName: String
    private let guideFeatureViewBuilder: GuideFeatureViewBuilder
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 21)
        label.textColor = .black
        label.text = excursionInfo.excursionTitle
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let image = UIImage(named: imageName)
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var routeView: GuideFeatureView = {
        return guideFeatureViewBuilder.buildFeatureViewFor(feature: .route)
    }()
    
    private lazy var distanceView: GuideFeatureView = {
        return guideFeatureViewBuilder.buildFeatureViewFor(feature: .distance)
    }()
    
    private lazy var transportView: GuideFeatureView = {
        return guideFeatureViewBuilder.buildFeatureViewFor(feature: .transport)
    }()
    
    private lazy var sightseengView: GuideFeatureView = {
        return guideFeatureViewBuilder.buildFeatureViewFor(feature: .sightseengs)
    }()
    
    /// Кнопка "About excursion"
    lazy var aboutExcursionButton: UIButton = {
        let aboutExcursionButton = UIButton(type: .roundedRect)
        aboutExcursionButton.setTitle("About excursion", for: .normal)
        aboutExcursionButton.setTitleColor(.systemBlue, for: .normal)
        aboutExcursionButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        aboutExcursionButton.backgroundColor = .clear
        aboutExcursionButton.layer.borderWidth = 1
        aboutExcursionButton.layer.borderColor = UIColor.systemBlue.cgColor
        aboutExcursionButton.layer.cornerRadius = 3
        return aboutExcursionButton
    }()
    
    /// Кнопка "Start"
    lazy var beginExcursionButton: UIButton = {
        let beginExcursionButton = UIButton(type: .roundedRect)
        beginExcursionButton.setTitle("Start", for: .normal)
        beginExcursionButton.setTitleColor(.white, for: .normal)
        beginExcursionButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        beginExcursionButton.backgroundColor = .systemBlue
        beginExcursionButton.layer.borderWidth = 1
        beginExcursionButton.layer.borderColor = UIColor.systemBlue.cgColor
        beginExcursionButton.layer.cornerRadius = 3
        return beginExcursionButton
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let buttonsStackView = UIStackView()
        buttonsStackView.axis = .horizontal
        buttonsStackView.alignment = .center
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.spacing = 10
        return buttonsStackView
    }()
    
    /// Инициализатор
    /// - Parameters:
    ///   - excursionInfo: модель с  информацей об экскурсии
    ///   - imageName: имя файла большого изображения
    ///   - guideFeatureViewBuilder: экземпляр билдера вьюх с характеристиками экскурсии
    init(excursionInfo: ExcursionInfo, imageName: String, guideFeatureViewBuilder: GuideFeatureViewBuilder) {
        self.excursionInfo = excursionInfo
        self.imageName = imageName
        self.guideFeatureViewBuilder = guideFeatureViewBuilder
        super.init(reuseIdentifier: reuseID)
        setupViews()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Initializing from Storyboard isn't supported")
    }
    
    private func setupViews() {
        backgroundView?.backgroundColor = .white
        
        [titleLabel, imageView, routeView, distanceView, transportView, sightseengView, aboutExcursionButton, beginExcursionButton, buttonsStackView]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        [titleLabel, imageView, routeView, distanceView, transportView, sightseengView, buttonsStackView]
            .forEach { addSubview($0) }
        
        [aboutExcursionButton, beginExcursionButton]
            .forEach { buttonsStackView.addArrangedSubview($0) }
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 277),
            
            routeView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            routeView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 25),
            routeView.trailingAnchor.constraint(greaterThanOrEqualTo: distanceView.leadingAnchor),
            
            transportView.leadingAnchor.constraint(equalTo: routeView.leadingAnchor),
            transportView.topAnchor.constraint(equalTo: routeView.bottomAnchor, constant: 20),
            transportView.trailingAnchor.constraint(lessThanOrEqualTo: sightseengView.leadingAnchor),
            
            distanceView.topAnchor.constraint(equalTo: routeView.topAnchor),
            distanceView.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -(UIScreen.main.bounds.width / 2.7)),
            
            sightseengView.topAnchor.constraint(equalTo: transportView.topAnchor),
            sightseengView.leadingAnchor.constraint(equalTo: distanceView.leadingAnchor),
            
            buttonsStackView.topAnchor.constraint(equalTo: transportView.bottomAnchor, constant: 20),
            buttonsStackView.leadingAnchor.constraint(equalTo: routeView.leadingAnchor),
            buttonsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            aboutExcursionButton.heightAnchor.constraint(equalToConstant: 40),
            beginExcursionButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
