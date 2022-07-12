//
//  MainView.swift
//  MobileAudioGuide
//
//  Created by Настя on 15.05.2022.
//

import Foundation
import UIKit

class MainView: UIView {
    // MARK: - Definition UIElements
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "backGroundImage")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.8
        return view
    }()

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Istanbul Audio tours"
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = Colors.lblMainInfo
        return label
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UIScreen.main.bounds.height / 5
        tableView.contentMode = .scaleAspectFit
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
        return tableView
    }()
    
    var ticketsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.ticketsButton
        button.setTitle("Tickets/tours", for: .normal)
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 12, weight: .medium)
        button.clipsToBounds = true
        button.layer.cornerRadius = 6
        return button
    }()
    
    var hotelsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.hotelsButton
        button.setTitle("Hotels", for: .normal)
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 12, weight: .medium)
        button.clipsToBounds = true
        button.layer.cornerRadius = 6
        return button
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
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
        addSubview(backgroundImageView)
        addSubview(backgroundView)
        
        stackView.addArrangedSubview(ticketsButton)
        stackView.addArrangedSubview(hotelsButton)
        
        addSubview(infoLabel)
        addSubview(tableView)
        addSubview(stackView)

        applyUIConstraints()
    }

    // MARK: - Add constraints

    func applyUIConstraints() {
        [infoLabel, tableView, stackView, ticketsButton, hotelsButton, backgroundImageView, backgroundView].forEach { view in
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
            
            infoLabel.widthAnchor.constraint(equalToConstant: 170),
            infoLabel.heightAnchor.constraint(equalToConstant: 60),
            infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100),
            
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
