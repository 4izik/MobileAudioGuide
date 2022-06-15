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
    
    var index: Int
    
    init(index: Int) {
        self.index = index
    }
    
    class func makePurchased(index: Int) {
        switch index {
        case 0: UserDefaults.standard.set(true, forKey: "FirstTour")
        case 1: UserDefaults.standard.set(true, forKey: "SecondTour")
        case 2: UserDefaults.standard.set(true, forKey: "ThirdTour")
        default: UserDefaults.standard.set(true, forKey: "FullVersion")
        }
    }
    
    class func isMakedPurchased(index: Int) -> Bool {
        switch index {
        case 0: return UserDefaults.standard.bool(forKey: "FirstTour")
        case 1: return UserDefaults.standard.bool(forKey: "SecondTour")
        case 2: return UserDefaults.standard.bool(forKey: "ThirdTour")
        default: return UserDefaults.standard.bool(forKey: "FullVersion")
        }
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
                StoreManager.makePurchased(index: index)
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: nPurchaseCompleted), object: nil)
            case .failed: print("failed")
                queue.finishTransaction(transaction)
            case .restored: print("restored")
                queue.finishTransaction(transaction)
                StoreManager.makePurchased(index: index)
            case .deferred: print("deferred")
            }
        }
    }
    
    
}
