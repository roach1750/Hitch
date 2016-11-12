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
