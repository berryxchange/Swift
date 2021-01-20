//
//  WalkthroughContentViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 6/20/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController {
    @IBOutlet weak var walkthroughImageBackground: UIImageView!
    @IBOutlet weak var walkthrouhTitle: UILabel!
    @IBOutlet weak var walkthroughDescription: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var skipButton: UIButton!
    
    
    
    var index = 0
    var wTitle = ""
    var wDescription = ""
    var wImage = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pageViewController = parent as! walkthroughPageViewController
        pageControl.numberOfPages =
            pageViewController.pageTitles.count
        
        pageControl.currentPage = index
        walkthrouhTitle.text = wTitle
        walkthroughDescription.text = wDescription
        walkthroughImageBackground.image = UIImage(named: wImage)
        
        // switching the index based on the incoming viewController
        let nextButtonRadius:CGFloat = 35
        if pageViewController.viewingIntroWalkthrough == true{
        
            walkthroughDescription.font = UIFont(name: walkthroughDescription.font.fontName, size: 14)
            
            
            switch index {
            case 0...9:
                nextButton.setTitle("Next", for: .normal)
                nextButton.setTitleColor(UIColor.white, for: .normal)
                nextButton.layer.backgroundColor = #colorLiteral(red: 0.4431372549, green: 0.7098039216, blue: 0.9098039216, alpha: 1)
                nextButton.layer.cornerRadius = nextButtonRadius
                
            case 10:
                nextButton.setTitle("Finish", for: .normal)
                nextButton.layer.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                nextButton.setTitleColor(UIColor.white, for: .normal)
                nextButton.layer.cornerRadius = 4
            default: break
                
            }
            
        }else if pageViewController.viewingEventsWalkthrough == true{
             walkthroughDescription.font = UIFont(name: walkthroughDescription.font.fontName, size: 14)
            
            switch index {
            case 0...17:
                nextButton.setTitle("Next", for: .normal)
                nextButton.setTitleColor(UIColor.white, for: .normal)
                nextButton.layer.backgroundColor = #colorLiteral(red: 0.4431372549, green: 0.7098039216, blue: 0.9098039216, alpha: 1)
                nextButton.layer.cornerRadius = nextButtonRadius
                
            case 18:
                nextButton.setTitle("Finish", for: .normal)
                nextButton.layer.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                nextButton.setTitleColor(UIColor.white, for: .normal)
                nextButton.layer.cornerRadius = 4
            default: break
                
            }
            
        }else if pageViewController.viewingSocialWalkthrough == true{
             walkthroughDescription.font = UIFont(name: walkthroughDescription.font.fontName, size: 14)
            
            switch index {
            case 0...4:
                nextButton.setTitle("Next", for: .normal)
                nextButton.setTitleColor(UIColor.white, for: .normal)
                nextButton.layer.backgroundColor = #colorLiteral(red: 0.4431372549, green: 0.7098039216, blue: 0.9098039216, alpha: 1)
                nextButton.layer.cornerRadius = nextButtonRadius
                
            case 5:
                nextButton.setTitle("Finish", for: .normal)
                nextButton.layer.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                nextButton.setTitleColor(UIColor.white, for: .normal)
                nextButton.layer.cornerRadius = 4
            default: break
                
            }
            
        }else if pageViewController.viewingPrayerWalkthrough == true{
             walkthroughDescription.font = UIFont(name: walkthroughDescription.font.fontName, size: 14)
            
            switch index {
            case 0:
                nextButton.setTitle("Next", for: .normal)
                nextButton.setTitleColor(UIColor.white, for: .normal)
                nextButton.layer.backgroundColor = #colorLiteral(red: 0.4431372549, green: 0.7098039216, blue: 0.9098039216, alpha: 1)
                nextButton.layer.cornerRadius = nextButtonRadius
                
            case 1:
                nextButton.setTitle("Finish", for: .normal)
                nextButton.layer.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                nextButton.setTitleColor(UIColor.white, for: .normal)
                nextButton.layer.cornerRadius = 4
            default: break
                
            }
            
        }else if pageViewController.viewingPastoralWalkthrough == true{
             walkthroughDescription.font = UIFont(name: walkthroughDescription.font.fontName, size: 14)
            
            switch index {
            case 0...2:
                nextButton.setTitle("Next", for: .normal)
                nextButton.setTitleColor(UIColor.white, for: .normal)
                nextButton.layer.backgroundColor = #colorLiteral(red: 0.4431372549, green: 0.7098039216, blue: 0.9098039216, alpha: 1)
                nextButton.layer.cornerRadius = nextButtonRadius
                
            case 3:
                nextButton.setTitle("Finish", for: .normal)
                nextButton.layer.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                nextButton.setTitleColor(UIColor.white, for: .normal)
                nextButton.layer.cornerRadius = 4
            default: break
                
            }
            
        }else if pageViewController.viewingChatWalkthrough == true{
             walkthroughDescription.font = UIFont(name: walkthroughDescription.font.fontName, size: 14)
            
            switch index {
            case 0:
                nextButton.setTitle("Next", for: .normal)
                nextButton.setTitleColor(UIColor.white, for: .normal)
                nextButton.layer.backgroundColor = #colorLiteral(red: 0.4431372549, green: 0.7098039216, blue: 0.9098039216, alpha: 1)
                nextButton.layer.cornerRadius = nextButtonRadius
                
            case 1:
                nextButton.setTitle("Finish", for: .normal)
                nextButton.layer.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                nextButton.setTitleColor(UIColor.white, for: .normal)
                nextButton.layer.cornerRadius = 4
            default: break
                
            }
            
        }else if pageViewController.viewingClassWalkthrough == true{
             walkthroughDescription.font = UIFont(name: walkthroughDescription.font.fontName, size: 14)
            
            switch index {
            case 0...6:
                nextButton.setTitle("Next", for: .normal)
                nextButton.setTitleColor(UIColor.white, for: .normal)
                nextButton.layer.backgroundColor = #colorLiteral(red: 0.4431372549, green: 0.7098039216, blue: 0.9098039216, alpha: 1)
                nextButton.layer.cornerRadius = nextButtonRadius
                
            case 7:
                nextButton.setTitle("Finish", for: .normal)
                nextButton.layer.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                nextButton.setTitleColor(UIColor.white, for: .normal)
                nextButton.layer.cornerRadius = 4
            default: break
                
            }
            
        }else if pageViewController.viewingDashboardWalkthrough == true{
             walkthroughDescription.font = UIFont(name: walkthroughDescription.font.fontName, size: 14)
            
            switch index {
            case 0...6:
                nextButton.setTitle("Next", for: .normal)
                nextButton.setTitleColor(UIColor.white, for: .normal)
                nextButton.layer.backgroundColor = #colorLiteral(red: 0.4431372549, green: 0.7098039216, blue: 0.9098039216, alpha: 1)
                nextButton.layer.cornerRadius = nextButtonRadius
                
            case 7:
                nextButton.setTitle("Finish", for: .normal)
                nextButton.layer.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                nextButton.setTitleColor(UIColor.white, for: .normal)
                nextButton.layer.cornerRadius = 4
            default: break
                
            }
            
        }else if pageViewController.viewingProfileWalkthrough == true{
             walkthroughDescription.font = UIFont(name: walkthroughDescription.font.fontName, size: 14)
            
            switch index {
            case 0...8:
                nextButton.setTitle("Next", for: .normal)
                nextButton.setTitleColor(UIColor.white, for: .normal)
                nextButton.layer.backgroundColor = #colorLiteral(red: 0.4431372549, green: 0.7098039216, blue: 0.9098039216, alpha: 1)
                nextButton.layer.cornerRadius = nextButtonRadius
                
            case 9:
                nextButton.setTitle("Finish", for: .normal)
                nextButton.layer.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                nextButton.setTitleColor(UIColor.white, for: .normal)
                nextButton.layer.cornerRadius = 4
            default: break
                
            }
            
        }
        // Do any additional setup after loading the view.
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func nextButton(_ sender: Any) {
        let pageViewController = parent as! walkthroughPageViewController
        
            if pageViewController.viewingIntroWalkthrough == true{
            
                switch index {
                case 0...9:
                    
                    pageViewController.next(index: index)
                    
                case 10:
                    UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
                    dismiss(animated: true, completion: nil)
                    
                default: break
                    
                }
            
            
            }else if pageViewController.viewingEventsWalkthrough == true{
            
            switch index {
            case 0...17:
            pageViewController.next(index: index)
            
            case 18:
                UserDefaults.standard.set(true, forKey: "hasViewedEventsWalkthrough")
                dismiss(animated: true, completion: nil)
            default: break
            
            }
            
            }else if pageViewController.viewingSocialWalkthrough == true{
            
            switch index {
            case 0...4:
            pageViewController.next(index: index)
            
            case 5:
                UserDefaults.standard.set(true, forKey: "hasViewedSocialWalkthrough")
                dismiss(animated: true, completion: nil)
            default: break
            
            }
            
            }else if pageViewController.viewingPrayerWalkthrough == true{
            
            switch index {
            case 0:
            pageViewController.next(index: index)
            
            case 1:
                UserDefaults.standard.set(true, forKey: "hasViewedPrayerWalkthrough")
                dismiss(animated: true, completion: nil)
            default: break
            
            }
            
            }else if pageViewController.viewingPastoralWalkthrough == true{
            
            switch index {
            case 0...2:
            pageViewController.next(index: index)
            
            case 3:
                UserDefaults.standard.set(true, forKey: "hasViewedPastoralWalkthrough")
                dismiss(animated: true, completion: nil)
            default: break
            
            }
            
            }else if pageViewController.viewingChatWalkthrough == true{
            
            switch index {
            case 0:
            pageViewController.next(index: index)
            
            case 1:
                UserDefaults.standard.set(true, forKey: "hasViewedChatWalkthrough")
                dismiss(animated: true, completion: nil)
            default: break
            
            }
            
            }else if pageViewController.viewingClassWalkthrough == true{
            
            switch index {
            case 0...6:
            pageViewController.next(index: index)
            
            case 7:
                UserDefaults.standard.set(true, forKey: "hasViewedClassWalkthrough")
                dismiss(animated: true, completion: nil)
            default: break
            
            }
            
            }else if pageViewController.viewingDashboardWalkthrough == true{
            
            switch index {
            case 0...6:
            pageViewController.next(index: index)
            
            case 7:
                UserDefaults.standard.set(true, forKey: "hasViewedDashboardWalkthrough")
                dismiss(animated: true, completion: nil)
            default: break
            
            }
            
            }else if pageViewController.viewingProfileWalkthrough == true{
            
            switch index {
            case 0...8:
            pageViewController.next(index: index)
            
            case 9:
                UserDefaults.standard.set(true, forKey: "hasViewedProfileWalkthrough")
                dismiss(animated: true, completion: nil)
            default: break
            
            }
        }
    }
    
    @IBAction func skipButton(_ sender: Any) {
        let pageViewController = parent as! walkthroughPageViewController
        
        if pageViewController.viewingIntroWalkthrough == true{
            
            
                UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
                dismiss(animated: true, completion: nil)
            
            
        }else if pageViewController.viewingEventsWalkthrough == true{
            
            
                UserDefaults.standard.set(true, forKey: "hasViewedEventsWalkthrough")
                dismiss(animated: true, completion: nil)
            
            
        }else if pageViewController.viewingSocialWalkthrough == true{
            
                UserDefaults.standard.set(true, forKey: "hasViewedSocialWalkthrough")
                dismiss(animated: true, completion: nil)
            
            
        }else if pageViewController.viewingPrayerWalkthrough == true{
            
            
                UserDefaults.standard.set(true, forKey: "hasViewedPrayerWalkthrough")
                dismiss(animated: true, completion: nil)
           
            
        }else if pageViewController.viewingPastoralWalkthrough == true{
            
            
                UserDefaults.standard.set(true, forKey: "hasViewedPastoralWalkthrough")
                dismiss(animated: true, completion: nil)
            
            
        }else if pageViewController.viewingChatWalkthrough == true{
            
            
                UserDefaults.standard.set(true, forKey: "hasViewedChatWalkthrough")
                dismiss(animated: true, completion: nil)
            
            
        }else if pageViewController.viewingClassWalkthrough == true{
            
            
                UserDefaults.standard.set(true, forKey: "hasViewedClassWalkthrough")
                dismiss(animated: true, completion: nil)
            
            
        }else if pageViewController.viewingDashboardWalkthrough == true{
            
            
                UserDefaults.standard.set(true, forKey: "hasViewedDashboardWalkthrough")
                dismiss(animated: true, completion: nil)
            
            
        }else if pageViewController.viewingProfileWalkthrough == true{
            
            
                UserDefaults.standard.set(true, forKey: "hasViewedProfileWalkthrough")
                dismiss(animated: true, completion: nil)
            
        }
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
