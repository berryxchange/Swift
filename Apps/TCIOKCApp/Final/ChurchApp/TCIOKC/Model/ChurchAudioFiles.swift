//
//  ChurchAudioFiles.swift
//  ChurchAppOne
//
//  Created by Quinton Quaye on 11/23/18.
//  Copyright © 2018 Transformation Church International. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct ChurchAudioTrack{
    let key: String
    var ref: FIRDatabaseReference?
    var trackImage: String?
    var trackTitle: String?
    var trackDetails: String?
    var trackAudio: String?
    init(key: String = "", trackImage: String?, trackTitle: String?, trackDetails: String?, trackAudio: String?){
        self.key = key
        self.ref = nil
        self.trackImage = trackImage
        self.trackTitle = trackTitle
        self.trackDetails = trackDetails
        self.trackAudio = trackAudio
    }
    init(snapshot: FIRDataSnapshot){
        key = snapshot.key
        ref = snapshot.ref
        var snapShotValue = snapshot.value as! [String: AnyObject]
        trackImage = snapShotValue["trackImage"] as? String
        trackTitle = snapShotValue["trackTitle"] as? String
        trackDetails = snapShotValue["trackDetails"] as? String
        trackAudio = snapShotValue["trackAudio"] as? String
    }
    func toAnyObject() -> Any{
        return [
            "trackImage": trackImage!,
            "trackTitle": trackTitle!,
            "trackDetails": trackDetails!,
            "trackAudio": trackAudio!
        ]
    }
}
