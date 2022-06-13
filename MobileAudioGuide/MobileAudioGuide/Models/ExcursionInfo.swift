//
//  ExcursionInfo.swift
//  MobileAudioGuide
//
//  Created by Aleksei Pavlov on 17.05.2022.
//

import Foundation

struct ExcursionInfo: Decodable {
    /// Полный заголовок
    var excursionTitle: String = ""
    /// Короткий заголовок
    var shortTitle: String = ""
    /// Общее описание экскурсии (Берем из отдельного файла по префиксу имени и добавляем 0)
    var excursionDescription: String {
        TextLoader.loadFromTxtFile(named: self.filenamePrefix + "0")
    }
    /// Длительность экскурсии
    var excursionDuration: String = ""
    /// Расстояние маршрута
    var routeDistance: String = ""
    /// Тип передвижения по маршруту
    var transportType: String = ""
    /// Количество точек на маршруте (возвращать количесва точек на маршруте)
    var numberOfSightseengs: String {
        String(tours.count)
    }
    /// Префикс имени файлов картинок, аудиофайлов и txt-файлов в экскурсии.
    /// Например, для FirstExcursion03.jpg и FirstExcursion03.txt это будет "FirstExcursion"
    var filenamePrefix: String = ""
    /// Координаты входа в экран карты
    var mapScreenCoordinates = MapScreenCoordinates()
    var tours: [TourInfo] = []
}

struct MapScreenCoordinates: Decodable {
    var latitude: Double = 0
    var longitude: Double = 0
}

struct TourInfo: Decodable {
    var tourTitle: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
}
