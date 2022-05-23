//
//  TimeInterval+minSecFormatted.swift
//  MobileAudioGuide
//
//  Created by Aleksei Pavlov on 22.05.2022.
//

import Foundation

extension TimeInterval {
    var minSecFormatted: String {
        let endingDate = Date()
        let startingDate = endingDate.addingTimeInterval(-self)
        let calendar = Calendar.current
        
        let componentsNow = calendar.dateComponents([.minute, .second], from: startingDate, to: endingDate)
        guard let minute = componentsNow.minute, let seconds = componentsNow.second else { return "00:00" }
        return "\(String(format: "%02d", minute)):\(String(format: "%02d", seconds))"
    }
}
