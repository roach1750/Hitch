//
//  Trip+CoreDataProperties.swift
//  
//
//  Created by Andrew Roach on 10/27/16.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip");
    }

    @NSManaged public var originLatitude: Double
    @NSManaged public var originLongitude: Double
    @NSManaged public var destinationLatitude: Double
    @NSManaged public var detinationLongitude: Double

}
