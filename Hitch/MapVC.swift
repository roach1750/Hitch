//
//  MapVC.swift
//  Hitch
//
//  Created by Andrew Roach on 10/20/16.
//  Copyright © 2016 Andrew Roach. All rights reserved.
//

import UIKit
import MapKit
import  GooglePlaces


class MapVC: UIViewController, MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource{
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var driverSwitch: UISwitch!
    
    let GPF = GooglePlaceFetcher.sharedInstance
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocationData()
        tableView.isHidden = true
        print("User Is: \(KCSUser.active())")
        NotificationCenter.default.addObserver(self, selector: #selector(MapVC.reloadTable), name: NSNotification.Name(rawValue: "GoogleAutoCompleteDone"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MapVC.addPlaceToMap), name: NSNotification.Name(rawValue: "GMSPlaceDownloaded"), object: nil)
        
        let tgr = UITapGestureRecognizer(target: self, action: #selector(MapVC.titleTapped))
        tgr.numberOfTapsRequired = 1
        self.navigationController?.navigationBar.subviews[1].isUserInteractionEnabled = true
        self.navigationController?.navigationBar.subviews[1].addGestureRecognizer(tgr)
        self.title = "Hitch"
    }
    
    func titleTapped() {
        let kUP = KinveyUploader()
        let sourceWaypoint = Waypoint()
        sourceWaypoint.location = currentLocation!
        sourceWaypoint.isDestination = NSNumber(booleanLiteral: false)
        sourceWaypoint.user = KCSUser.active()
        sourceWaypoint.driver =  NSNumber(booleanLiteral: driverSwitch.isOn)
        sourceWaypoint.matched = false
        kUP.uploadWayPoint(wayPoint: sourceWaypoint)
        
        let destinationWaypoint = Waypoint()
        destinationWaypoint.isDestination = NSNumber(booleanLiteral: true)
        destinationWaypoint.user = KCSUser.active()
        destinationWaypoint.driver =  NSNumber(booleanLiteral: driverSwitch.isOn)
        destinationWaypoint.matched = false
        destinationWaypoint.location = CLLocation(latitude: (GPF.currentResult?.coordinate.latitude)!, longitude: (GPF.currentResult?.coordinate.longitude)!)
        kUP.uploadWayPoint(wayPoint: destinationWaypoint)
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
    
    @IBAction func clearButtonPressed(_ sender: UIBarButtonItem) {
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
        mapView.removeAnnotations(mapView.annotations)
        let center = CLLocationCoordinate2DMake(currentLocation!.coordinate.latitude, currentLocation!.coordinate.longitude)
        let region = MKCoordinateRegionMake(center, MKCoordinateSpanMake(0.05, 0.05))
        mapView.setRegion(region, animated: true)
        self.title = "Hitch"
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchBar.text == "" {
            let RI = RealmInteractor()
            let data = RI.fetchFavoritePlaces()
            return (data?.count)!
        }
        
        else if GPF.results != nil {
            return GPF.results!.count
        }
        else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if searchBar.text == "" {
            let RI = RealmInteractor()
            let data = RI.fetchFavoritePlaces()
            cell.textLabel?.text = data?[indexPath.row].placeName
        }
        else {
            
            let autocompletePlace = GPF.results?[indexPath.row]
            cell.textLabel?.text = autocompletePlace?.attributedFullText.string
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if searchBar.text == "" {
            let RI = RealmInteractor()
            let data = RI.fetchFavoritePlaces()
            let favoritePlace = data?[indexPath.row]
            GPF.fetchPlaceForAutocompletePrediction(prediction: nil, id: (favoritePlace?.placeID)!)
        }
        else {
            let destination = GPF.results?[indexPath.row]
            GPF.fetchPlaceForAutocompletePrediction(prediction: destination!, id: (destination?.placeID)!)
        }
        
        tableView.isHidden = true
        searchBar.resignFirstResponder()
        searchBar.text = ""
        
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = false
        tableView.reloadData()
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        let GPF = GooglePlaceFetcher.sharedInstance
        
        let nePoint = CGPoint(x: self.mapView.bounds.origin.x + mapView.bounds.size.width, y: mapView.bounds.origin.y)
        let swPoint = CGPoint(x: self.mapView.bounds.origin.x, y: (mapView.bounds.origin.y + mapView.bounds.size.height))
        let neCord = mapView.convert(nePoint, toCoordinateFrom: mapView)
        let swCord = mapView.convert(swPoint, toCoordinateFrom: mapView)
        
        let bounds = GMSCoordinateBounds(coordinate: neCord, coordinate: swCord)
        
        GPF.fetchPlacesForString(string: searchText, bounds: bounds)
    }
    
    func addPlaceToMap() {
        if let place = GPF.currentResult {
            let mapPin = WaypointMapAnnotation(title: place.name, subtitle: nil, coordinate: place.coordinate, color: UIColor.red)
            mapView.addAnnotation(mapPin)
            mapView.selectAnnotation(mapPin, animated: true)
            calculateRouteToPlace(place: place)
        }
    }
    
    func calculateRouteToPlace(place: GMSPlace) {
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: (currentLocation?.coordinate)!))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: place.coordinate))
        request.transportType = .automobile
        
        request.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: request)
        
        directions.calculate { (response, error) in
            if error == nil {
                let route = response?.routes[0]
                
                
                let pointCount = route?.polyline.pointCount
                
                let coordsPointer = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: pointCount!)
                
                route?.polyline.getCoordinates(coordsPointer, range: NSRange(location: 0, length: pointCount!))
                
                
                var coords: [Dictionary<String, AnyObject>] = []
                
                var latArray = [Double]()
                var longArray = [Double]()

                
                
                for i in 0..<pointCount! {
                    let latitude = NSNumber(value: coordsPointer[i].latitude)
                    let longitude = NSNumber(value: coordsPointer[i].longitude)

                    latArray.append(Double(latitude))
                    longArray.append(Double(longitude))
                    
                    let coord = ["latitude" : latitude, "longitude" : longitude]
                    coords.append(coord)
                }
                
                let factor = 0.005
                let minX = latArray.min()! - factor
                let maxX = latArray.max()! + factor
                let minY = longArray.min()! - factor
                let maxY = longArray.max()! + factor
                

                
                let point1 = CLLocationCoordinate2DMake(CLLocationDegrees(minX), CLLocationDegrees(minY))
                let point2 = CLLocationCoordinate2DMake(CLLocationDegrees(maxX), CLLocationDegrees(minY))
                let point3 = CLLocationCoordinate2DMake(CLLocationDegrees(maxX), CLLocationDegrees(maxY))
                let point4 = CLLocationCoordinate2DMake(CLLocationDegrees(minX), CLLocationDegrees(maxY))
                let points = [point1, point2, point3, point4, point1]
                
                for point in points {
                    let wMA = WaypointMapAnnotation(title: nil, subtitle: nil, coordinate: CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude), color: UIColor.green)
                    
                    self.mapView.addAnnotation(wMA)
                }
                
//                self.addCoordsToMap(coords: coords)
                self.mapView.addOverlays([(route?.polyline)!], level: .aboveRoads)
                self.title = "Click to Upload"
                
                
                self.addOverlay(points: points)
                
            }
        }
    }
    
    func addOverlay(points: [CLLocationCoordinate2D])
    {
        let polygon = MKPolygon(coordinates: points, count: points.count)
        self.mapView.add(polygon)
    }
    
    
    func addCoordsToMap(coords:[Dictionary<String, AnyObject>] ) {
        for dictPair in coords {
            let lat = dictPair["latitude"]!
            let long = dictPair["longitude"]!
            
            let mapPin = WaypointMapAnnotation(title: nil, subtitle: nil, coordinate: CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: long as! CLLocationDegrees), color: UIColor.green)

            mapView.addAnnotation(mapPin)
            
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        if (overlay is MKPolyline) {
            polylineRenderer.strokeColor = UIColor.blue.withAlphaComponent(0.75)
            polylineRenderer.lineWidth = 5
            mapView.setVisibleMapRect(overlay.boundingMapRect, edgePadding: UIEdgeInsetsMake(50.0, 50.0, 50.0, 50.0), animated: true)
        }
        
        else if (overlay is MKPolygon) {
            
            polylineRenderer.fillColor = UIColor.black
            polylineRenderer.strokeColor = UIColor.green.withAlphaComponent(1.0)

            polylineRenderer.alpha = 1.0
            polylineRenderer.lineWidth = 5

        }
        
        return polylineRenderer
    }
    
    
    
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
    
    
    
    
    
    
    func requestLocationData() {
        let location: PrivateResource = .location(.whenInUse)
        proposeToAccess(location, agreed: {
            self.locationManager = CLLocationManager()
            self.locationManager!.delegate = self
            self.locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager!.startUpdatingLocation()
            }, rejected: {
                print("Location denied")
        })
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let region = MKCoordinateRegionMake(center, MKCoordinateSpanMake(0.05, 0.05))
            currentLocation = location
            mapView.setRegion(region, animated: true)
            mapView.showsUserLocation = true
            mapView.delegate = self
            locationManager!.stopUpdatingLocation()
            locationManager = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}



