//
//  Main.swift
//  TCIApp
//
//  Created by Quinton Quaye on 12/13/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct layoutCount {
    let key: String
    let ref: FIRDatabaseReference?
    
    init(key: String){
        self.key = key
        self.ref = nil
    }
        init(snapshot: FIRDataSnapshot){
            key = snapshot.key
            let snapshotValue = snapshot.value as! [String: AnyObject]
            ref = snapshot.ref
            
    }
}
