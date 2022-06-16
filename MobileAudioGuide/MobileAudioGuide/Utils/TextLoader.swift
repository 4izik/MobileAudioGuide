//
//  TextLoader.swift
//  MobileAudioGuide
//
//  Created by Aleksei Pavlov on 17.05.2022.
//

import Foundation

/// Загрузчик текста из txt файлов
class TextLoader {
    
    static func loadFromTxtFile(named filename: String) -> String {
        let documentPath = Bundle.main.path(forResource: filename, ofType: "txt")
        let contents = loadContentsOfFile(path: documentPath)
        return contents ?? ""
    }
    
    private static func loadContentsOfFile(path: String?) -> String? {
        guard let path = path,
              let contentsOfFile = try? String(contentsOfFile: path)  else { return nil }
        return contentsOfFile
    }
}
