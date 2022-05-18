//
//  TextLoader.swift
//  MobileAudioGuide
//
//  Created by user on 17.05.2022.
//

import Foundation

class TextLoader {
    let documentPath = Bundle.main.path(forResource: "GuideDescribingTexts", ofType: "txt")
    var excursionInfo = ExcursionInfo()
    
    func loadExcursionInfoFor(index: Int) -> ExcursionInfo? {
        guard let contents = loadContentsOfFile(path: documentPath) else { return nil }
        return parsedExcursionInfoFrom(contentsOfFile: contents, forIndex: index)
    }
    
    private func loadContentsOfFile(path: String?) -> String? {
        guard let path = path,
              let contentsOfFile = try? String(contentsOfFile: path)  else { return nil }
        return contentsOfFile
    }
    
    private func parsedExcursionInfoFrom(contentsOfFile: String, forIndex index: Int) -> ExcursionInfo? {
        let allExcursionsInfo = contentsOfFile.components(separatedBy: "====")
        guard allExcursionsInfo.indices.contains(index) else { return nil }
        let currentExcursionInfo = allExcursionsInfo[index]
        let currentExcursionTextBlocks = currentExcursionInfo.components(separatedBy: "\n\n")
        
        for blockText in currentExcursionTextBlocks {
            if blockText.contains("_TITLE_:") { excursionInfo.excursionTitle = setSingleLineTextFor(blockText) }
            if blockText.contains("_DURATION_:") { excursionInfo.excursionDuration = setSingleLineTextFor(blockText) }
            if blockText.contains("_DISTANCE_:") { excursionInfo.routeDistance = setSingleLineTextFor(blockText) }
            if blockText.contains("_TRANSPORT_:") { excursionInfo.transportType = setSingleLineTextFor(blockText) }
            if blockText.contains("_SIGHTSEENGS_:") { excursionInfo.numberOfSightseengs = setSingleLineTextFor(blockText) }
            if blockText.contains("_DESCRIPTION_:") {
                excursionInfo.excursionDescription = setDescriptionTextFor(blockText)
            } else {
                guard excursionInfo.excursionDescription != "" else { continue }
                excursionInfo.excursionDescription += (blockText + "\n\n")
            }
        }
        return excursionInfo
    }
    
    private func setSingleLineTextFor(_ blockText: String) -> String {
        let subStrings = blockText.components(separatedBy: "\n")
        return subStrings.indices.contains(1) ? subStrings[1] : ""
    }
    
    private func setDescriptionTextFor(_ blockText: String) -> String {
        let subStrings = blockText.components(separatedBy: "\n")
        guard subStrings.indices.contains(1) else { return "" }
        
        var description = ""
        for lineIndex in 1..<subStrings.count {
            description += (subStrings[lineIndex] + "\n")
        }
        return description
    }
}
