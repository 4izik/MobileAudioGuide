//
//  MapBoxDowloadState.swift
//  MobileAudioGuide
//
//  Created by Aleksei Pavlov on 20.07.2022.
//

import Foundation

enum MapBoxDownloadState {
    case unknown
    case initial
    case downloading
    case downloaded
    case mapViewDisplayed
    case finished
    case noConnection
}
