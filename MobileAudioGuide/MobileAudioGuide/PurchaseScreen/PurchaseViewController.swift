//
//  PurchaseViewController.swift
//  MobileAudioGuide
//
//  Created by Настя on 07.06.2022.
//

import UIKit

class PurchaseViewController: UIViewController {
    private var excursionInfo: ExcursionInfo
    
    // MARK: - Properties
    private let purchaseView = PurchaseView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    init(excursionInfo: ExcursionInfo) {
        self.excursionInfo = excursionInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        title = "Buy full version"
        view.addSubview(purchaseView)
        view.backgroundColor = .black
        purchaseView.nameExcursionLabel.text = excursionInfo.excursionTitle

        purchaseView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            purchaseView.widthAnchor.constraint(equalTo: view.widthAnchor),
            purchaseView.heightAnchor.constraint(equalTo: view.heightAnchor),
            purchaseView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        loaderInfo()
    }
    
    private func loaderInfo() {
        if let path = Bundle.main.path(forResource: "aboutPurchase", ofType: "txt"),
           let text = try? String(contentsOfFile: path) {
                purchaseView.infoAboutPurchaseTextView.text = text
        }
    }
}
