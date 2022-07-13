//
//  InfoScreenView.swift
//  MobileAudioGuide
//
//  Created by Настя on 21.05.2022.
//

import UIKit

class InfoScreenView: UIView {
    // MARK: - Definition UIElements
    
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Photo authors", "Christopher"])
        control.selectedSegmentIndex = 1
        control.layer.borderColor = UIColor.gray.cgColor
        control.tintColor = .gray
        return control
    }()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "author")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.layer.borderColor = Colors.appAccentColor.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Christopher"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Guidebook author"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.textColor = .lightGray
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "contact@offlineofficialguide.com"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.textColor = Colors.appAccentColor
        return label
    }()
    
    let facebookButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        let buttonImage = UIImage(named: "facebook") ?? UIImage()
        button.setImage(buttonImage.withTintColor(Colors.appAccentColor), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    let instagramButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        let buttonImage = UIImage(named: "instagram") ?? UIImage()
        button.setImage(buttonImage.withTintColor(Colors.appAccentColor), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    private let socialNetworksStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let infoAboutAuthorTextView: UITextView = {
        let textView = UITextView()
        textView.isSelectable = false
        textView.isEditable = false
        textView.textColor = .black
        textView.textAlignment = .left
        textView.dataDetectorTypes = .link
        textView.showsVerticalScrollIndicator = false
        textView.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return textView
    }()
    
    let photoAuthorsTextView: UITextView = {
        let textView = UITextView()
        textView.isSelectable = true
        textView.isEditable = false
        textView.textColor = .black
        textView.textAlignment = .left
        textView.showsVerticalScrollIndicator = false
        textView.isScrollEnabled = false
        textView.isHidden = true
        textView.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textView.text = "This application uses photos by Christopher Matiaz and the following authors under a Creative common license"
        return textView
    }()
    
    // MARK: - Init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        setupViews()
    }
    
    // MARK: - Setup View
    
    private func setupViews() {
        socialNetworksStackView.addArrangedSubview(facebookButton)
        socialNetworksStackView.addArrangedSubview(instagramButton)
        
        [segmentedControl, photoImageView, nameLabel, infoLabel, emailLabel, socialNetworksStackView, infoAboutAuthorTextView, photoAuthorsTextView].forEach { view in
            addSubview(view)
        }
        
        applyUIConstraints()
    }
    
    // MARK: - Add constraints

    func applyUIConstraints() {
        [segmentedControl, photoImageView, nameLabel, infoLabel, emailLabel, socialNetworksStackView, facebookButton, instagramButton, infoAboutAuthorTextView, photoAuthorsTextView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: topAnchor, constant: UIScreen.main.bounds.height / 7),
            segmentedControl.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            segmentedControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            photoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            photoImageView.heightAnchor.constraint(equalToConstant: 100),
            photoImageView.widthAnchor.constraint(equalToConstant: 100),
            photoImageView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: 150),
            nameLabel.heightAnchor.constraint(equalToConstant: 24),
            nameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 14),
            
            infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoLabel.widthAnchor.constraint(equalToConstant: 150),
            infoLabel.heightAnchor.constraint(equalToConstant: 14),
            infoLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            emailLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emailLabel.widthAnchor.constraint(equalToConstant: 300),
            emailLabel.heightAnchor.constraint(equalToConstant: 20),
            emailLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 10),
            
            socialNetworksStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            socialNetworksStackView.heightAnchor.constraint(equalToConstant: 30),
            socialNetworksStackView.widthAnchor.constraint(equalToConstant: 70),
            socialNetworksStackView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            
            infoAboutAuthorTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            infoAboutAuthorTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            infoAboutAuthorTextView.topAnchor.constraint(equalTo: socialNetworksStackView.bottomAnchor, constant: 20),
            infoAboutAuthorTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            
            photoAuthorsTextView.centerXAnchor.constraint(equalTo: centerXAnchor),
            photoAuthorsTextView.centerYAnchor.constraint(equalTo: centerYAnchor),
            photoAuthorsTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            photoAuthorsTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20)
        ])
    }
    
    func showView(selectedSegment: Int) {
        [photoImageView, nameLabel, infoLabel, emailLabel, socialNetworksStackView, facebookButton, instagramButton, infoAboutAuthorTextView].forEach { $0.isHidden = (selectedSegment != 1) }
        photoAuthorsTextView.isHidden = (selectedSegment == 1)
    }
}
