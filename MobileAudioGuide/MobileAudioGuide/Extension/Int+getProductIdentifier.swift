//
//  Int+getProductIdentifier.swift
//  MobileAudioGuide
//
//  Created by Aleksei Pavlov on 24.06.2022.
//

import Foundation

extension Int {
    
    func getProductIdentifier() -> String {
        switch self {
        case 0: return InAppProducts.firstTour.rawValue
        case 1: return InAppProducts.secondTour.rawValue
        case 2: return InAppProducts.thirdTour.rawValue
        default: return ""
        }
    }
}
