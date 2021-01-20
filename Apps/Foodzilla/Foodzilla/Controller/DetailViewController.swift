//
//  DetailViewController.swift
//  Foodzilla
//
//  Created by Quinton Quaye on 5/10/19.
//  Copyright © 2019 Quinton Quaye. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodPrice: UILabel!
    @IBOutlet weak var uglyAd: UIView!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var hideAdButton: UIButton!
    
    var foodItem: Food!
    private var hiddenStatus: Bool = UserDefaults.standard.bool(forKey: "nonConsumablePurchaseWasMade")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        foodImage.image = UIImage(named: foodItem.foodImage!)
        foodName.text = foodItem.foodName
        foodPrice.text = "\(foodItem.foodPrice!)"
        buyButton.setTitle("Buy this for \(foodItem.foodPrice!)", for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchase), name: NSNotification.Name(IAPServicePurchaseNotification), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(handleFailure), name: NSNotification.Name(IAPServiceFailureNotification), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showOrHideAds()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    @objc func handlePurchase(_ notification: Notification){
        guard let productID = notification.object as? String else{ return }
        
        switch productID{
        case IAP_MEAL_ID:
            buyButton.isEnabled = true
            debugPrint("Meal successfully purchased!")
            break
        case IAP_HIDE_ADS_ID:
            uglyAd.isHidden = true
            hideAdButton.isHidden = true
            debugPrint("Your ads have been purchased!")
            break
        default:
            break
        }
    }
    
    
    @objc func handleFailure(){
        buyButton.isEnabled = true
        print("Purchase Failed...")
    }
    
    
    func showOrHideAds(){
        uglyAd.isHidden = hiddenStatus
        hideAdButton.isHidden = hiddenStatus
    }
    
    @IBAction func buyButtonWasPressed(_ sender: Any) {
        //states which type of item is being bought: (hide ad, or meal)
       buyButton.isEnabled = false
        IAPSerivce.instance.attemptPurchaseForItemWith(productIndex: .meal)
    }
    
    @IBAction func HideButtonWasPressed(_ sender: Any) {
        IAPSerivce.instance.attemptPurchaseForItemWith(productIndex: .hideAds)
    }
    @IBAction func closeButtonWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
