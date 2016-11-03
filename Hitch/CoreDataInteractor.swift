//
//  CoreDataInteractor.swift
//  Hitch
//
//  Created by Andrew Roach on 11/1/16.
//  Copyright © 2016 Andrew Roach. All rights reserved.
//

import UIKit
import CoreData

class CoreDataInteractor: NSObject {


    func createTrip (dLat: Double, dLong: Double, oLat: Double, oLong: Double, date: Date ) -> Trip {
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Trip", in: managedObjectContext)
        let newTrip = Trip(entity: entity!, insertInto: managedObjectContext)
        
        newTrip.destinationLatitude = dLat
        
        newTrip.detinationLongitude = dLong
        newTrip.originLatitude = oLat
        newTrip.originLongitude = dLat
        newTrip.creationDate = date
        
        return newTrip
    }
    
    
     func saveTripToCoreData(newTrip: Trip) {
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        managedObjectContext.performAndWait {
                //create new, unique trip
            _ = Trip.tripWithTripInfo(newTrip, inManagedObjectContext: managedObjectContext)
            do {
                try managedObjectContext.save()
            }
            catch let error {
                print(error)
            }
        }
    }
    
    func fetchAllTripsFromCoreData() -> [Trip]?{
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<Trip>(entityName:"Trip")
        do {
            let results = try managedObjectContext.fetch(request)
            print("Feteched \(results.count) Trips")
            return results
        }
        catch {
            print(error)
        }
        return nil
    }
    
    func deleteAllPostFromCoreDatabase() {
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Trip> = NSFetchRequest(entityName: "Trip")
        do {
            let queryResults = try managedObjectContext.fetch(fetchRequest)
            print("Deleted \(queryResults.count) objects")
            for result in queryResults {
                managedObjectContext.delete(result)
            }
            
        } catch let error {
            print(error)
        }
    }
    
    
    
    
    
}
