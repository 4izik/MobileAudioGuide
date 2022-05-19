//
//  TextLoader.swift
//  MobileAudioGuide
//
//  Created by Aleksei Pavlov on 17.05.2022.
//

import Foundation

/// Загрузчик текста описания экскурсии из документа GuideDescribingTexts.txt
class TextLoader {
    
    let documentPath = Bundle.main.path(forResource: "GuideDescribingTexts", ofType: "txt")
    var excursionInfo = ExcursionInfo()
    
    /// Загрузить информацию об экскурсии из файла
    /// - Parameter index: индекс ячейки главного экрана, с которой совершен переход
    /// - Returns: описание экскурсии, если удалось спарсить, либо nil
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
        let allExcursionsInfo = contentsOfFile.components(separatedBy: "====\n")
        guard allExcursionsInfo.indices.contains(index) else { return nil }
        let currentExcursionInfo = allExcursionsInfo[index]
        let currentExcursionTextBlocks = currentExcursionInfo.components(separatedBy: "----\n")
        
        for blockText in currentExcursionTextBlocks {
            if blockText.contains("_TITLE_:") { excursionInfo.excursionTitle = setSingleLineTextFor(blockText) }
            if blockText.contains("_DURATION_:") { excursionInfo.excursionDuration = setSingleLineTextFor(blockText) }
            if blockText.contains("_DISTANCE_:") { excursionInfo.routeDistance = setSingleLineTextFor(blockText) }
            if blockText.contains("_TRANSPORT_:") { excursionInfo.transportType = setSingleLineTextFor(blockText) }
            if blockText.contains("_SIGHTSEENGS_:") { excursionInfo.numberOfSightseengs = setSingleLineTextFor(blockText) }
            if blockText.contains("_DESCRIPTION_:") { excursionInfo.excursionDescription = setDescriptionTextFor(blockText) }
        }
        return excursionInfo
    }
    
    private func setSingleLineTextFor(_ blockText: String) -> String {
        let subStrings = blockText.components(separatedBy: "\n")
        return subStrings.indices.contains(1) ? subStrings[1] : ""
    }
    
    private func setDescriptionTextFor(_ blockText: String) -> String {
        return blockText.replacingOccurrences(of: "_DESCRIPTION_:\n", with: "")
    }
}
