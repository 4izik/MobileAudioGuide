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
        label.text = "Istanbul audio tours"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
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
        addSubview(infoLabel)

        applyUIConstraints()
        
        self.backgroundColor = Colors.vwBackground
    }

    // MARK: - Add constraints

    func applyUIConstraints() {
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoLabel.widthAnchor.constraint(equalToConstant: 105),
            infoLabel.heightAnchor.constraint(equalToConstant: 105),
            infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoLabel.topAnchor.constraint(equalTo: topAnchor, constant: super.bounds.height / 5)
        ])
    }

}
