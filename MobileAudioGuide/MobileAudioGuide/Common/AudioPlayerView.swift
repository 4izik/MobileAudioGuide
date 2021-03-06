//
//  AudioPlayerView.swift
//  MobileAudioGuide
//
//  Created by Aleksei Pavlov on 22.05.2022.
//

import UIKit
import AVFoundation

protocol AudioPlayerViewDelegate: NSObject {
    func audioStopped()
}

/// Вью с проигрывателем для аудиогидов
final class AudioPlayerView: UIView {
    
    private var audioFileName: String
    private var audioPlayer = AudioPlayer.shared
    weak var delegate: AudioPlayerViewDelegate?
    private var audioDuration: TimeInterval { audioPlayer.getDurationForFile(named: audioFileName) }
    
    private lazy var backView: UIView = {
        let backView = UIView(frame: .zero)
        backView.backgroundColor = Colors.appAccentColor
        return backView
    }()
    
    /// Кнопка воспроизведения/паузы
    lazy var playButton: UIButton = {
        let playButton = UIButton(type: .custom)
        playButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
        playButton.contentVerticalAlignment = .fill
        playButton.contentHorizontalAlignment = .fill
        playButton.tintColor = .white
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        return playButton
    }()
    
    private lazy var sliderView: UISlider = {
        let sliderView = UISlider()
        sliderView.isContinuous = true
        sliderView.maximumValue = Float(audioDuration)
        sliderView.minimumTrackTintColor = .white
        sliderView.maximumTrackTintColor = UIColor(white: 1, alpha: 0.5)
        sliderView.addTarget(self, action: #selector(sliderPositionChanged), for: .valueChanged)
        return sliderView
    }()
    
    private lazy var currentPlayingTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white
        label.textAlignment = .left
        label.text = "00:00"
        return label
    }()
    
    private lazy var totalPlayingTimeLabel: UILabel = {
        let label = UILabel()
        label.text = audioDuration.minSecFormatted
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white
        label.textAlignment = .right
        label.alpha = 0.7
        return label
    }()
        
    /// Инициализатор
    /// - Parameter audioFileName: имя аудиофайла для воспроизведения, без расширения
    init(audioFileName: String) {
        self.audioFileName = audioFileName
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        setupTimer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Initializing from Storyboard isn't supported")
    }
    
    private func setupViews() {
        self.addSubview(backView)
        backView.translatesAutoresizingMaskIntoConstraints = false
        [playButton, currentPlayingTimeLabel, totalPlayingTimeLabel, sliderView]
            .forEach { view in
                backView.addSubview(view)
                view.translatesAutoresizingMaskIntoConstraints = false
            }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backView.topAnchor.constraint(equalTo: self.topAnchor),
            backView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            playButton.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 10),
            playButton.topAnchor.constraint(equalTo: backView.topAnchor, constant: 10),
            playButton.heightAnchor.constraint(equalToConstant: 50),
            playButton.widthAnchor.constraint(equalTo: playButton.heightAnchor),
            
            currentPlayingTimeLabel.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 10),
            currentPlayingTimeLabel.topAnchor.constraint(equalTo: playButton.topAnchor),
            
            totalPlayingTimeLabel.topAnchor.constraint(equalTo: currentPlayingTimeLabel.topAnchor),
            totalPlayingTimeLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -10),
            
            sliderView.leadingAnchor.constraint(equalTo: currentPlayingTimeLabel.leadingAnchor),
            sliderView.topAnchor.constraint(equalTo: currentPlayingTimeLabel.bottomAnchor),
            sliderView.trailingAnchor.constraint(equalTo: totalPlayingTimeLabel.trailingAnchor)
        ])
    }
    
    private func setupTimer() {
        let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSliderPosition), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
    }
    
    @objc func playButtonTapped() {
        audioPlayer.playerButtonTapped(audioFileName: audioFileName)
    }
    
    /// Функция для синхронизации с маленькими кнопками в ячейках RootViewController
    func playButtonTappedFor(filename: String, continuePlaying: Bool = false) {
        audioFileName = filename
        audioPlayer.playerButtonTapped(audioFileName: audioFileName, continuePlaying: continuePlaying)
        totalPlayingTimeLabel.text = audioDuration.minSecFormatted
        sliderView.maximumValue = Float(audioDuration)
    }
    
    @objc private func sliderPositionChanged() {
        let isPlaying = audioPlayer.isPlaying
        updateCurrentPlayingTimeLabel()
        audioPlayer.stopPlaying()
        audioPlayer.setCurrentTimeTo(TimeInterval(sliderView.value))
        audioPlayer.prepareToPlay()
        if isPlaying { audioPlayer.resumePlaying() }
    }
    
    @objc private func updateSliderPosition() {
        sliderView.value = Float(audioPlayer.getCurrentTimeForFile(named: audioFileName))
        updateCurrentPlayingTimeLabel()
        
        guard let newFileNamePath = Bundle.main.path(forResource: audioFileName, ofType: "mp3") else { return }
        let newFileNameURL = URL(fileURLWithPath: newFileNamePath)
        let buttonImageName = audioPlayer.isPlaying && newFileNameURL == audioPlayer.getNowPlayingUrl() ? "pause.circle" : "play.circle"
        playButton.setImage(UIImage(systemName: buttonImageName), for: .normal)
        if buttonImageName == "play.circle" { delegate?.audioStopped() }
    }
    
    private func updateCurrentPlayingTimeLabel() {
        currentPlayingTimeLabel.text = audioPlayer.getCurrentTimeForFile(named: audioFileName).minSecFormatted
    }
}
