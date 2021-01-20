//
//  PaymentCollectionViewController.swift
//  OKCityChurch
//
//  Created by Quinton Quaye on 12/14/18.
//  Copyright © 2018 City Church. All rights reserved.
//

import UIKit
import SafariServices



class PaymentCollectionViewController: UICollectionViewController {

    struct PaymentProviders{
        var name: String?
        var image: String?
        var givingGroups: [paymentStyles] = []

    }
    
    struct paymentStyles {
        var name: String?
        var link: String?
    }
    
    var givingGroups: [paymentStyles] = [paymentStyles(name: "Tithes", link: "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=4GZZCSU6KV5R2"), paymentStyles(name: "Offering", link: ""), paymentStyles(name: "Special", link: "")]
    
    var paymentProviders: [PaymentProviders] = []
    
    
    let paypalPaymentLink = "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=4GZZCSU6KV5R2"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        paymentProviders = [PaymentProviders(name: "PayPal", image: "Paypal-1", givingGroups: givingGroups), PaymentProviders(name: "Easy Tithe", image: "easyTithe", givingGroups:  givingGroups),PaymentProviders(name: "Stripe", image: "Stripe", givingGroups:  givingGroups), PaymentProviders(name: "Tithe.ly", image: "tithe.ly", givingGroups:  givingGroups),PaymentProviders(name: "Kindrid", image: "kindrid", givingGroups:  givingGroups), PaymentProviders(name: "Continue To Give", image: "continueToGive", givingGroups:  givingGroups),PaymentProviders(name: "Secure Give", image: "secureGive", givingGroups:  givingGroups), PaymentProviders(name: "Mogiv", image: "mogiv", givingGroups:  givingGroups)
        ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return paymentProviders.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! paymentsCollectionViewCell
    
        // Configure the cell
        let thisPaymentProvider = paymentProviders[indexPath.row]
        cell.paymentImage.image = UIImage(named: thisPaymentProvider.image!)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // prompt where to give
        
        //promt paypal link
        
        let alertMessage = UIAlertController(title: "Giving Destination", message: "Where would you like to donate to?", preferredStyle: .alert)
        
        var someAction = UIAlertAction()
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        for i in givingGroups{
            someAction = UIAlertAction(title: i.name, style: .default) { action in
                switch indexPath.row{
                case 0:
                    if let url = URL(string: i.link!){
                        UIApplication.shared.open(url)
                    }
                default:
                    return
                }
            }
            alertMessage.addAction(someAction)
        }
        alertMessage.addAction(cancelAction)
        present(alertMessage, animated: true, completion: nil)
            
        
        
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
