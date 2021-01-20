//
//  Media.swift
//  TCIApp
//
//  Created by Quinton Quaye on 12/28/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import Foundation
struct Media {
    var mediaTitle = ""
    var mediaDate = ""
    var hostName = ""
    
    init(mediaTitle: String, mediaDate: String, hostName: String) {
        self.mediaTitle = mediaTitle
        self.mediaDate = mediaDate
        self.hostName = hostName
    }
}
