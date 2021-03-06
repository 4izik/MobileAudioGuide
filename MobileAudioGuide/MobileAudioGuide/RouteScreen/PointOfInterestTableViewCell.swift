//
//  PointOfInterestTableViewCell.swift
//  MobileAudioGuide
//
//  Created by Aleksei Pavlov on 08.06.2022.
//

import UIKit

/// Ячейка с описанием одной из точек на маршруте экскурсии
final class PointOfInterestTableViewCell: UITableViewCell {
    
    static let identifier = "PointOfInterestTableViewCell"
    
    /// Индекс текущей ячейки
    var cellIndex: Int = 1
    
    /// Модель с данными об экскурсии
    var excursionInfo: ExcursionInfo? {
        didSet {
            guard let excursionInfo = excursionInfo else { return }
            mainImageView.image = UIImage(named: excursionInfo.filenamePrefix + String(cellIndex + 1))
            checkPointNumberLabel.text = String(cellIndex + 1)
            if excursionInfo.tours.indices.contains(cellIndex) {
                titleLabel.text = excursionInfo.tours[cellIndex].tourTitle
            }
        }
    }
    
    private var nowPlayingAudioUrl: URL? {
        AudioPlayer.shared.getNowPlayingUrl()
    }
    
    private var thisCellAudioFileUrl: URL? {
        guard let excursionInfo = excursionInfo else { return nil }
        let thisCellAudioFilename = excursionInfo.filenamePrefix + String(cellIndex + 1)
        guard let thisCellAudioFilePath = Bundle.main.path(forResource: thisCellAudioFilename, ofType: "mp3")
        else { return nil }
        
        return URL(fileURLWithPath: thisCellAudioFilePath)
    }
    
    private var thisCellAudioIsNowPlaying: Bool {
        (nowPlayingAudioUrl == thisCellAudioFileUrl) && AudioPlayer.shared.isPlaying
    }
    
    /// Изображение кнопки play в ячейке в зависимости от текущего воспроизодимого файла
    var smallAudioPlayerButtonImage: UIImage? {
        UIImage(systemName: thisCellAudioIsNowPlaying ? "pause.circle.fill" : "play.circle.fill")
    }
    
    /// Активна ли ячейка (цветная или серая)
    var isActive = true {
        didSet {
            if !isActive { makeCellInactive() }
        }
    }
    
    /// Последняя ли ячейка в таблице
    var isLast = false {
        didSet { verticalLineView.isHidden = isLast }
    }
    
    private lazy var backView: UIView = {
        let backView = UIView(frame: .zero)
        backView.backgroundColor = .white
        return backView
    }()
    
    private lazy var checkPointView: UIImageView = {
        let image = UIImage(named: "mapPin")?.withTintColor(Colors.appAccentColor)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var checkPointNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.appAccentColor
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textAlignment = .center
        label.text = "49"
        return label
    }()
    
    private lazy var verticalLineView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var mainImageView: UIImageView = {
        let image = UIImage(named: "Image1")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var grayBackdropView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Sirkeji Station"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    /// Кнопка перехода на экран с подробным описанием точки маршрута
    lazy var showDetailsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Colors.appAccentColor, for: .normal)
        button.setTitle("More info", for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return button
    }()
    
    /// Кнопка воспроизведения аудио
    lazy var playAudioButton: UIButton = {
        let playButton = UIButton(type: .custom)
        playButton.setImage(smallAudioPlayerButtonImage, for: .normal)
        playButton.contentVerticalAlignment = .fill
        playButton.contentHorizontalAlignment = .fill
        playButton.tintColor = Colors.appAccentColor
        return playButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        activateConstraints()
        drawDottedLine(start: CGPoint(x: 1, y: 0),
                       end: CGPoint(x: 1, y: 130),
                       view: verticalLineView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Initializing from Storyboard isn't supported")
    }
    
    private func activateConstraints() {
        [backView, checkPointView, checkPointNumberLabel, verticalLineView, mainImageView, grayBackdropView, titleLabel, showDetailsButton, playAudioButton]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        contentView.addSubview(backView)
        
        [checkPointView, checkPointNumberLabel, verticalLineView, mainImageView, grayBackdropView, titleLabel, showDetailsButton, playAudioButton]
            .forEach { backView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            checkPointView.centerXAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            checkPointView.topAnchor.constraint(equalTo: backView.topAnchor),
            checkPointView.widthAnchor.constraint(equalToConstant: 34),
            checkPointView.heightAnchor.constraint(equalTo: checkPointView.widthAnchor),
            
            checkPointNumberLabel.centerXAnchor.constraint(equalTo: checkPointView.centerXAnchor),
            checkPointNumberLabel.topAnchor.constraint(equalTo: checkPointView.topAnchor, constant: 6),
            
            verticalLineView.centerXAnchor.constraint(equalTo: checkPointView.centerXAnchor),
            verticalLineView.topAnchor.constraint(equalTo: checkPointView.bottomAnchor, constant: 4),
            verticalLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            verticalLineView.widthAnchor.constraint(equalToConstant: 2),
            
            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: checkPointView.centerXAnchor, constant: 30),
            mainImageView.widthAnchor.constraint(equalToConstant: 97),
            mainImageView.heightAnchor.constraint(equalTo: mainImageView.widthAnchor),
            
            grayBackdropView.topAnchor.constraint(equalTo: contentView.topAnchor),
            grayBackdropView.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor),
            grayBackdropView.leadingAnchor.constraint(equalTo: mainImageView.trailingAnchor),
            grayBackdropView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -17),
            
            titleLabel.topAnchor.constraint(equalTo: grayBackdropView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: grayBackdropView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: playAudioButton.trailingAnchor),
            
            showDetailsButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            showDetailsButton.bottomAnchor.constraint(equalTo: grayBackdropView.bottomAnchor, constant: -12),
            
            playAudioButton.widthAnchor.constraint(equalToConstant: 25),
            playAudioButton.heightAnchor.constraint(equalTo: playAudioButton.widthAnchor),
            playAudioButton.trailingAnchor.constraint(equalTo: grayBackdropView.trailingAnchor, constant: -7),
            playAudioButton.bottomAnchor.constraint(equalTo: grayBackdropView.bottomAnchor, constant: -12)
            
        ])
    }
    
    private func drawDottedLine(start p0: CGPoint, end p1: CGPoint, view: UIView) {
        
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
    }
    
    private func makeCellInactive() {
        checkPointView.image = checkPointView.image?.withTintColor(.systemGray)
        checkPointNumberLabel.textColor = .systemGray
        titleLabel.textColor = .darkGray
        showDetailsButton.setTitleColor(.systemGray, for: .normal)
        playAudioButton.tintColor = .systemGray2
        grayBackdropView.backgroundColor = .systemGray6
        mainImageView.grayscaled()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainImageView.image = nil
    }
}
