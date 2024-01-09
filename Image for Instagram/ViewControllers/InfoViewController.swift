//
//  InfoViewController.swift
//  Image for Instagram
//
//  Created by Saud Almutlaq on 17/05/2020.
//  Copyright © 2020 Saud Soft. All rights reserved.
//

import UIKit
import IAPurchaseManager
import StoreKit
import SafariServices

class InfoViewController: UIViewController {
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func facebook(_ sender: Any) {
        open(scheme: "https://www.facebook.com/saudsoft")
    }
    
    @IBAction func website(_ sender: Any) {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = false

        let url = URL(string: "https://saudsoft.com")
        let vc = SFSafariViewController(url: url!, configuration: config)
        present(vc, animated: true)    }
    
    @IBAction func twitter(_ sender: Any) {
        open(scheme: "https://twitter.com/saudsoft")
    }
    
    @IBAction func purchaseRemoveAds(_ sender: Any) {
        IAPManager.shared.purchaseProductWithId(productId: productID) { (error) in
            
            if error == nil {
              // successful purchase!
                print("successful purchase!")
            } else {
                print("something wrong..")
                print(error)
              // something wrong..
            }
        }
    }
    
    @IBAction func restorePurchase(_ sender: Any) {
        IAPManager.shared.restoreCompletedTransactions { (error) in
            if error != nil {
                print(error)
            } else {
                print("Restore Successful")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(IAPManager.shared.isProductPurchased(productId: productID))
        
    }
    
    /// This func will try to open social app or if fail will open safari to website
    /// - parameters:
    ///   - scheme: The website URL for the social app
    ///
    /** Example Call:
     
     @IBAction func instagramClicked(_ sender: Any) {
     open(scheme: "http://www.instagram.com/profileName")
     }
     */
    func open(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SKProduct {
    
    convenience init(identifier: String) {
        self.init()
//        var localizedPrice: String {
//            let formatter = NumberFormatter()
//            formatter.numberStyle = .currency
//            formatter.locale = priceLocale
//            return formatter.string(from: newPrice)!
//        }
        
//        let newPrice: NSDecimalNumber = NSDecimalNumber(string: price)
        self.setValue(identifier, forKey: "productIdentifier")
//        self.setValue(newPrice, forKey: "price")
//        self.setValue(localizedPrice, forKey: "priceLocale")
    }
}
