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
    
    let routeCalc = RouteCalculator.sharedInstance
    
    var seletedTrip: Trip? {
        didSet{
            routeCalc.calculateDirectionsForTrip(trip: seletedTrip!)
        }
    }
    
    var tripResults: [Trip]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRouteToMapForTrip(trip: seletedTrip!, color: UIColor.red)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(ResultsMapVC.reloadTable), name: NSNotification.Name(rawValue: "TripsFetched"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ResultsMapVC.fetchSimilarRoutes), name: NSNotification.Name(rawValue: "RouteCalculated"), object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "TripsFetched"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "RouteCalculated"), object: nil)
    }
    
    func fetchSimilarRoutes(){
        kF.getTripsOnSameRoute(polygon: routeCalc.routePolygonPonts!)
        
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
            cell.detailTextLabel?.text = ""
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let trip = tripResults?[indexPath.row] {
            if mapView.overlays.count > 1 {
                mapView.remove(mapView.overlays.last!)
                mapView.removeAnnotation(mapView.annotations.last!)
                mapView.removeAnnotation(mapView.annotations.last!)
            }
            addRouteToMapForTrip(trip: trip, color: UIColor.blue)
        }
    }
    
    
    
    

    var currentRouteColor = UIColor()
    var currentOverlay: MKOverlay?
    
    
    
    func addRouteToMapForTrip(trip: Trip, color: UIColor){
        
        currentRouteColor = color
        
        //Add the start and ending pins first:
        let mapPinOrigin = WaypointMapAnnotation(title: nil, subtitle: nil, coordinate: CLLocationCoordinate2D(latitude: trip.originLatitude, longitude: trip.originLongitude), color: currentRouteColor)
        mapView.addAnnotation(mapPinOrigin)
        
        let mapPinDestination = WaypointMapAnnotation(title: nil, subtitle: nil, coordinate: CLLocationCoordinate2D(latitude: trip.destinationLatitude, longitude: trip.destinationLongitude), color: currentRouteColor)
        mapView.addAnnotation(mapPinDestination)

        //Add the polyLine
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: (CLLocationCoordinate2DMake((trip.originLatitude), (trip.originLongitude)))))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: (CLLocationCoordinate2DMake((trip.destinationLatitude), (trip.destinationLongitude)))))
        request.transportType = .automobile
        
        request.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: request)
        
        directions.calculate { (response, error) in
            if error == nil {
                let route = response?.routes[0]
                self.mapView.add((route?.polyline)!)
            }
        }
    }
    
    //Polyline configurer
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        if (overlay is MKPolyline) {
            polylineRenderer.strokeColor = currentRouteColor
            polylineRenderer.lineWidth = 5
            mapView.setVisibleMapRect(overlay.boundingMapRect, edgePadding: UIEdgeInsetsMake(50.0, 50.0, 50.0, 50.0), animated: false)
        }
        
        
        return polylineRenderer
    }
    
    
    //pin configurer
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation.isKind(of: MKUserLocation.self)
        {
            return nil
        }
        else if annotation.isKind(of: WaypointMapAnnotation.self){
            let waypointAnnotation = annotation as! WaypointMapAnnotation
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pinAnnotationView.pinTintColor = waypointAnnotation.color
            pinAnnotationView.canShowCallout = waypointAnnotation.title == nil ? false : true
            
            
            return pinAnnotationView
        }
        else {
            return nil
        }
    }
    
    
    
    
    
    
}
