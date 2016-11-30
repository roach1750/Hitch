//
//  Trip.swift
//  Hitch
//
//  Created by Andrew Roach on 11/3/16.
//  Copyright © 2016 Andrew Roach. All rights reserved.
//

import UIKit
import RealmSwift

class Trip: Object {
    
    //Trip Properties
    dynamic var creationDate = NSDate()
    dynamic var creatorUserID = ""
    
    dynamic var isDriver = false
    dynamic var isMatched = false
    dynamic var entityID =  ""

    //Origin
    dynamic var originLatitude: Double = 0.0
    dynamic var originLongitude: Double = 0.0
    dynamic var originName = ""
    dynamic var originDate = NSDate()
    
    
    
    
    //destination 
    dynamic var destinationLatitude: Double = 0.0
    dynamic var destinationLongitude: Double = 0.0
    dynamic var destinationName = ""
    dynamic var destinationDate = NSDate()
    


    
    override func hostToKinveyPropertyMapping() -> [AnyHashable : Any]! {
        return [
            "creationDate" : "creationDate",
            "creatorUserID" : "creatorUserID",
            "isDriver" : "isDriver",
            "isMatched" : "isMatched",
            
            "originLatitude" : "originLatitude",
            "originLongitude" : "originLongitude",

            "originName" : "originName",
            "originDate" : "originDate",
            
            "destinationLatitude": "destinationLatitude",
            "destinationLongitude": "destinationLongitude",
            "destinationName": "destinationName",
            "destinationDate" : "destinationDate",
            "entityID" : KCSEntityKeyId //the required _id field
        ]
    }
    
    
    
    
    
}
