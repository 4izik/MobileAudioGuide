//
//  BuyFullVersionTableViewCell.swift
//  MobileAudioGuide
//
//  Created by Aleksei Pavlov on 08.06.2022.
//

import UIKit

/// Ячейка с кнопкой покупки полной версии
final class BuyFullVersionTableViewCell: UITableViewCell {
    
    static let identifier = "BuyFullVersionTableViewCell"
    /// Общее число точек в маршруте
    var totalPointsNumber: Int = 0 {
        didSet { checkPointNumberLabel.text = "\(totalPointsNumber)" }
    }
    
    private lazy var checkPointView: UIImageView = {
        let image = UIImage(named: "mapPin")?.withTintColor(.systemGray)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var checkPointNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var verticalLineView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var backView: UIView = {
        let backView = UIView(frame: .zero)
        backView.backgroundColor = .white
        return backView
    }()
    
    private lazy var colorBackdropView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = Colors.vwBlueColor
        return view
    }()
    
    private lazy var bannerTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "All objects are available\nin full version"
        return label
    }()
    
    lazy var buyFullVersionButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Buy full version", for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        activateConstraints()
        drawDottedLineWithCircles(start: CGPoint(x: 5, y: 0),
                       end: CGPoint(x: 5, y: 130),
                       view: verticalLineView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Initializing from Storyboard isn't supported")
    }
    
    private func activateConstraints() {
        [backView, checkPointView, checkPointNumberLabel, verticalLineView, colorBackdropView, bannerTitleLabel, buyFullVersionButton]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        contentView.addSubview(backView)
        
        [colorBackdropView, checkPointView, checkPointNumberLabel, verticalLineView, bannerTitleLabel, buyFullVersionButton]
            .forEach { backView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            checkPointView.centerXAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            checkPointView.bottomAnchor.constraint(equalTo: backView.bottomAnchor),
            checkPointView.widthAnchor.constraint(equalToConstant: 34),
            checkPointView.heightAnchor.constraint(equalTo: checkPointView.widthAnchor),
            
            checkPointNumberLabel.centerXAnchor.constraint(equalTo: checkPointView.centerXAnchor),
            checkPointNumberLabel.topAnchor.constraint(equalTo: checkPointView.topAnchor, constant: 6),
            
            verticalLineView.centerXAnchor.constraint(equalTo: checkPointView.centerXAnchor),
            verticalLineView.bottomAnchor.constraint(equalTo: checkPointView.topAnchor, constant: -4),
            verticalLineView.topAnchor.constraint(equalTo: contentView.topAnchor),
            verticalLineView.widthAnchor.constraint(equalToConstant: 10),
            
            colorBackdropView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorBackdropView.leadingAnchor.constraint(equalTo: checkPointView.centerXAnchor, constant: 30),
            colorBackdropView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            colorBackdropView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -17),
            
            bannerTitleLabel.centerXAnchor.constraint(equalTo: colorBackdropView.centerXAnchor),
            bannerTitleLabel.topAnchor.constraint(equalTo: colorBackdropView.topAnchor, constant: 22),
            
            buyFullVersionButton.centerXAnchor.constraint(equalTo: colorBackdropView.centerXAnchor),
            buyFullVersionButton.leadingAnchor.constraint(equalTo: colorBackdropView.leadingAnchor, constant: 16),
            buyFullVersionButton.trailingAnchor.constraint(equalTo: colorBackdropView.trailingAnchor, constant: -16),
            buyFullVersionButton.bottomAnchor.constraint(equalTo: colorBackdropView.bottomAnchor, constant: -16),
            buyFullVersionButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func drawDottedLineWithCircles(start p0: CGPoint, end p1: CGPoint, view: UIView) {
        
        let path = UIBezierPath()
        path.move(to: p0)
        path.addLine(to: p1)
        path.lineCapStyle = .round
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.systemGray5.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineDashPattern = [6, 6]
        
        view.layer.addSublayer(shapeLayer)
        
        let firstCirclePath = UIBezierPath(ovalIn: CGRect(x: 2, y: 1, width: 6, height: 6))
        let secondCirclePath = UIBezierPath(ovalIn: CGRect(x: 2, y: 25, width: 6, height: 6))
        let thirdCirclePath = UIBezierPath(ovalIn: CGRect(x: 2, y: 49, width: 6, height: 6))
        
        [firstCirclePath, secondCirclePath, thirdCirclePath].forEach { path in
            let layer = CAShapeLayer()
            layer.path = path.cgPath
            layer.fillColor = UIColor.white.cgColor
            layer.lineWidth = 2
            layer.strokeColor = UIColor.systemGray.cgColor
            view.layer.insertSublayer(layer, above: shapeLayer)
        }
    }
}
