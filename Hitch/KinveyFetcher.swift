//
//  KinveyFetcher.swift
//  Hitch
//
//  Created by Andrew Roach on 11/1/16.
//  Copyright © 2016 Andrew Roach. All rights reserved.
//

import UIKit

class KinveyFetcher: NSObject {

    var tripResults: [Trip]?
    
    class var sharedInstance: KinveyFetcher {
        struct Singleton {
            static let instance = KinveyFetcher()
        }
        return Singleton.instance
    }
    
    
    func fetchAllTrips(){
        
        let collection = KCSCollection(from: "Trip", of: Trip.self)
        let store = KCSAppdataStore(collection: collection, options: nil)

        _ = store?.query(withQuery: KCSQuery(), withCompletionBlock: { (results, error) in
            if error == nil {
                print("Fetched \((results?.count)!) Trips")
                self.tripResults = results as! [Trip]?
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "TripsFetched"), object: nil)

            }
            else {
                print(error!)
            }
            
        }, withProgressBlock: nil)
    }

    func fetchTripObjectsWithIDs(ids: [String]) {
        

        
    }
    
    
    
    
}
