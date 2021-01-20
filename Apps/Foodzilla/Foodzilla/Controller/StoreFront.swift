//
//  ViewController.swift
//  Foodzilla
//
//  Created by Quinton Quaye on 5/10/19.
//  Copyright © 2019 Quinton Quaye. All rights reserved.
//

import UIKit

class StoreFront: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var foodItems: [Food] = [
        Food(foodImage: "food1", foodName: "Salmon", foodPrice: 9.99),
        Food(foodImage: "food2", foodName: "Cheeseburger", foodPrice: 9.99),
        Food(foodImage: "food3", foodName: "Burrito", foodPrice: 9.99),
        Food(foodImage: "food4", foodName: "Spaghetti", foodPrice: 9.99),
        Food(foodImage: "food5", foodName: "Pizza", foodPrice: 9.99),
        Food(foodImage: "food6", foodName: "Salad", foodPrice: 9.99)
    ]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        IAPSerivce.instance.delegate = self
        IAPSerivce.instance.loadProducts()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FoodCollectionViewCell
        
        let thisFoodItem = foodItems[indexPath.row]
        cell.getFood(item: thisFoodItem)
        
        return cell
    }

    @IBAction func restoreButtonWasPressed(_ sender: Any) {
        //do something
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let detailController = storyboard.instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
        
            detailController.foodItem = foodItems[indexPath.row]
        self.present(detailController, animated: true, completion: nil)
    }
}

extension StoreFront: IAPServiceDelegate{
    func iapProductsLoaded() {
        print("IAP Products Loaded")
    }
}
