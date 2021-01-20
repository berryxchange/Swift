//
//  menuViewController.swift
//  ChurchAppOne
//
//  Created by Quinton Quaye on 1/27/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import FirebaseAuth
class menuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Text placeHolder"
        
        
        
        switch indexPath.row {
            
        case 0:
            cell.textLabel?.text = "Main Page"
        case 1:
            cell.textLabel?.text = "Users"
            
        case 2:
            cell.textLabel?.text = "Sign Out"
        
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let slideDownTransition = SlideDownTransitionAnimator()
        let slideRightTransition = SlideRightTransitionAnimator()
        
        switch indexPath.row {
        case 0:
            
           // performSegue(withIdentifier: "UnwindToMainSegue" , sender: self)
            print(slideDownTransition.isPresenting)
            dismiss(animated: true, completion: nil)
            
            
        case 1:
            slideDownTransition.isPresenting = true
            let controller = storyboard.instantiateViewController(withIdentifier: "UsersNavigationController") as UIViewController
            
            controller.transitioningDelegate = slideRightTransition
            
           present(controller, animated: true, completion: nil)
            
        case 2:
            do {
                try FIRAuth.auth()?.signOut()
                dismiss(animated: true, completion: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        default:
            break
        }
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
