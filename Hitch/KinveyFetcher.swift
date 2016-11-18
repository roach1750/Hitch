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
    
    
    func getTripsOnSameRoute(polygon: [CLLocationCoordinate2D]) {
        
        var points = [[Double]]()
        
        for point in polygon {
            let group = [Double(point.latitude), Double(point.longitude)]
            points.append(group)
        }
        
        KCSCustomEndpoints.callEndpoint("queryWithinPolygon", params: ["polygon":points]) { (results, error) in
            if error == nil {
                self.fetchTripObjectsWithIDs(ids: results as! [String])
            } else {
                print("Polygon Error: \(error as! String)")
            }
        }
    }
    
    func fetchTripObjectsWithIDs(ids: [String]) {
        
        
        let collection = KCSCollection(from: "Trip", of: Trip.self)
        let store = KCSAppdataStore(collection: collection, options: nil)
        
        let query = KCSQuery(onField: "_id", using: .kcsIn, forValue: ids as NSObject!)
        
        _ = store?.query(withQuery: query, withCompletionBlock: { (results, error) in
            
            print("Fetched \((results?.count)!) Trips")
            self.tripResults = results as! [Trip]?
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "TripsFetched"), object: nil)
            
        }, withProgressBlock: nil)
        
        
        
    }
    
    func fetchAllTrips(){
        
        let collection = KCSCollection(from: "Trip", of: Trip.self)
        let store = KCSAppdataStore(collection: collection, options: nil)
        
        _ = store?.query(withQuery: KCSQuery(), withCompletionBlock: { (results, error) in
            if error == nil {
                //                print("Fetched \((results?.count)!) Trips")
                //                self.tripResults = results as! [Trip]?
                //
                //                NotificationCenter.default.post(name: Notification.Name(rawValue: "TripsFetched"), object: nil)
                
            }
            else {
                print(error!)
            }
            
        }, withProgressBlock: nil)
    }
    
    
    
}
