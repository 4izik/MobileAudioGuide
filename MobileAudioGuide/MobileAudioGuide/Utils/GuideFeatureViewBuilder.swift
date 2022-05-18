//
//  GuideFeatureViewBuilder.swift
//  MobileAudioGuide
//
//  Created by Aleksei Pavlov on 18.05.2022.
//

import Foundation

/// Варианты характеристик экскурсии
enum Feature: String {
    case route
    case distance
    case transport
    case sightseengs
    
    /// Серый текст наверху вью (описание)
    var secondaryText: String {
        switch self {
        case .route: return "route"
        case .distance: return "distance"
        case .transport: return "transport"
        case .sightseengs: return "on route"
        }
    }
    
    var iconName: String {
        return self.rawValue
    }
}

/// Билдер вьюх с храктеристиками экскрусии
class GuideFeatureViewBuilder {
    
    private var excursionInfo: ExcursionInfo
    /// Инициализатор
    /// - Parameter excursionInfo: модель с информацией об экскурсии
    init(excursionInfo: ExcursionInfo) {
        self.excursionInfo = excursionInfo
    }
    
    /// Создать вью для одной из характеристик экскурсии
    /// - Parameter feature: характеристика экскурсии (продолжительность, километраж, транспорт, количество объектов)
    /// - Returns: вью для переданной характеристики
    func buildFeatureViewFor(feature: Feature) -> GuideFeatureView {
        return GuideFeatureView(secondaryText: feature.secondaryText,
                                primaryText: primaryTextFor(feature),
                                iconName: feature.iconName)
    }
    
    private func primaryTextFor(_ feature: Feature) -> String {
        switch feature {
        case .route: return excursionInfo.excursionDuration
        case .distance: return excursionInfo.routeDistance
        case .transport: return excursionInfo.transportType
        case .sightseengs: return excursionInfo.numberOfSightseengs
        }
    }
}
