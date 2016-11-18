//
//  SeletedPassengerVC.swift
//  Hitch
//
//  Created by Andrew Roach on 11/16/16.
//  Copyright © 2016 Andrew Roach. All rights reserved.
//

import UIKit
import MapKit

class SeletedPassengerVC: UIViewController {

    @IBOutlet weak var overallMapView: MKMapView!
    @IBOutlet weak var pickupLocationMapView: MKMapView!
    @IBOutlet weak var dropOffLocationMapView: MKMapView!
    
    @IBOutlet weak var passengerImageView: UIImageView!
    @IBOutlet weak var passengerNameLabel: UILabel!
    @IBOutlet var stars: [UIImageView]!
    
    @IBOutlet weak var pickUpTimeLabel: UILabel!
    @IBOutlet weak var dropOffTimeLabel: UILabel!
    
    var selectedTrip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func requestButtonPressed(_ sender: UIBarButtonItem) {
        
        
    }
    
    
    
    
    



}
