//
//  WayPoint.swift
//  Hitch
//
//  Created by Andrew Roach on 10/20/16.
//  Copyright © 2016 Andrew Roach. All rights reserved.
//

import UIKit

class Waypoint: NSObject {
    
    dynamic var location: CLLocation!
    dynamic var isDestination: NSNumber!
    dynamic var driver: NSNumber!
    dynamic var matched: NSNumber!
    dynamic var user: KCSUser!
    dynamic var entityID: String?
    
    override func hostToKinveyPropertyMapping() -> [AnyHashable : Any]! {
        return [
            "location" : KCSEntityKeyGeolocation,
            "isDestination" : "isDestination",
            "driver" : "driver",
            "matched" : "matched",
            "user" : "user",
            "entityID" : KCSEntityKeyId //the required _id field
        ]
    }
}
