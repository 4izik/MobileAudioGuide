//
//  PurchaseViewController.swift
//  MobileAudioGuide
//
//  Created by Настя on 07.06.2022.
//

import UIKit

class PurchaseViewController: UIViewController {
    
    private var excursionInfo: ExcursionInfo
    var storeManager = StoreManager()
    var typePurchase = "month"
    
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
        print(UserDefaults.standard.object(forKey: "com.Istanbul.MobileAudioGuide.OneTour") as? String)
        /*oneMonthPriceLabel.text = UserDefaults.standard.object(forKey: "com.redrazr.redstickerz") as? String
        unlimitPriceLabel.text = UserDefaults.standard.object(forKey: "com.redrazr.redstickerz.endless") as? String*/
        purchaseView.buyOneTourButton.addTarget(self, action: #selector(makePurchaseOneTour), for: .touchUpInside)
    }
    
    private func loaderInfo() {
        if let path = Bundle.main.path(forResource: "aboutPurchase", ofType: "txt"),
           let text = try? String(contentsOfFile: path) {
                purchaseView.infoAboutPurchaseTextView.text = text
        }
    }
    
    @objc func makePurchaseOneTour() {
        storeManager.buyInApp(inAppID: "com.istanbul.audioguide.onetour")
    }
    
    /*@IBAction func firstViewAction(_ sender: UIButton) {
        setupView(for: sender)
        typePurchase = "month"
    }
    
    @IBAction func secondViewAction(_ sender: UIButton) {
        setupView(for: sender)
        typePurchase = "endless"
    }
    
    @IBAction func makePurchase(_ sender: Any) {
        if typePurchase == "month" {
            storeManager.buyInApp(inAppID: "com.redrazr.redstickerz")
        } else {
            storeManager.buyInApp(inAppID: "com.redrazr.redstickerz.endless")
        }
    }
    
    @IBAction func restorePurchase(_ sender: Any) {
        storeManager.restorePurchases()
    }*/
}
