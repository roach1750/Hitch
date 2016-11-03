//
//  Trip+CoreDataClass.swift
//  
//
//  Created by Andrew Roach on 10/27/16.
//
//

import Foundation
import CoreData

class Trip: NSManagedObject {
    

    
//    
//    override func hostToKinveyPropertyMapping() -> [AnyHashable : Any]! {
//        return [
//            "destinationLatitude" : "destinationLatitude",
//            "detinationLongitude" : "detinationLongitude",
//            "originLatitude" : "originLatitude",
//            "originLongitude" : "originLongitude",
//            "entityID" : KCSEntityKeyId //the required _id field
//        ]
//    }
//

    
    class func tripWithTripInfo(_ trip: Trip, inManagedObjectContext context: NSManagedObjectContext) -> Trip?
    {
        let request: NSFetchRequest<Trip> = NSFetchRequest(entityName: "Trip")
        request.predicate = NSPredicate(format: "destinationLatitude = %@", trip.destinationLatitude)
        
        if let existingtrip = (try? context.fetch(request))?.first {
            return existingtrip
        } else if let newtrip = NSEntityDescription.insertNewObject(forEntityName: "Trip", into: context) as? Trip{
            newtrip.destinationLatitude = trip.destinationLatitude
            newtrip.detinationLongitude = trip.detinationLongitude
            newtrip.originLatitude = trip.originLatitude
            newtrip.originLongitude = trip.originLongitude
            newtrip.creationDate = trip.creationDate
//            newtrip.entityID = trip.entityID
        }
        return nil
    }
}
