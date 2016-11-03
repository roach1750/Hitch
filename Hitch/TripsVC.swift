//
//  TripsVC.swift
//  Hitch
//
//  Created by Andrew Roach on 10/27/16.
//  Copyright © 2016 Andrew Roach. All rights reserved.
//

import UIKit

class TripsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func reloadData(_ sender: UIBarButtonItem) {
        let cDI = CoreDataInteractor()
        cDI.fetchAllTripsFromCoreData()

    }
    
    @IBAction func deleteAllData(_ sender: UIBarButtonItem) {
        let cDI = CoreDataInteractor()
        cDI.deleteAllPostFromCoreDatabase()
    }
    


    
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
        
        // Configure the cell...
        
        return cell
    }

    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
