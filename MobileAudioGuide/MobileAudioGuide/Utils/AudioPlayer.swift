//
//  AudioPlayer.swift
//  MobileAudioGuide
//
//  Created by Aleksei Pavlov on 14.06.2022.
//

import AVFoundation

/// Сервис единого аудиоплеера для всего приложения
final class AudioPlayer {
    static let shared = AudioPlayer()
    
    private var audioPlayer: AVAudioPlayer?
    private var nowPlayingUrl: URL?
    
    /// Воспроизводится ли в данный момент аудио
    var isPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }
    /// Имя файла (без расширения), воспроизводимого в данный момент
    var nowPlayingFileName: String?
    
    private init() {}
    
    /// Обработка плеером нажатия на кнопку Play/Pause в родительском view
    /// - Parameters:
    ///   - audioFileName: имя аудиофайла (без расширения)
    ///   - continuePlaying: требуется ли продолжить воспроизведение (по умолчанию  false)
    func playerButtonTapped(audioFileName: String, continuePlaying: Bool = false) {
        switch audioPlayer {
        case nil: createAudioPlayerAndPlayAudioFile(named: audioFileName)
        default: checkWhatsPlayingAndCreateNewPlayerIfNeeded(forFileName: audioFileName, continuePlaying: continuePlaying)
        }
    }
    /// Остановить воспроизведение
    func stopPlaying() {
        audioPlayer?.stop()
    }
    
    /// Изменить текущее время воспроизведения на новое
    /// - Parameter timeInterval: новое значение времени, с котрого нужно продолжить воспроизведение
    func setCurrentTimeTo(_ timeInterval: TimeInterval) {
        audioPlayer?.currentTime = timeInterval
    }
    /// Подготовить проигрыватель к воспроизведению
    func prepareToPlay() {
        audioPlayer?.prepareToPlay()
    }
    /// Возобновить воспроизведение
    func resumePlaying() {
        audioPlayer?.play()
    }
    
    /// Получить URL воспроизводимого в данный момент аудиофайла
    /// - Returns: URL аудиофайла
    func getNowPlayingUrl() -> URL? {
        audioPlayer?.url
    }
    
    /// Получить длительность аудиодорожки
    /// - Parameter audioFileName: имя аудиофайла (без расширения)
    /// - Returns: длительность аудиофайла в секундах
    func getDurationForFile(named audioFileName: String) -> TimeInterval {
        guard let urlString = Bundle.main.path(forResource: audioFileName, ofType: "mp3"),
              let player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString)) else { return 0 }
        return player.duration
    }
    
    /// Получить текущее время воспроизведения
    /// - Parameter audioFileName: имя аудиофайла (без расширения)
    /// - Returns: текущее время воспроизведения в секундах
    func getCurrentTimeForFile(named audioFileName: String) -> TimeInterval {
        guard let receivedUrlString = Bundle.main.path(forResource: audioFileName, ofType: "mp3") else { return 0 }
        
        let receivedUrl = URL(fileURLWithPath: receivedUrlString)
        if receivedUrl == nowPlayingUrl {
            return audioPlayer?.currentTime ?? 0
        } else { return 0 }
    }
    
    private func createAudioPlayerAndPlayAudioFile(named audioFileName: String) {
        guard let urlString = Bundle.main.path(forResource: audioFileName, ofType: "mp3") else { return }
        nowPlayingUrl = URL(fileURLWithPath: urlString)
        
        guard let nowPlayingUrl = nowPlayingUrl,
              let audioPlayer = try? AVAudioPlayer(contentsOf: nowPlayingUrl) else {
            nowPlayingUrl = nil
            return
        }
        self.nowPlayingFileName = audioFileName
        self.audioPlayer = audioPlayer
        audioPlayer.play()
    }
    
    private func checkWhatsPlayingAndCreateNewPlayerIfNeeded(forFileName audioFileName: String, continuePlaying: Bool) {
        guard let receivedUrlString = Bundle.main.path(forResource: audioFileName, ofType: "mp3"),
              let audioPlayer = audioPlayer else { return }
        let receivedUrl = URL(fileURLWithPath: receivedUrlString)
        
        if receivedUrl == nowPlayingUrl {
            switch (audioPlayer.isPlaying, continuePlaying) {
            case (true, false): audioPlayer.pause()
            case (false, false): audioPlayer.play()
            default: return
            }
        } else {
            audioPlayer.stop()
            self.audioPlayer = nil
            self.nowPlayingUrl = nil
            self.nowPlayingFileName = nil
            createAudioPlayerAndPlayAudioFile(named: audioFileName)
        }
    }
}
