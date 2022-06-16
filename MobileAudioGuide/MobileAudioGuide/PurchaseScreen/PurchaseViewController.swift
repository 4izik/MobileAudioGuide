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
        navigationItem.title = "Buy full version"
        navigationController?.navigationBar.topItem?.title = ""
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
        purchaseView.buyOneTourButton.addTarget(self, action: #selector(makePurchaseOneTour), for: .touchUpInside)
        purchaseView.buyThreeToursButton.addTarget(self, action: #selector(makePurchaseThreeTours), for: .touchUpInside)
        purchaseView.restorePurchaseButton.addTarget(self, action: #selector(restorePurchase), for: .touchUpInside)
    }
    
    private func loaderInfo() {
        if let path = Bundle.main.path(forResource: "aboutPurchase", ofType: "txt"),
           let text = try? String(contentsOfFile: path) {
                purchaseView.infoAboutPurchaseTextView.text = text
        }
    }
    
    @objc func makePurchaseOneTour() {
        StoreManager(index: 2).buyInApp(inAppID: "com.istanbul.audioguide.onetour")
    }
    
    @objc func makePurchaseThreeTours() {
        StoreManager(index: 3).buyInApp(inAppID: "com.istanbul.audioguide.threetours")
    }
    
    @objc func restorePurchase(_ sender: Any) {
        StoreManager(index: 3).restorePurchases()
    }


}
