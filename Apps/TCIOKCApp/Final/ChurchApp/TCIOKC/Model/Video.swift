//
//  Video.swift
//  TCIApp
//
//  Created by Quinton Quaye on 1/13/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit


class Video: NSObject {
    
    
    var videoId: String? = ""
    var videoTitle: String? = ""
    var videoDescription: String? = ""
    var videoImage: String? = ""
    var videoThumbnailUrl: String? = ""
    var videoDate: String? = ""
    
}

struct AppUtility {
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
    
}
