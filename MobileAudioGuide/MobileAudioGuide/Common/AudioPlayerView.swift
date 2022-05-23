//
//  AudioPlayerView.swift
//  MobileAudioGuide
//
//  Created by Aleksei Pavlov on 22.05.2022.
//

import UIKit
import AVFoundation

/// Вью с проигрываетелм для аудиогидов
final class AudioPlayerView: UIView {
    
    private let audioFileName: String
    
    private lazy var audioURL: URL? = {
        guard let urlString = Bundle.main.path(forResource: audioFileName, ofType: "mp3") else { return nil }
        return URL(fileURLWithPath: urlString)
    }()
    
    private lazy var audioPlayer: AVAudioPlayer? = {
        guard let audioURL = audioURL,
              let audioPlayer = try? AVAudioPlayer(contentsOf: audioURL)
        else { return nil }
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSliderPosition), userInfo: nil, repeats: true)
        return audioPlayer
    }()
    
    private lazy var audioDuration: TimeInterval = {
        return audioPlayer?.duration ?? .zero
    }()
    
    private lazy var backView: UIView = {
        let backView = UIView(frame: .zero)
        backView.backgroundColor = .systemBlue
        return backView
    }()
    
    private lazy var playButton: UIButton = {
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
        setupAudioSession()
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
            playButton.heightAnchor.constraint(equalTo: backView.heightAnchor, constant: -40),
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
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    @objc private func playButtonTapped() {
        guard let audioPlayer = audioPlayer else { return }
        
        switch audioPlayer.isPlaying {
        case true: audioPlayer.stop()
        case false: audioPlayer.play()
        }
    }
    
    @objc private func sliderPositionChanged() {
        guard let audioPlayer = audioPlayer else { return }
        updateCurrentPlayingTimeLabel()
        audioPlayer.stop()
        audioPlayer.currentTime = TimeInterval(sliderView.value)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    @objc private func updateSliderPosition() {
        guard let audioPlayer = audioPlayer else { return }
        sliderView.value = Float(audioPlayer.currentTime)
        let buttonImageName = audioPlayer.isPlaying ? "pause.circle" : "play.circle"
        playButton.setImage(UIImage(systemName: buttonImageName), for: .normal)
        updateCurrentPlayingTimeLabel()
    }
    
    private func updateCurrentPlayingTimeLabel() {
        currentPlayingTimeLabel.text = audioPlayer?.currentTime.minSecFormatted
    }
}
