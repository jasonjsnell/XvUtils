//
//  IAP.swift
//  XvUtils
//
//  Created by Jason Snell on 2/7/18.
//  Copyright © 2018 Jason J. Snell. All rights reserved.
//

import StoreKit

public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> ()

public class IAP:NSObject  {
    
    //MARK: - VARS
    
    //MARK: Public
    //notification when a donation occurs
    public static let kAppDonationComplete = "kAppDonationComplete"
    
    public var donationProduct:SKProduct? {
        
        get {
            
            //loop through available products
            for product in _products {
                
                //if ID matchs donation id, then return the product
                if (product.productIdentifier == _donationProductID) {
                    return product
                }
            }
            
            //otherwise product is not available
            print("IAP: Error getting donation product")
            return nil
            
        }
    }
    
    //MARK: Private
    
    //array of products for this app
    fileprivate var _products:[SKProduct] = []
    
    //id for the donation purchase
    fileprivate var _donationProductID:String = ""
    
    //vars to handle the product request
    fileprivate var _productIDs: Set<String>?
    fileprivate var _productsRequest: SKProductsRequest?
    fileprivate var _productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    
    
    
    //debug
    fileprivate let debug:Bool = true
    
    //MARK: - INIT
    
    //singleton code
    public static let sharedInstance = IAP()
    override init() {
        
        //super init
        super.init()

    }
    
    //MARK: - CONNECT
    public func setup(appID:String) {
        
        //create donation product id from app string
        _donationProductID = "com.jasonjsnell."
        _donationProductID += appID
        _donationProductID += ".donation"
        
        //add to list
        _productIDs = [_donationProductID]
        
        if (debug){
            print("IAP: Connect")
        }
        
        //immediately request the product from the app store
        requestProducts{success, products in
            
            if (success && products != nil) {
                
                self._products = products!
                
                if (self.debug){
                    
                    for product in products! {
                        print("IAP: Found product:",
                              product.productIdentifier,
                              product.localizedTitle,
                              product.price.floatValue)
                    }
                }
                
            } else {
                print("IAP: Error retrieving IAP data")
            }
            
        }
    }
    
    //MARK: - BUY
    public func buy(product: SKProduct) {
        
        if (debug){
            print("IAP: Attempt to buy \(product.productIdentifier)")
        }
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    //MARK: - GET PRODUCTS
    internal func requestProducts(completionHandler: @escaping ProductsRequestCompletionHandler) {
        
        if (_productIDs != nil) {
            
            _productsRequest?.cancel()
            _productsRequestCompletionHandler = completionHandler
            
            _productsRequest = SKProductsRequest(productIdentifiers: _productIDs!)
            _productsRequest!.delegate = self
            _productsRequest!.start()
            
        } else {
            print("IAP: Error: Product IDs are nil during requestProducts")
        }
        
    }
    
    
    
}

// MARK: - SKProductsRequestDelegate

extension IAP: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        let products:[SKProduct] = response.products
        _productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
    
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        
        print("IAP: Failed to load list of products,", error.localizedDescription)
        
        _productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        _productsRequest = nil
        _productsRequestCompletionHandler = nil
    }
}

// MARK: - SKPaymentTransactionObserver

extension IAP: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            
            switch (transaction.transactionState) {
            
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("IAP: Transcation complete.")
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        
        print("IAP: Restore", productIdentifier)
        deliverPurchaseNotificationFor(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        
        if let transactionError = transaction.error as NSError? {
            if transactionError.code != SKError.paymentCancelled.rawValue {
                print("IAP: Transaction Error: \(String(describing: transaction.error?.localizedDescription))")
            }
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func deliverPurchaseNotificationFor(identifier: String?) {
        
        guard let identifier:String = identifier else { return }
        
        //currently not being used
        if (identifier == _donationProductID){
            
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: IAP.kAppDonationComplete),
                object: identifier
            )
        }
        
        
    }
}
