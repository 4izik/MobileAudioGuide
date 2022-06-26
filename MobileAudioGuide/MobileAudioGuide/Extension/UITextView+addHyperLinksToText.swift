//
//  UITextView+addHyperLinksToText.swift
//  MobileAudioGuide
//
//  Created by Aleksei Pavlov on 24.06.2022.
//

import UIKit

extension UITextView {

  func addHyperLinksToText(hyperLinks: [String: String]) {
    let style = NSMutableParagraphStyle()
    style.alignment = .left
      let attributedOriginalText = NSMutableAttributedString(string: self.text)
    for (hyperLink, urlString) in hyperLinks {
        let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
        let fullRange = NSRange(location: 0, length: attributedOriginalText.length)
        attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: urlString, range: linkRange)
        attributedOriginalText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: fullRange)
        attributedOriginalText.addAttribute(NSAttributedString.Key.font, value: self.font!, range: fullRange)
    }
    
    self.linkTextAttributes = [
        NSAttributedString.Key.foregroundColor: Colors.vwBlueColor,
        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
    ]
    self.attributedText = attributedOriginalText
  }
}
