//
//  kinveyUploader.swift
//  Hitch
//
//  Created by Andrew Roach on 10/21/16.
//  Copyright © 2016 Andrew Roach. All rights reserved.
//

import UIKit

class KinveyUploader: NSObject {
    
    
    func uploadWayPoint(wayPoint: Waypoint) {
        
        let collection = KCSCollection(from: "Waypoint", of: Waypoint.self)
        let store = KCSAppdataStore(collection: collection, options: nil)
        
        _ = store?.save(wayPoint, withCompletionBlock: { (results, error) in
            if error != nil {
                print(error as! String)
            }
            else {
                print("Saved Waypoint\((results?[0] as! NSObject).kinveyObjectId())")
            }
            }, withProgressBlock: nil)
        
    }
    
}
