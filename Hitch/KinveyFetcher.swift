//
//  KinveyFetcher.swift
//  Hitch
//
//  Created by Andrew Roach on 11/1/16.
//  Copyright © 2016 Andrew Roach. All rights reserved.
//

import UIKit

class KinveyFetcher: NSObject {

    
    
    func configurePlaceQuery() -> KCSQuery {
        //Everyone Query
        let query = KCSQuery()
        return query
    }
    
    func fetchAllWaypoints() {
        let collection = KCSCollection(from: "Waypoint", of: Waypoint.self)
        let store = KCSAppdataStore(collection: collection, options: nil)
        
        _ = store?.query(withQuery: configurePlaceQuery(), withCompletionBlock: { (downloadedData, errorOrNil) in
            if let error = errorOrNil {
                print("Error from downloading posts data only: \(error)")
            }
            else {
                print("Fetch \(downloadedData?.count) waypoints from Kinvey")
            }
        },
                         withProgressBlock: { (objects, percentComplete) in
        })
    }
}
