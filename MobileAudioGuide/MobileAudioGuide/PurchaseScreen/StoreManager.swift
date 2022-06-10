//
//  StoreManager.swift
//  RedStickers
//
//  Created by Настя on 22.03.2022.
//

import Foundation
import StoreKit

let nPurchaseCompleted = "nPurchaseCompleted"

class StoreManager: NSObject {
    class func didBuyFullVersion() {
        UserDefaults.standard.set(true, forKey: "FullVersion")
    }
    
    class var isFullVersion: Bool {
        return UserDefaults.standard.bool(forKey: "FullVersion")
    }
    
    func buyInApp(inAppID: String) {
        if !SKPaymentQueue.canMakePayments() {
            print("Can't make payments")
            return
        }
        
        let request = SKProductsRequest(productIdentifiers: [inAppID])
        request.delegate = self
        request.start()
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension StoreManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count > 0 {
            let product = response.products[0]
            let payment = SKPayment(product: product)
            
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        }
        
        print("Invalid identifiers: \(response.invalidProductIdentifiers)")
    }
}
extension StoreManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing: print("purchasing")
            case .purchased: print("purchased")
                queue.finishTransaction(transaction)
                StoreManager.didBuyFullVersion()
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: nPurchaseCompleted), object: nil)
            case .failed: print("failed")
                queue.finishTransaction(transaction)
            case .restored: print("restored")
                queue.finishTransaction(transaction)
                StoreManager.didBuyFullVersion()
            case .deferred: print("deferred")
            }
        }
    }
    
    
}
