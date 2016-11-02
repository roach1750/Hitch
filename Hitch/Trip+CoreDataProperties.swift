//
//  Trip+CoreDataProperties.swift
//  
//
//  Created by Andrew Roach on 11/1/16.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip");
    }

    @NSManaged public var destinationLatitude: Double
    @NSManaged public var detinationLongitude: Double
    @NSManaged public var originLatitude: Double
    @NSManaged public var originLongitude: Double
    @NSManaged public var entityID: String?
    @NSManaged public var creationDate: Date?


}
