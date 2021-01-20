//
//  Meal.swift
//  food tracker 2
//
//  Created by Quinton Quaye on 3/2/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import UIKit
import os.log

class Meal: NSObject, NSCoding {

    
    //MARK: Properties
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    //MARK: Types
    struct propertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
    
    
    init?(name: String, photo: UIImage?, rating: Int) {
        
        //Initialization should fail if there is no name or if the rating is negative.
        
       // the name must not be empty
        guard !name.isEmpty else {
            return nil
        }

        // the rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: propertyKey.name)
        aCoder.encode(photo, forKey: propertyKey.photo)
        aCoder.encode(rating, forKey: propertyKey.rating)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: propertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: propertyKey.photo) as? UIImage
        
        let rating = aDecoder.decodeInteger(forKey: propertyKey.rating)
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, rating: rating)
        
    }
}
