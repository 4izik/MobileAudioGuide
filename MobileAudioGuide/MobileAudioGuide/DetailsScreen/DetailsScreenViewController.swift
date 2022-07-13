//
//  DetailsScreenViewController.swift
//  MobileAudioGuide
//
//  Created by Aleksei Pavlov on 29.05.2022.
//

import UIKit

/// ViewController для экрана "Подробнее"
final class DetailsScreenViewController: UIViewController {
    
    private let excursionInfo: ExcursionInfo
    private let viewpointNumber: Int
    
    /// Делегат для передачи данных о воспроизведении аудио
    weak var delegate: RouteViewController?
    
    private lazy var topImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: excursionInfo.filenamePrefix + String(viewpointNumber)))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var infoButton: UIButton = {
        let infoButton = UIButton(type: .custom)
        infoButton.setImage(UIImage(systemName: "c.circle"), for: .normal)
        infoButton.contentVerticalAlignment = .fill
        infoButton.contentHorizontalAlignment = .fill
        infoButton.tintColor = .white
        infoButton.backgroundColor = .clear
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
        return infoButton
    }()
    
    private lazy var excursionTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 21)
        label.textColor = .black
        label.numberOfLines = 0
        
        if excursionInfo.tours.indices.contains(viewpointNumber - 1) {
            label.text = excursionInfo.tours[viewpointNumber - 1].tourTitle
        }
        return label
    }()
    
    private lazy var excursionTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textView.isEditable = false
        textView.isSelectable = false
        textView.text = TextLoader.loadFromTxtFile(named: excursionInfo.filenamePrefix + String(viewpointNumber))
        return textView
    }()
    
    private lazy var audioPlayerView: AudioPlayerView = {
        AudioPlayerView(audioFileName: excursionInfo.filenamePrefix + String(viewpointNumber))
    }()
    
    /// Инициализатор
    /// - Parameters:
    ///   - excursionInfo: модель с информацией об экскурсии
    ///   - viewpointIndex: цифра с нажатого на карте кружочка - номер точки в экскурсии
    init(excursionInfo: ExcursionInfo, viewpointIndex: Int) {
        self.excursionInfo = excursionInfo
        self.viewpointNumber = viewpointIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Initializing from Storyboard isn't supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        activateConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = excursionInfo.shortTitle
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if AudioPlayer.shared.nowPlayingFileName == excursionInfo.filenamePrefix + String(viewpointNumber) {
            delegate?.indexOfCellToPause = viewpointNumber - 1
            delegate?.audioPlayerView.playButton.tag = viewpointNumber - 1
        }
    }
    
    private func setupViewController() {
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    @objc private func showInfo() {
        let infoScreenViewController: InfoScreenViewController
        
        if excursionInfo.tours.indices.contains(viewpointNumber - 1) {
            infoScreenViewController = InfoScreenViewController(creativeCommonUrl: excursionInfo.tours[viewpointNumber - 1].imageUrl)
        } else {
            infoScreenViewController = InfoScreenViewController()
        }
        
        infoScreenViewController.infoScreenView.segmentedControl.selectedSegmentIndex = 0
        infoScreenViewController.changeView()
        navigationController?.pushViewController(infoScreenViewController, animated: true)
    }
    
    private func activateConstraints() {
        [topImageView, infoButton, excursionTitleLabel, excursionTextView, audioPlayerView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            topImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topImageView.heightAnchor.constraint(equalToConstant: 250),
            
            infoButton.heightAnchor.constraint(equalToConstant: 40),
            infoButton.widthAnchor.constraint(equalTo: infoButton.heightAnchor),
            infoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            infoButton.bottomAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: -10),
            
            excursionTitleLabel.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: 15),
            excursionTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            excursionTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            excursionTextView.topAnchor.constraint(equalTo: excursionTitleLabel.bottomAnchor, constant: 15),
            excursionTextView.leadingAnchor.constraint(equalTo: excursionTitleLabel.leadingAnchor, constant: -5),
            excursionTextView.trailingAnchor.constraint(equalTo: excursionTitleLabel.trailingAnchor, constant: 5),
            excursionTextView.bottomAnchor.constraint(equalTo: audioPlayerView.topAnchor),
            
            audioPlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            audioPlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            audioPlayerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            audioPlayerView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
}
