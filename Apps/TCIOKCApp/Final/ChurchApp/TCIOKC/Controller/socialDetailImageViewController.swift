//
//  socialDetailImageViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 4/27/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit

class socialDetailImageViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var image = ""

    
    @IBAction func scrollAction(_ sender: Any) {
        
    }
    
    @IBOutlet weak var socialDetailImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0

        socialDetailImage.loadImageUsingCacheWithURLString(urlString: image)
     
        // Do any additional setup after loading the view.
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return socialDetailImage
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
