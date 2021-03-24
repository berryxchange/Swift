//
//  ViewController.swift
//  CookieFactory
//
//  Created by Quinton Quaye on 3/23/21.
//

import UIKit

class CookieController: UIViewController {


    @IBOutlet weak var shortbreadCookieLabel: UILabel!
    
    @IBOutlet weak var chocolateChipCookieLabel: UILabel!
    
    @IBOutlet weak var gingerbreadCookieLabel: UILabel!
    
    @IBOutlet weak var totalCookieLabel: UILabel!

    
    @IBOutlet weak var generateShortbreadButton: UIButton!
    
    @IBOutlet weak var generateChocolateChipButton: UIButton!
    
    @IBOutlet weak var generateGingerbreadButton: UIButton!
    
    @IBOutlet weak var clearAllButton: UIButton!
    
    
    
    var shortbreadCookies: [Cookie]? = [Cookie]()
    var chocolateChipCookies: [Cookie]? = [Cookie]()
    var gingerbreadCookies: [Cookie]? = [Cookie]()
    var totalCookies: [Cookie]? = [Cookie]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        totalCookies = shortbreadCookies! + chocolateChipCookies! + gingerbreadCookies!
    }
    
    //the reset button action
    func reset(){
        self.chocolateChipCookies!.removeAll()
        self.shortbreadCookies!.removeAll()
        self.gingerbreadCookies!.removeAll()
        self.totalCookies!.removeAll()
    }
    
    // the cookie Addition
    func addShortbreadCookie() -> Void{
        let cookie = Cookie(type: .shortbread)
        shortbreadCookies?.append(cookie)
        refreshUI()
    }
    
    func addChocolateChipCookie() -> Void{
        let cookie = Cookie(type: .chocolateChip)
        chocolateChipCookies?.append(cookie)
        refreshUI()
    }
    
    func addGingerbreadCookie() -> Void{
        let cookie = Cookie(type: .gingerbread)
        gingerbreadCookies?.append(cookie)
        refreshUI()
    }
    
    func refreshUI() -> Void{
        totalCookies = shortbreadCookies! + chocolateChipCookies! + gingerbreadCookies!
        
        gingerbreadCookieLabel.text = "\(gingerbreadCookies!.count.description)"
        chocolateChipCookieLabel.text = "\(chocolateChipCookies!.count.description)"
        shortbreadCookieLabel.text = "\(shortbreadCookies!.count.description)"
        totalCookieLabel.text = "\(totalCookies!.count.description)"
    }
    
    
    @IBAction func generateShortbreadButtonClicked(_ sender: Any) {
        addShortbreadCookie()
    }
    
    @IBAction func generateChocolateChipButtonClicked(_ sender: Any) {
        addChocolateChipCookie()
    }
    
    @IBAction func generateGingerbreadButtonClicked(_ sender: Any) {
        addGingerbreadCookie()
    }
    
    @IBAction func clearAllButtonClicked(_ sender: Any) {
        reset()
        refreshUI()
    }
    
    
}

