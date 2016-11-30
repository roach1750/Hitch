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
    
    let userFetcher = User()

    
    var selectedTrip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("The user who created this trip has an ID that is: \( selectedTrip?.creatorUserID)")
        
        userFetcher.fetchUser(withID: selectedTrip!.creatorUserID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(SeletedPassengerVC.userFetched), name: NSNotification.Name(rawValue: "UserDownloaded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SeletedPassengerVC.userPictureFetched), name: NSNotification.Name(rawValue: "UserPictureDownloaded"), object: nil)


    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "UserDownloaded"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "UserPictureDownloaded"), object: nil)

    }
    
    
    
    func userFetched() {
        let firstName = userFetcher.fetchedUser?.givenName
        let lastName = userFetcher.fetchedUser?.surname
        let passengerName = firstName! + " " + lastName!
        passengerNameLabel.text = passengerName
        print(userFetcher.fetchedUser!)
        userFetcher.fetchFBUserProfilePicture(id: "10207801610258024")
    }
    
    func userPictureFetched(){
        passengerImageView.image = UIImage(data: userFetcher.fetchedUserPicture!)
    }
    
    
    func setStarFill(withValue: Int){
        
    }
    
    
    
    
    
    
    
    @IBAction func requestButtonPressed(_ sender: UIBarButtonItem) {
        
        
    }
    
    
    
    
    



}
