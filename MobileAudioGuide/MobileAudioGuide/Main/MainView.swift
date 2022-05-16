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
        addSubview(infoLabel)
        addSubview(tableView)

        applyUIConstraints()
        
        self.backgroundColor = Colors.vwBackground
    }

    // MARK: - Add constraints

    func applyUIConstraints() {
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoLabel.widthAnchor.constraint(equalToConstant: 170),
            infoLabel.heightAnchor.constraint(equalToConstant: 60),
            infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoLabel.topAnchor.constraint(equalTo: topAnchor, constant: super.bounds.height / 7),
            
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100)
        ])
    }

}
