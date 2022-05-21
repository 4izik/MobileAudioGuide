//
//  MainTableViewCell.swift
//  MobileAudioGuide
//
//  Created by Настя on 16.05.2022.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    private var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    var imageToursView: UIImageView = {
        let imageView  = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.alpha = 0.8
        return imageView
    }()
    
    private let filterView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.4
        return view
    }()
    
    var tagLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        return label
    }()
    
    var infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = Colors.lblMainInfo
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backView.addSubview(imageToursView)
        backView.addSubview(filterView)
        backView.addSubview(infoLabel)
        backView.addSubview(tagLabel)
        
        contentView.addSubview(backView)
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        applyUIConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Initializing from Storyboard isn't supported")
    }
    
    func applyUIConstraints() {
        [backView, imageToursView, infoLabel, filterView, tagLabel].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    
        NSLayoutConstraint.activate([
            backView.leftAnchor.constraint(equalTo: leftAnchor),
            backView.rightAnchor.constraint(equalTo: rightAnchor),
            backView.topAnchor.constraint(equalTo: topAnchor),
            backView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageToursView.leftAnchor.constraint(equalTo: backView.leftAnchor, constant: 14),
            imageToursView.rightAnchor.constraint(equalTo: backView.rightAnchor, constant: -14),
            imageToursView.topAnchor.constraint(equalTo: backView.topAnchor, constant: 4),
            imageToursView.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -4),
            
            filterView.topAnchor.constraint(equalTo: imageToursView.topAnchor),
            filterView.bottomAnchor.constraint(equalTo: imageToursView.bottomAnchor),
            filterView.leftAnchor.constraint(equalTo: imageToursView.leftAnchor),
            filterView.rightAnchor.constraint(equalTo: imageToursView.rightAnchor),
            
            infoLabel.leftAnchor.constraint(equalTo: imageToursView.leftAnchor, constant: 8),
            infoLabel.bottomAnchor.constraint(equalTo: imageToursView.bottomAnchor, constant: -8),
            infoLabel.widthAnchor.constraint(equalToConstant: 250),
            infoLabel.heightAnchor.constraint(equalToConstant: 40),
            
            tagLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 14),
            tagLabel.rightAnchor.constraint(equalTo: backView.rightAnchor, constant: -20),
            tagLabel.heightAnchor.constraint(equalToConstant: 20),
            tagLabel.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
}
