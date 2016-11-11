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
    
    var trip = Trip()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originLabel.text = trip.originName + " Depature Time"
        destinationLabel.text = trip.destinationName + " Arrival Time"
    }
    
    @IBAction func uploadButtonPressed(_ sender: UIBarButtonItem) {
        
        trip.originDate = originDatePicker.date as NSDate
        trip.destinationDate = destinationDatePicker.date as NSDate
        

        
        let kUP = KinveyUploader()
        kUP.uploadTrip(trip: trip)
        
        let RI = RealmInteractor()
        RI.saveTrip(trip: trip)
        
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
