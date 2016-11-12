//
//  ResultsMapVC.swift
//  Hitch
//
//  Created by Andrew Roach on 11/11/16.
//  Copyright © 2016 Andrew Roach. All rights reserved.
//

import UIKit
import MapKit

class ResultsMapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var tableView: UITableView!
    
    let kF = KinveyFetcher()

    
    var seletedTrip: Trip? {
        didSet{
            kF.fetchAllTrips()
        }
    }
    
    var tripResults: [Trip]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ResultsMapVC.reloadTable), name: NSNotification.Name(rawValue: "TripsFetched"), object: nil)
    }

    func reloadTable(){
        tripResults  = kF.tripResults
        
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tripResults != nil {
            return (tripResults?.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        
        if let trip = tripResults?[indexPath.row] {
            cell.textLabel?.text = "From " + trip.originName + " To " + trip.destinationName
        }
        
        return cell
    
    
    }

    
    
    
}
