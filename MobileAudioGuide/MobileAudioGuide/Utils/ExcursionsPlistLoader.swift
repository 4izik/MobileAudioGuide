//
//  ExcursionsPlistLoader.swift
//  MobileAudioGuide
//
//  Created by Aleksei Pavlov on 13.06.2022.
//

import Foundation

final class ExcursionsPlistLoader {
    
    static func loadExcursionInfo() -> [ExcursionInfo] {
        guard let plistUrl = Bundle.main.url(forResource: "Excursions", withExtension: "plist"),
              let plistData = try? Data(contentsOf: plistUrl) else { return [] }
        let decoder = PropertyListDecoder()
        do {
            let excursionsInfo = try decoder.decode([ExcursionInfo].self, from: plistData)
            return excursionsInfo
        }
        catch {
            print(error)
        }
        return []
    }
}
