//
//  GuideHeaderView.swift
//  MobileAudioGuide
//
//  Created by Aleksei Pavlov on 17.05.2022.
//

import UIKit

class GuideHeaderView: UITableViewHeaderFooterView {
    let reuseID = "GuideHeaderView"
    let excursionInfo: ExcursionInfo
    let imageName: String
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var routeView: GuideFeatureView = {
        let view = GuideFeatureView(secondaryText: "route",
                                    primaryText: excursionInfo.excursionDuration,
                                    iconName: "route")
        return view
    }()
    
    init(excursionInfo: ExcursionInfo, imageName: String) {
        self.excursionInfo = excursionInfo
        self.imageName = imageName
        super.init(reuseIdentifier: reuseID)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
    }
}
