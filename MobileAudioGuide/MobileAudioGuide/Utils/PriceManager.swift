//
//  PriceManager.swift
//  MobileAudioGuide


import UIKit
import StoreKit

class PriceManager: NSObject {
    func getPricesForInApps(inAppsIDs: Set<String>) {
        if !SKPaymentQueue.canMakePayments() {
            print("Can't make payments")
            return
        }
        
        let request = SKProductsRequest(productIdentifiers: inAppsIDs)
        request.delegate = self
        request.start()
    }
}

extension PriceManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        for product in response.products {
            let nf = NumberFormatter()
            nf.numberStyle = .currency
            nf.locale = product.priceLocale
            let price = product.price.stringValue + " " + nf.currencySymbol
            UserDefaults.standard.set(price, forKey: product.productIdentifier)
        }
        
        print("Invalid identifiers: \(response.invalidProductIdentifiers)")
    }
}
