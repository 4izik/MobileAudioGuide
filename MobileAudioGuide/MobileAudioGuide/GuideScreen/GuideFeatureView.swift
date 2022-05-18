//
//  GuideFeatureView.swift
//  MobileAudioGuide
//
//  Created by Aleksei Pavlov on 17.05.2022.
//

import UIKit

class GuideFeatureView: UIView {
    private let secondaryText: String
    private let primaryText: String?
    private let iconName: String
    
    
    init(secondaryText: String, primaryText: String? = nil, iconName: String) {
        self.secondaryText = secondaryText
        self.primaryText = primaryText
        self.iconName = iconName
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
