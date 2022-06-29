//
//  ExcursionInfo.swift
//  MobileAudioGuide
//
//  Created by Aleksei Pavlov on 17.05.2022.
//

import Foundation

/// Модель экскурсии
struct ExcursionInfo: Decodable {
    /// Полный заголовок
    let excursionTitle: String
    /// Короткий заголовок
    let shortTitle: String
    /// Общее описание экскурсии
    var excursionDescription: String {
        TextLoader.loadFromTxtFile(named: self.filenamePrefix + "0")
    }
    /// Длительность экскурсии
    let excursionDuration: String
    /// Расстояние маршрута
    let routeDistance: String
    /// Тип передвижения по маршруту
    let transportType: String
    /// Количество точек на маршруте (возвращать количесва точек на маршруте)
    var numberOfSightseengs: String {
        String(tours.count)
    }
    /// Префикс имени файлов картинок, аудиофайлов и txt-файлов в экскурсии.
    /// Например, для FirstExcursion03.jpg и FirstExcursion03.txt это будет "FirstExcursion"
    let filenamePrefix: String
    /// Координаты входа в экран карты
    let mapScreenCoordinates: MapScreenCoordinates
    let tours: [TourInfo]
}

struct MapScreenCoordinates: Decodable {
    let latitude: Double
    let longitude: Double
}

struct TourInfo: Decodable {
    let tourTitle: String
    let latitude: Double
    let longitude: Double
}

extension ExcursionInfo {
    func isCompleted() -> Bool {
        guard tours.count > 0 else { return false }
        var passedToursCount: Double = 0
        for number in 1...self.tours.count {
            if UserDefaults.standard.bool(forKey: filenamePrefix + "\(number)") {
                passedToursCount += 1
            }
        }
        return passedToursCount / Double(tours.count) >= 0.9
    }
}
