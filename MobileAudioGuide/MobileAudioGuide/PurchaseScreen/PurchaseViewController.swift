//
//  PurchaseViewController.swift
//  MobileAudioGuide
//
//  Created by Настя on 07.06.2022.
//

import UIKit

class PurchaseViewController: UIViewController {
    
    private var excursionInfo: ExcursionInfo
    private let excursionIndex: Int
    private let purchaseView = PurchaseView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    init(excursionInfo: ExcursionInfo, excursionIndex: Int) {
        self.excursionInfo = excursionInfo
        self.excursionIndex = excursionIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        navigationItem.title = "Buy full version"
        navigationController?.navigationBar.topItem?.title = ""
        view.addSubview(purchaseView)
        view.backgroundColor = .black
        purchaseView.nameExcursionLabel.text = excursionInfo.excursionTitle
        purchaseView.infoAboutPurchaseTextView.text = TextLoader.loadFromTxtFile(named: "aboutPurchase\(excursionIndex)")

        purchaseView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            purchaseView.widthAnchor.constraint(equalTo: view.widthAnchor),
            purchaseView.heightAnchor.constraint(equalTo: view.heightAnchor),
            purchaseView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        purchaseView.buySingleTourButton.addTarget(self, action: #selector(makePurchaseSingleTour), for: .touchUpInside)
        purchaseView.buyAllToursButton.addTarget(self, action: #selector(makePurchaseAllTours), for: .touchUpInside)
        purchaseView.restorePurchaseButton.addTarget(self, action: #selector(restorePurchase), for: .touchUpInside)
    }
    
    @objc func makePurchaseSingleTour() {
        PurchaseManager.shared.purchaseProduct(withIdentifier: excursionIndex.getProductIdentifier())
    }
    
    @objc func makePurchaseAllTours() {
        PurchaseManager.shared.purchaseProduct(withIdentifier: InAppProducts.allTours.rawValue)
    }
    
    @objc func restorePurchase() {
        PurchaseManager.shared.restorePurchases()
    }
}
