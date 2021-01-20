//
//  IAPService.swift
//  Foodzilla
//
//  Created by Quinton Quaye on 5/10/19.
//  Copyright © 2019 Quinton Quaye. All rights reserved.
//

import Foundation
import StoreKit // for in app purchases

protocol IAPServiceDelegate {
    func iapProductsLoaded()
}
class IAPSerivce: NSObject, SKProductsRequestDelegate{
    
    static let instance = IAPSerivce()
    
    //the delegate
    var delegate: IAPServiceDelegate?
    
    var products = [SKProduct]()
    var productIds = Set<String>()
    var productRequest = SKProductsRequest()
    //userDefaults
    var nonConsumablePurchaseWasMade = UserDefaults.standard.bool(forKey: "nonConsumablePurchaseWasMade")
    
    
    override init(){
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    func loadProducts(){
        print("Products are being loaded!")
        productIdToStringSet()
        requestProducts(forIds: productIds)
        print("requested IAP Ids: \(productIds)")
    }
    
    func productIdToStringSet(){
        // beacareful the order is reversed when reloaded
        let theseProductIds = [IAP_MEAL_ID, IAP_HIDE_ADS_ID]
        for id in theseProductIds{
            productIds.insert(id)
        }
    }
    
    func requestProducts(forIds ids: Set<String> ){
        print("some body is calling me")
        //if there are errors pending call...
        productRequest.cancel()
        //..
        
        productRequest = SKProductsRequest(productIdentifiers: ids)
        productRequest.delegate = self
        //sends to itunes
        productRequest.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        //after apple sends back the response...
        self.products = response.products
        print("product response: \(response.products)")
        if products.count == 0 {
            requestProducts(forIds: productIds)
        }else{
            delegate?.iapProductsLoaded()
        }
    }
    
    
    func attemptPurchaseForItemWith(productIndex: Product){
        let product = products[productIndex.rawValue]
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
}

extension IAPSerivce: SKPaymentTransactionObserver{
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions{
            switch transaction.transactionState{
            case .purchased: SKPaymentQueue.default().finishTransaction(transaction)
            
            complete(transaction: transaction)
            
            sendNotificationFor(status: .purchased, withIdentifier: transaction.payment.productIdentifier)
            
                debugPrint("Purchase was successful")
                break
            case .restored:
                break
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                sendNotificationFor(status: .failed, withIdentifier: nil)
                break
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
    }
    
    
    func complete(transaction: SKPaymentTransaction){
        switch transaction.payment.productIdentifier{
        case IAP_MEAL_ID:
            break
        case IAP_HIDE_ADS_ID:
            setNonConsumablePurchase(true)
            break
        default:
            break
        }
    }
    
    
    func setNonConsumablePurchase(_ status: Bool){
        UserDefaults.standard.set(status, forKey: "nonConsumablePurchaseWasMade")
    }
    func sendNotificationFor(status: PurchaseStatus, withIdentifier identifier: String?){
        switch status {
        case .purchased:
            NotificationCenter.default.post(name: NSNotification.Name(IAPServicePurchaseNotification), object: identifier)
            break
        case .restored:
            NotificationCenter.default.post(name: NSNotification.Name(IAPServiceRestoreNotification), object: nil)
            break
        case .failed:
            NotificationCenter.default.post(name: NSNotification.Name(IAPServiceFailureNotification), object: nil)
            break
        }
    }
}


