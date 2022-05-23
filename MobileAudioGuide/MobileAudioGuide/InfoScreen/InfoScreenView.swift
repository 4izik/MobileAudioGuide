//
//  InfoScreenView.swift
//  MobileAudioGuide
//
//  Created by Настя on 21.05.2022.
//

import Foundation
import UIKit

class InfoScreenView: UIView {
    // MARK: - Definition UIElements
    
    var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Photo authors", "Alex"])
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
        imageView.layer.borderColor = UIColor.systemBlue.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Alex"
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
        label.textColor = .systemBlue
        return label
    }()
    
    var facebookButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "facebook"), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    var instagramButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "instagram"), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.isSelectable = false
        textView.isEditable = false
        textView.textColor = .black
        textView.textAlignment = .left
        textView.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return textView
    }()
    
    private let photoAuthorsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.isHidden = true
        label.numberOfLines = 0
        label.text = "Если у Вас есть комментарии или предложения по работе приложения, что-то не работает или Вы хотите предложить какой-то совместный проект - пишите мне на e-mail, указанный на этой страничке."
        return label
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
        stackView.addArrangedSubview(facebookButton)
        stackView.addArrangedSubview(instagramButton)
        
        addSubview(segmentedControl)
        addSubview(photoImageView)
        addSubview(nameLabel)
        addSubview(infoLabel)
        addSubview(emailLabel)
        addSubview(stackView)
        addSubview(textView)
        
        addSubview(photoAuthorsLabel)
    

        applyUIConstraints()
    }

    // MARK: - Add constraints

    func applyUIConstraints() {
        [segmentedControl, photoImageView, nameLabel, infoLabel, emailLabel, stackView, facebookButton, instagramButton, textView, photoAuthorsLabel].forEach { view in
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
            
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 30),
            stackView.widthAnchor.constraint(equalToConstant: 70),
            stackView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            
            textView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            textView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            textView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            
            photoAuthorsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            photoAuthorsLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            photoAuthorsLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            photoAuthorsLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20)
            
        ])
    }
    
    func showViewAboutAuthor() {
        [photoImageView, nameLabel, infoLabel, emailLabel, stackView, facebookButton, instagramButton, textView].forEach { view in
            view.isHidden = false
        }
        photoAuthorsLabel.isHidden = true
    }
    
    func showViewAboutPhotoAuthors() {
        [photoImageView, nameLabel, infoLabel, emailLabel, stackView, facebookButton, instagramButton, textView].forEach { view in
            view.isHidden = true
        }
        photoAuthorsLabel.isHidden = false
    }
}

