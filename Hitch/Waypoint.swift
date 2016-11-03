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
    dynamic var date: Date?
    dynamic var placeName: String?

    class func createWaypoint (location:CLLocation, isDestination: NSNumber, driver: NSNumber, matched: NSNumber, user: KCSUser, placeName: String) -> Waypoint {
        let wp = Waypoint()
        wp.location = location
        wp.isDestination = isDestination
        wp.driver = driver
        wp.user = user
        wp.placeName = placeName
        return wp
    }
    
    
    override func hostToKinveyPropertyMapping() -> [AnyHashable : Any]! {
        return [
            "location" : KCSEntityKeyGeolocation,
            "isDestination" : "isDestination",
            "driver" : "driver",
            "matched" : "matched",
            "user" : "user",
            "date": "date",
            "placeName" : "placeName",
            "entityID" : KCSEntityKeyId //the required _id field
        ]
    }
}
