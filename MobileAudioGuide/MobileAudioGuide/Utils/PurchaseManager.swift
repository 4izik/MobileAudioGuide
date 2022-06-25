//
//  PurchaseManager.swift
//  MobileAudioGuide
//
//  Created by Aleksei Pavlov on 24.06.2022.
//

import Foundation
import StoreKit

class PurchaseManager: NSObject {
    
    static let shared = PurchaseManager()
    private override init() {}
    
    var products: [SKProduct] = []
    let paymentQueue = SKPaymentQueue.default()
    
    func setupPurchases(callback: @escaping (Bool) -> ()) {
        if SKPaymentQueue.canMakePayments() {
            paymentQueue.add(self)
            callback(true)
        } else {
            callback(false)
        }
    }
    
    func getAllProducts() {
        let identifiers: Set = [
            InAppProducts.firstTour.rawValue,
            InAppProducts.secondTour.rawValue,
            InAppProducts.thirdTour.rawValue,
            InAppProducts.allTours.rawValue
        ]
        
        let productsRequest = SKProductsRequest(productIdentifiers: identifiers)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func purchaseProduct(withIdentifier identifier: String) {
        guard let product = products.filter({ $0.productIdentifier == identifier }).first else {
            print("No products")
            return }
        let payment = SKPayment(product: product)
        paymentQueue.add(payment)
    }
    
    func restorePurchases() {
        paymentQueue.restoreCompletedTransactions()
    }
    
    func isProductPurchased(withIdentifier identifier: String) -> Bool {
        return UserDefaults.standard.bool(forKey: identifier) || UserDefaults.standard.bool(forKey: InAppProducts.allTours.rawValue)
    }
}

extension PurchaseManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch transaction.transactionState {
            case .deferred: print("Deferred")
            case .purchasing: break
            case .failed: purchaseFailed(transaction: transaction)
            case .purchased: purchaseCompleted(transaction: transaction)
            case .restored: purchasRestored(transaction: transaction)
            @unknown default: break
            }
        }
    }
    
    private func purchaseFailed(transaction: SKPaymentTransaction) {
        if let transactionError = transaction.error as? NSError {
            if transactionError.code != SKError.paymentCancelled.rawValue {
                print("Transaction error: \(transactionError.localizedDescription)")
            }
        }
        paymentQueue.finishTransaction(transaction)
    }
    
    private func purchaseCompleted(transaction: SKPaymentTransaction) {
        UserDefaults.standard.set(true, forKey: transaction.payment.productIdentifier)
        paymentQueue.finishTransaction(transaction)
    }
    
    private func purchasRestored(transaction: SKPaymentTransaction) {
        UserDefaults.standard.set(true, forKey: transaction.payment.productIdentifier)
        paymentQueue.finishTransaction(transaction)
    }
}

extension PurchaseManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        self.products = response.products
        products.forEach { print($0.productIdentifier) }
    }
}
