//
//  kinveyUploader.swift
//  Hitch
//
//  Created by Andrew Roach on 10/21/16.
//  Copyright © 2016 Andrew Roach. All rights reserved.
//

import UIKit

class KinveyUploader: NSObject {
    
    
    func uploadTrip(trip: Trip) {
        
        getStartingPointNameForTrip(trip: trip)
        
    }
    
    
    func getStartingPointNameForTrip(trip: Trip) {
        let location = CLLocation(latitude: trip.originLatitude, longitude: trip.originLongitude) //changed!!!
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                self.uploadTripToKinvey(trip: trip)
            }
                
            else  {
                if (placemarks?.count)! > 0 {
                    let pm = (placemarks?[0])! as CLPlacemark
                    trip.originName = pm.locality!
                    self.uploadTripToKinvey(trip: trip)
                }
                else {
                    self.uploadTripToKinvey(trip: trip)
                }
            }
            
        })
    }
    
    
    func uploadTripToKinvey(trip: Trip) {
        let collection = KCSCollection(from: "Trip", of: Trip.self)
        let store = KCSAppdataStore(collection: collection, options: nil)
        _ = store?.save(trip, withCompletionBlock: { (results, error) in
            if error != nil {
                print(error!)
            }
            else {
                print("Saved Trip\((results?[0] as! NSObject).kinveyObjectId())")
                let RI = RealmInteractor()
                RI.saveTrip(trip: trip)
            }
        }, withProgressBlock: nil)
    }
    
    
    
    
    
    
}
