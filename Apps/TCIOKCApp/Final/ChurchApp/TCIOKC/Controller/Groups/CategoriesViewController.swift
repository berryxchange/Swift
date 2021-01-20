
//
//  CategoriesViewController.swift
//  GroupApp
//
//  Created by Quinton Quaye on 9/6/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import Firebase

class CategoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    var categories: [Category] = []

    var thisCategory = ""
    var administrator = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let categoryRef = FIRDatabase.database().reference(withPath: "Categories")
        // for main database
        categoryRef.observe(.value, with: {snapshot in
            
            //2 new items are an empty array
            var newCategories: [Category] = []
            
            
            for category in snapshot.children{
                let categoryItem = Category(snapshot: category as! FIRDataSnapshot)
                print(categoryItem)
                newCategories.insert(categoryItem, at: 0)
            }
            
            
            self.categories = newCategories.sorted(by: { $0.categoryName! < $1.categoryName! })
            self.tableView.reloadData()
            
        })
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].categoryName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        thisCategory = categories[indexPath.row].categoryName!
        performSegue(withIdentifier: "unwindToAddGroup", sender: self)
    }

    
    
    @IBAction func addCategory(_ sender: Any) {
        let alert = UIAlertController(title: "New Category", message: "add your desired category", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            guard let textField = alert.textFields?.first, let nameToSave = textField.text else {
                return
            }
            
            //self.categories.append(nameToSave)
            
            // function save to firebase
             let categoryItemRef = FIRDatabase.database().reference(withPath: "Categories")
                // for main database
            let categoryItem = Category(categoryName: "\(textField.text!.capitalizingFirstLetter())", Groups: [])
             
                //self.blogs.insert(blogItem, at: 0)
             let thisCategoryItem = categoryItemRef.child("\(textField.text!.lowercased())")
             thisCategoryItem.setValue(categoryItem.toAnyObject())
           
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexpath = tableView.indexPathForSelectedRow{
            thisCategory = categories[indexpath.row].categoryName!
        }
    }
    

}
