//
//  ConfigureWaypointsVC.swift
//  Hitch
//
//  Created by Andrew Roach on 11/2/16.
//  Copyright © 2016 Andrew Roach. All rights reserved.
//

import UIKit

class ConfigureWaypointsVC: UIViewController {
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var originDatePicker: UIDatePicker!
    @IBOutlet weak var destinationDatePicker: UIDatePicker!
    
    var destinationWaypoint: Waypoint!
    var originWaypoint: Waypoint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originLabel.text = originWaypoint.placeName! + " Depature Time"
        destinationLabel.text = destinationWaypoint.placeName! + " Arrival Time"
    }
    
    @IBAction func uploadButtonPressed(_ sender: UIBarButtonItem) {
        
        originWaypoint.date = originDatePicker.date
        destinationWaypoint.date = destinationDatePicker.date
        
        
        let cDI = CoreDataInteractor()
        let trip = cDI.createTrip(dLat: Double(destinationWaypoint!.location.coordinate.latitude),
                                  dLong: Double(destinationWaypoint!.location.coordinate.longitude),
                                  oLat: Double(originWaypoint!.location.coordinate.latitude),
                                  oLong: Double(originWaypoint.location.coordinate.longitude), date: Date())
        
                _ = Trip.tripWithTripInfo(trip, inManagedObjectContext: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
//        cDI.saveTripToCoreData(newTrip: trip)
        
        let kUP = KinveyUploader()
        kUP.uploadWayPoint(wayPoint: originWaypoint)
        kUP.uploadWayPoint(wayPoint: destinationWaypoint!)
        
        
        
        let allViewController: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        
        for aviewcontroller : UIViewController in allViewController
        {
            if aviewcontroller is TripsVC
            {
                _ = self.navigationController?.popToViewController(aviewcontroller, animated: true)
            }
        }
        
        
        
        
        
        
        
    }
    
}
